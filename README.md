# Build-and-deploy-a-stroke-prediction-model-using-R

This repository holds the stroke risk prediction project.

The stroke risk prediction project was built and evaluated using R Markdown and was deployed using R Shiny. The R Markdown and R Shiny files are committed to this GitHub repository.

### Project Overview

According to the World Health Organization (WHO) stroke is the 2nd leading cause of death globally, responsible for approximately 11% of total deaths. This project utilized machine learning techniques to predict the risk of stroke based on various demographic, clinical, and lifestyle factors. By leveraging multiple models, this study aimed to identify the most effective prediction model and evaluate its performance metrics. The dataset used included variables such as age, gender, average glucose level, BMI, hypertension, heart disease, marital status, work type, residence type, and smoking status. The outcome variable was stroke. Since stroke (“0”, “1”, or “Yes”, “No”) is a binary classification variable, we deployed five binary classification models to answer our research question.

### Machine Learning Models Used

Logistic Regression: A baseline statistical model commonly used for binary classification problems. It was used to provide a reference point for model performance. Logistic regression has interpretable coefficients that indicate the relationship between predictors and the probability of stroke. The logistic regression achieved an accuracy of 94.75% but had a low ROC AUC score of 0.15, indicating poor discrimination for positive cases.

Random Forest: A robust ensemble model that combines multiple decision trees to reduce overfitting and improve generalization. The random forest model achieved high accuracy (94.75%) and perfect recall (1.00), but a low ROC AUC score (0.17), highlighting challenges in ranking probabilities effectively.

Support Vector Machine (SVM): Suitable for complex relationships in data, with its ability to map features into high-dimensional space for better separation. The SVM model achieved an accuracy of 91.86% with an improved ROC AUC score (0.34). This model balanced precision and recall, making it a better candidate for stroke prediction compared to Random Forest.

Decision Tree: Provides an intuitive representation of decision-making, making it easy for medical practitioners to interpret. The decision model achieved similar accuracy to Logistic Regression (94.75%), but its ROC AUC score was also limited (0.50). The model showed high precision (94.75%) and recall (100%), indicating its reliability in binary classification tasks.

XGBoost: A highly efficient and scalable gradient boosting model that is popular for tabular data. It handles missing data, reduces bias and variance, and provides strong predictive performance. The XGBoost model achieved the highest accuracy (94.52%) and ROC AUC (0.16). It showed excellent recall (99.75%) and precision (94.75%).

### Performance Metrics

Key metrics were used to evaluate model performance, providing insight into classification accuracy and balance between false positives and negatives of stroke risk prediction. Accuracy: The proportion of correct predictions out of all predictions. ROC AUC: Measures the ability of the model to distinguish between classes. Precision: Indicates the proportion of positive identifications that were correct. Recall (Sensitivity): Proportion of actual positives correctly identified. F1-Score: The harmonic mean of precision and recall, balancing the two.

### Findings

Logistic Regression and Decision Tree achieved similar accuracy but performed poorly in ROC AUC, indicating challenges in ranking probabilities for positive cases. SVM demonstrated a balance between precision and recall, but its ROC AUC score (0.34) suggested room for improvement. Random Forest and XGBoost exhibited high recall, crucial for identifying true positives in stroke prediction, but suffered from low ROC AUC scores.

Models like Random Forest and XGBoost had perfect recall, predicting all true positives effectively, but also showed false positives, reducing precision. Logistic Regression struggled with positive cases, as evidenced by lower recall and ROC AUC scores.

Random Forest and XGBoost provided insights into feature importance, with age, average glucose level, and BMI emerging as the most significant predictors of stroke risk. Lifestyle factors, such as smoking status and work type, were less impactful but still contributed to model predictions.

The dataset had a significant class imbalance, with a majority of negative cases. This affected metrics like ROC AUC and precision. Most models struggled to differentiate positive cases effectively, as reflected in low ROC AUC values.

XGBoost emerged as the best model for stroke prediction, balancing high accuracy, precision, and recall while handling complex feature interactions effectively. SVM provided a reliable alternative, especially when precision and recall needed to be balanced.

Clinical factors like age, BMI, and average glucose level significantly influenced stroke predictions, highlighting the need for targeted interventions in at-risk populations. Demographic and lifestyle factors had secondary importance, suggesting opportunities for public health campaigns.

### Practical Implications:

The findings can guide clinicians in early stroke risk assessment, especially for patients with elevated glucose levels or BMI. Models with high recall, like Random Forest and XGBoost, can be deployed in medical settings to minimize missed diagnoses.

### Future Work:

Using techniques like SMOTE (Synthetic Minority Oversampling Technique) or undersampling to balance classes could improve performance. Combining predictions from multiple models could enhance overall performance. Validating models on external datasets or in clinical settings would ensure robustness and reliability.

### Recommendations

Deploy XGBoost or Random Forest in Clinical Settings: These models demonstrated high sensitivity, ensuring that high-risk patients are not missed.

Focus on Data Quality: Collecting more balanced datasets with equal representation of stroke-positive cases can improve model generalizability.

Integrate Risk Models into Decision Support Systems: Embedding models into electronic health records can aid clinicians in real-time risk assessment.

Educate Stakeholders: Public health officials and clinicians should be trained to interpret model outputs and leverage insights for preventive care.
