# Taxi Trip Duration Prediction

This project prepares taxi trip data with Apache Pig and compares Python
regression models for trip-duration prediction.

## 📊 Model Analysis Dashboard

### Model Comparison

![Model comparison](docs/images/model_comparison.png)

### Feature Importance

![Feature importance](docs/images/feature_importance.png)

## 📈 Results

The Random Forest model performed best on the held-out test set:

- **MAE:** 243.90 seconds
- **RMSE:** 361.69 seconds
- **R²:** 0.7032

It outperformed the Decision Tree, Gradient Boosting, and Linear Regression
models on all three reported metrics. The R² score indicates that the Random
Forest explained approximately 70% of the variation in trip duration for this
evaluation.

## 🛠️ Technologies Used

- Apache Pig — data preprocessing
- Python — feature engineering and modeling
- Pandas and NumPy — data manipulation
- Scikit-learn — machine learning
- Matplotlib — visualizations

## 📈 Evaluation Metrics

- MAE: Mean Absolute Error
- RMSE: Root Mean Squared Error
- R²: Coefficient of Determination
