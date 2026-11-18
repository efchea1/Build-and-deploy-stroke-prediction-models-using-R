# Build-and-deploy-a-stroke-prediction-model-using-R

This repository holds the stroke risk prediction project.

The stroke risk prediction project was built and evaluated using R Markdown and was deployed using R Shiny. The R Markdown and R Shiny files are committed to this GitHub repository.

### Project Overview

According to the World Health Organization (WHO), stroke is the 2nd leading cause of death globally, responsible for approximately 11% of total deaths. This project used machine learning to predict the risk of stroke from demographic, clinical, and lifestyle factors: age, gender, average glucose level, BMI, hypertension, heart disease, marital status, work type, residence type, and smoking status. The outcome variable was stroke (Yes/No), so five binary classification models were trained and compared.

### Data and Evaluation Setup

- 5,110 patients; split 75/25 into training and test sets (`set.seed(123)`).
- The test set has **1,278 patients, of whom 67 (5.2%) had a stroke.** Because the classes are so imbalanced, a model that predicts "No stroke" for everyone already reaches about 94.8% accuracy. Accuracy alone is therefore not a useful measure here.
- Models were compared on ROC AUC (how well predicted probabilities rank stroke patients above non-stroke patients), PR AUC, and sensitivity and specificity at the default 0.5 probability threshold, all with **stroke = "Yes" as the event of interest**.

### Correction (November 2026)

An earlier version of this README reported ROC AUC values of 0.15–0.34 and recall near 1.00. Those numbers were computed with the wrong event level: the outcome's factor levels are `No`, `Yes`, and yardstick treats the first level (`No`) as the event by default. As a result, ROC AUC was reported as 1 − AUC, and precision and recall described the "No stroke" class instead of stroke. The evaluation code now uses `event_level = "second"`, and the results below are from a rerun of the same pipeline and seed.

### Results (test set, stroke = event)

| Model | ROC AUC | PR AUC | Sensitivity @ 0.5 | Specificity @ 0.5 | Strokes flagged (of 67) |
|---|---|---|---|---|---|
| Logistic Regression | **0.85** | 0.23 | 1.5% | 99.9% | 1 |
| XGBoost | 0.84 | 0.20 | 1.5% | 99.8% | 1 |
| Random Forest | 0.83 | 0.20 | 0.0% | 100% | 0 |
| Support Vector Machine | 0.65 | 0.10 | 9.0% | 96.2% | 6 |
| Decision Tree | 0.50 | n/a* | 0.0% | 100% | 0 |

\*The decision tree made no splits and gives every patient the same probability, so it has no ranking ability (AUC 0.50).

Accuracy was about 94.6–94.8% for every model except SVM (91.6%), close to the 94.8% a "predict No for everyone" baseline achieves.

### Findings

1. **Logistic regression, XGBoost, and random forest rank stroke risk well (ROC AUC 0.83–0.85).** The simplest model, logistic regression, performed as well as the more complex ones.
2. **At the default 0.5 threshold, no model is useful for catching strokes.** The best models flagged at most 1 of the 67 stroke patients. With only about 5% positive cases, predicted probabilities rarely exceed 0.5, so the models default to "No stroke."
3. **Accuracy is misleading on imbalanced data.** High accuracy here mostly reflects the 95% of patients who did not have a stroke.
4. **Key predictors:** in the logistic regression, age (p < 0.001), average glucose level (p = 0.003), and hypertension (p = 0.004) were significant; BMI was not. Age was also the most important variable in the random forest (permutation importance).

### Recommendations

- **Choose the decision threshold deliberately.** Select a threshold that reaches a target sensitivity (for example, 80%) on validation data, rather than using 0.5, and report the resulting specificity and number of false positives.
- **Address class imbalance** with class weights, down-sampling, or SMOTE, tuned with cross-validation and stratified splitting (`initial_split(..., strata = stroke)`).
- **Report imbalance-aware metrics** (ROC AUC, PR AUC, sensitivity, specificity, calibration) instead of accuracy.
- **Validate externally** before any clinical use. This project is a learning exercise on a public dataset and is not a clinical decision tool.

### Shiny App

`app.R` lets users enter patient characteristics and see each model's predicted stroke probability with low/moderate/high risk badges, view model metrics and confusion matrices, and download results.

### Tools

R, tidymodels (recipes, parsnip, workflows, yardstick), glm, ranger, kernlab, rpart, xgboost, R Shiny.

📄 License
This project is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License.

© 2025 Emmanuel Fle Chea. See the LICENSE file for full terms and usage guidelines.
