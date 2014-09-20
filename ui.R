# ui.R

# The goal of this application is to perform some basic data exploration
# and to fit linear regressions based on a given dataset.

library(shiny)
library(ggplot2)

# The mtcars dataset is chosen as an example. 
dataset <- mtcars

# A navigation page is be used, and three tabs will be created:
# "Analysis", "Help" and "About"
shinyUI(navbarPage("Dataset Explorer",
    
    # Fisrt tab: "Analysis".    
    tabPanel("Analysis",
        
        # The side panel contains user input components. 
        # In order to use different datasets, simply change the variables
        # names and descriptions to match the new dataset
        sidebarPanel(
            h2("Data exploration"),
            # Selection of variables to plot a histogram. Factor variables
            # were removed from the selection options
            h4("Choose variable to plot the histogram"),
            selectInput('hist', 'Histogram', c(names(dataset)[c(-2,-8,-9,-10,-11)],"gp100m","hppwt"), names(dataset)[[1]]),
            
            # Selection of variables to evaluate correlation, by plotting
            # a scatter plot and calculating the correlation between X and Y
            h4("Choose variables to evaluate correlation"),
            selectInput('x', 'X', c(names(dataset),"gp100m","hppwt"), names(dataset)[[3]]),
            selectInput('y', 'Y', c(names(dataset),"gp100m","hppwt"), names(dataset)[[1]]),
            selectInput('color', 'Color', c('None', 'cyl','vs','am','gear','carb')),
            
            h2("Linear Regression"),
            # For the linear regression, this selection provides different options
            # for fuel consumption
            h4("Choose the fuel consumption unit"),
            p("mpg: miles per gallon"),
            p("gp100m: gallons per 100 miles"),
            selectInput('unit', 'Fuel consumption unit', c('mpg','gp100m')),
            
            # Checkboxes let the user select variables to be
            # included in the model
            h4("Choose the variables to be included in the model"),
            checkboxInput('cyl', 'Number of cylinders'),
            checkboxInput('disp', 'Displacement (cu.in.)'),
            checkboxInput('hp', 'Gross horsepower'),
            checkboxInput('drat', 'Rear axle ratio'),
            checkboxInput('wt', 'Weight (lb/1000)'),
            checkboxInput('qsec', '1/4 mile time'),
            checkboxInput('vs', 'V/S'),
            checkboxInput('am', 'Transmission'),
            checkboxInput('gear', 'Number of forward gears'),
            checkboxInput('carb', 'Number of carburetors'),
            checkboxInput('hppwt', 'Horsepower divided by weight')
        ),
    
        # The results are presented on the main panel.
        # The captions of the outputs (text in the h4() command) are
        # self explanatory.
        mainPanel(
            p("In case you need instructions on how to use this application, access the Help page on the Navigation Bar above."),
            h4("Histogram"),
            plotOutput('hist'),
            h4("Scatter Plot"),
            plotOutput('corplot'),
            h4("Correlation between X and Y"),
            verbatimTextOutput("corvalue"),
            h4("Linear regression formula"),
            verbatimTextOutput("formula"),
            h4("Linear regression"),
            verbatimTextOutput("model"),
            h4("Coefficient confidence intervals"),
            verbatimTextOutput("modelconfint"),
            h4("Linear regression - Residuals plots"),
            plotOutput('resplot')
        )
    ),
    
    # Second tab: "Help". This tab presents instructions on how to use
    # the application
    tabPanel("Help",
             h2("Overview"),
             p("The Analysis tab is divided into two areas:"),
             p("1. User input section: grey box located on the left side of the window."),
             p("2. Results section: located to the right of the user input section. This section is updated as soon as new inputs are entered by the user."),
             p("Descriptions of the variables can be found in the About tab."),
             h2("Details"),
             p("The following tasks can be performed using this application:"),
             h3("Data exploration"),
             p("- Histogram, based on the Histogram drop-down list available in the input section."),
             p("- Scatter plot, based on X, Y and Color drop-down lists available in the input section. Note that only factor variables are available in the Color drop-down list."),
             p("- Correlation between X and Y. Correlation is not calculated if X or Y is a factor."),
             
             h3("Linear regression"),
             p("- Linear regression formula, based on the variables selected by the user via the response drop down list (fuel consumption unit) and the checkboxes in the input section."),
             p("- Model summary."),
             p("- Confidence intervals of the regression coefficients."),
             p("- Plots of the regression residuals.")
             
             
    ),
    
    # Third tab: "About". This tab mainly text and one datatable 
    tabPanel("About",
             h2("Author"),
             p("JKuntze"),
             
             h2("Useful links"),
             p("The source code of this application can be found at http://www.github.com/jkuntze/DDP_shinyapp"),
             p("A presentation about the application is available at http://jkuntze.github.io/DDP_slidify"),
             
             h2("Dataset"),
             p("The mtcars dataset was used to demonstrate how to build a shiny app to explore data, produce linear regresions and evaluate their validity."),
             h3("Description"),
             p("The data was extracted from the 1974 Motor Trend US magazine, and comprises fuel consumption and 10 aspects of automobile design and performance for 32 automobiles (1973–74 models)."),
             
             h3("Variables"),
             dataTableOutput('desctable'),
            
             h2("References"),
             p("Brian Caffo, PhD, Jeff Leek, PhD, Roger D. Peng, PhD, Developing Data Products - Coursera"),
             p("mtcars help file, R Documentation"),
             p("Henderson and Velleman (1981), Building multiple regression models interactively. Biometrics, 37, 391–411.")     
    )  
   
))