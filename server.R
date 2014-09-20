# server.R

# The goal of this application is to perform some basic data exploration
# and to fit linear regressions based on a given dataset.

library(shiny)
library(ggplot2)

# Function to support the creation of the linear regression formula.
# It checks whether the character "+" should be added to the end of the
# argument, and it does so is needed. 
checkFormula <- function(x){
    lastchar<-substr(x, nchar(x), nchar(x))
    if(!(lastchar %in% c("~","+"))) {
        paste0(x,"+")
    } else {
        x
    }
}


shinyServer(function(input, output) {
    
    # The mtcars dataset is chosen as an example. 
    # Some variables are transformed into factors
    dataset <- mtcars
    dataset$cyl <- factor(dataset$cyl)
    dataset$vs <- factor(dataset$vs)
    dataset$am<-factor(dataset$am,c(0,1),c("Auto","Manual"))
    dataset$gear <- factor(dataset$gear)
    dataset$carb <- factor(dataset$carb)
    # New variables are created
    dataset$gp100m <- 100/dataset$mpg
    dataset$hppwt <- dataset$hp/dataset$wt
    
    # The histogram is processed in this section
    output$hist <- renderPlot({
        # calculation of the bin width, in order to have 10 bins
        rg<-range(dataset[,input$hist])
        bw<-(rg[2]-rg[1])/10
        ggplot(dataset, aes_string(x=input$hist)) + geom_histogram(binwidth = bw)
    }, height=400, width=500)
    
    # The scatter plot is processed in this section
    output$corplot <- renderPlot({   
        p <- ggplot(dataset, aes_string(x=input$x, y=input$y)) + geom_point()
        # add color to the plot in case a factor is selected in the user interface
        if (input$color != 'None')
            p <- p + aes_string(color=input$color)
        
        print(p)
        
    }, height=400, width=500)
    
    # The correlation between X and Y is calculated in this section
    # Correlation is not calculated if one of the variables is a factor
    output$corvalue <- renderText({
        if(class(dataset[,input$x])!="factor" & 
               class(dataset[,input$y])!="factor") {
            cor(dataset[,input$x],dataset[,input$y]) 
        } else {
            "One of the selected variables in treated as a factor. Correlation calculation is not available."
        }
    })
    
    # This section is used to update the linear regression formula
    # based on the variables selected by the user.
    get.formula<-reactive({
        
        if(input$cyl | input$disp | input$hp | input$drat | input$wt | 
               input$qsec | input$vs | input$am | input$gear | 
               input$carb | input$hppwt) {
            variables <- "~" 
            
            if(input$cyl) {
                variables<-paste0(checkFormula(variables),"cyl")    
            }    
            if(input$disp) {
                variables<-paste0(checkFormula(variables),"disp")    
            }
            if(input$hp) {
                variables<-paste0(checkFormula(variables),"hp")    
            }
            if(input$drat) {
                variables<-paste0(checkFormula(variables),"drat")    
            }
            if(input$wt) {
                variables<-paste0(checkFormula(variables),"wt")    
            }
            if(input$qsec) {
                variables<-paste0(checkFormula(variables),"qsec")    
            }
            if(input$vs) {
                variables<-paste0(checkFormula(variables),"vs")    
            }
            if(input$am) {
                variables<-paste0(checkFormula(variables),"am")    
            }
            if(input$gear) {
                variables<-paste0(checkFormula(variables),"gear")    
            }
            if(input$carb) {
                variables<-paste0(checkFormula(variables),"carb")    
            }
            if(input$hppwt) {
                variables<-paste0(checkFormula(variables),"hppwt")    
            }
            paste0(input$unit,variables)
            
        } else {
            NULL
        }
    })
    
    # The formula is made available to the user interface in this section
    output$formula<-renderText({
        formula<-get.formula()
        if(!is.null(formula)) {
            formula 
        } else {
            ""
        }
    })
    
    # The linear regression is processed in this section
    output$model <- renderPrint({ 
        formula<-get.formula()
        if(!is.null(formula)) {
            model<-lm(formula,data=dataset)
            summary(model)
        } else {
            "Choose predictors."
        }
    
    })
    
    # The confidence intervals of the regression coefficients are calculated
    # in this section 
    output$modelconfint <- renderPrint({ 
        formula<-get.formula()
        if(!is.null(formula)) {
            model<-lm(formula,data=dataset)
            confint(model)
        } else {
            "Choose predictors."
        }   
    })
    
    # The regression residuals plot is processed in this section 
    output$resplot <- renderPlot({
        formula<-get.formula()
        if(!is.null(formula)) {
            model<-lm(formula,data=dataset)
            par(mfcol=c(2,2))
            plot(model)
        }
        
    }, height=700)
    
    # The names and descriptions of the variables in the dataset are
    # included in a data frame, which will be displayed in the "About" tab
    output$desctable<-renderDataTable({
        Variables<-names(dataset)  
        Description<-c("Miles/(US) gallon",
                        "Number of cylinders",
                        "Displacement (cu.in.)",
                        "Gross horsepower",
                        "Rear axle ratio",
                        "Weight (lb/1000)",
                        "1/4 mile time",
                        "V/S",
                        "Transmission",
                        "Number of forward gears",
                        "Number of carburetors",
                        "Gallons per 100 miles",
                        "Horsepower divided by weight (lb/1000)")
        data.frame(Variables,Description)
    })
    
})