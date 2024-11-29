library(shiny)
library(tidyverse)
library(ggplot2)

# Load pre-saved data 
evaluation_results <- read.csv("evaluation_metrics.csv") # Added evaluation matrices
confusion_matrices <- readRDS("confusion_matrices.rds")  # Added confusion matrices

# Initialize Models with Error Handling
models <- list(
  Logistic_Regression = tryCatch(readRDS("logistic_regression_model.rds"), error = function(e) NULL),
  Random_Forest = tryCatch(readRDS("random_forest_model.rds"), error = function(e) NULL),
  Support_Vector_Machine = tryCatch(readRDS("support_vector_machine_model.rds"), error = function(e) NULL),
  Decision_Tree = tryCatch(readRDS("decision_tree_model.rds"), error = function(e) NULL),
  XGBoost = tryCatch(readRDS("xgboost_model.rds"), error = function(e) NULL)
)

# Define UI
ui <- fluidPage(
  titlePanel("Stroke Risk Dashboard"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("age", "Age (Years):", min = 0, max = 100, value = 50),
      numericInput("glucose", "Average Glucose Level (mg/dL):", value = 101, min = 0),
      numericInput("bmi", "BMI:", value = 25, min = 0),
      selectInput("gender", "Gender:", choices = c("Female", "Male")),
      selectInput("hypertension", "Hypertension:", choices = c("No", "Yes")),
      selectInput("heart_disease", "Heart Disease:", choices = c("No", "Yes")),
      selectInput("ever_married", "Ever Married:", choices = c("No", "Yes")),
      selectInput("work_type", "Work Type:", choices = c("children", "Govt_job", "Never_worked", "Private", "Self-employed")),
      selectInput("residence", "Residence Type:", choices = c("Rural", "Urban")),
      selectInput("smoking_status", "Smoking Status:", choices = c("never smoked", "formerly smoked", "smokes")),
      actionButton("predict", "Predict Stroke Risk"),
      downloadButton("downloadEval", "Download Evaluation Metrics"),
      downloadButton("downloadPred", "Download Predictions")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Model Predictions",
                 h4("Key Features"),
                 p("1. ", span("Color-Coded Probabilities:", style = "font-weight: bold"),
                   " Predictions are displayed with color coding for low, moderate, and high-risk probabilities."),
                 p("    - ", span("Low Risk:", style = "font-weight: bold; color: green"), " (Green, less than 20%)."),
                 p("    - ", span("Moderate Risk:", style = "font-weight: bold; color: yellow"), " (Yellow, between 20% and 50%)."),
                 p("    - ", span("High Risk:", style = "font-weight: bold; color: red"), " (Red, above 50%)."),
                 hr(),
                 h4("Predicted Probability of Stroke"),
                 fluidRow(
                   column(12, uiOutput("logistic_prediction")),
                   column(12, uiOutput("rf_prediction")),
                   column(12, uiOutput("svm_prediction")),
                   column(12, uiOutput("dt_prediction")),
                   column(12, uiOutput("xgb_prediction"))
                 )
        ),
        tabPanel("Model Performance Metrics",
                 tableOutput("evalTable")
        ),
        tabPanel("Model Confusion Matrix",  # New Tab
                 selectInput("modelSelect", "Select Model:", 
                             choices = names(confusion_matrices)),
                 tableOutput("confMatrix")
        )
      )
    )
  )
)

# Define Server
server <- function(input, output, session) {
  
  # Helper function to prepare data for prediction
  prepare_data <- reactive({
    tibble(
      age = input$age,
      avg_glucose_level = input$glucose,
      bmi = input$bmi,
      gender = input$gender,
      hypertension = input$hypertension,
      heart_disease = input$heart_disease,
      ever_married = input$ever_married,
      work_type = input$work_type,
      Residence_type = input$residence,
      smoking_status = input$smoking_status
    )
  })
  
  # Predictions with Error Handling
  observeEvent(input$predict, {
    new_data <- prepare_data()
    
    predict_and_display <- function(model, name) {
      if (is.null(model)) {
        return(HTML(paste0("<span style='color:red;'>", name, 
                           " - Error: Model not available.</span>")))
      }
      
      pred_prob <- predict(model, new_data, type = "prob")
      pred_class <- predict(model, new_data)
      prob <- round(pred_prob$.pred_Yes * 100, 2)
      class <- as.character(pred_class$.pred_class)
      color <- if (prob < 20) "green" else if (prob < 50) "yellow" else "red"
      
      HTML(paste0("<span style='color:", color, "'>", name, 
                  " - Probability: ", prob, "%, Predicted Class: ", class, "</span>"))
    }
    
    output$logistic_prediction <- renderUI({ predict_and_display(models$Logistic_Regression, "Logistic Regression") })
    output$rf_prediction <- renderUI({ predict_and_display(models$Random_Forest, "Random Forest") })
    output$svm_prediction <- renderUI({ predict_and_display(models$Support_Vector_Machine, "Support Vector Machine") })
    output$dt_prediction <- renderUI({ predict_and_display(models$Decision_Tree, "Decision Tree") })
    output$xgb_prediction <- renderUI({ predict_and_display(models$XGBoost, "XGBoost") })
  })
  
  # Display Evaluation Metrics
  output$evalTable <- renderTable({
    evaluation_results
  })
  
  # Display Confusion Matrices
  output$confMatrix <- renderTable({
    req(input$modelSelect)  # Ensure a model is selected
    selected_matrix <- confusion_matrices[[input$modelSelect]]
    as_tibble(selected_matrix$table)  # Convert the confusion matrix to a tibble for display
  })
  
  # Download Evaluation Metrics
  output$downloadEval <- downloadHandler(
    filename = function() { "evaluation_metrics.csv" },
    content = function(file) { file.copy("evaluation_metrics.csv", file) }
  )
  
  # Download Predictions
  output$downloadPred <- downloadHandler(
    filename = function() { "stroke_predictions.csv" },
    content = function(file) {
      new_data <- prepare_data()
      predictions <- tibble(
        Model = c("Logistic Regression", "Random Forest", "Support Vector Mechine", "Decision Tree", "XGBoost"),
        Probability = c(
          predict(models$Logistic_Regression, new_data, type = "prob")$.pred_Yes,
          predict(models$Random_Forest, new_data, type = "prob")$.pred_Yes,
          predict(models$Support_Vector_Machine, new_data, type = "prob")$.pred_Yes,
          predict(models$Decision_Tree, new_data, type = "prob")$.pred_Yes,
          predict(models$XGBoost, new_data, type = "prob")$.pred_Yes
        )
      )
      write.csv(predictions, file, row.names = FALSE)
    }
  )
}

# Run the Shiny App
shinyApp(ui = ui, server = server)