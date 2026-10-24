# PrepTrack: ML-Based Taxi Trip Prediction Tool Using Apache Pig and ML Algorithms

PrepTrack is a machine-learning tool that predicts taxi trip duration using
trip, location, passenger, and pickup-time information.

## Dataset

This project uses the [Kaggle NYC Taxi Trip Duration competition](https://www.kaggle.com/competitions/nyc-taxi-trip-duration/team).
The dataset contains pickup and drop-off locations, pickup time, passenger
count, vendor information, and the target trip duration.

## Apache Pig

Apache Pig is used as the data-preprocessing layer. The Pig scripts:

- clean invalid and missing records;
- filter unrealistic coordinates, passenger counts, and trip durations;
- prepare hourly trip statistics; and
- export a clean, machine-learning-ready dataset for Python.

This separates large-scale data preparation from model training and makes the
input data consistent and reproducible.

## Machine Learning

Python and scikit-learn are used to compare four regression algorithms:

- **Linear Regression:** A simple baseline that models trip duration as a
  weighted linear combination of the input features.
- **Decision Tree Regression:** Splits the data into feature-based regions and
  predicts a duration for each region. It can capture non-linear relationships
  but may overfit without appropriate constraints.
- **Random Forest Regression:** Combines predictions from many decision trees
  trained on different samples and feature subsets. This improves stability
  and usually reduces overfitting compared with a single tree.
- **Gradient Boosting Regression:** Builds trees sequentially, with each new
  tree correcting errors made by the previous trees. It can model complex
  patterns accurately but requires careful tuning.

Random Forest achieved the best reported results:

- **MAE:** 243.90 seconds
- **RMSE:** 361.69 seconds
- **R²:** 0.7032

## Visual Results

### Model Comparison

![Model comparison](docs/images/model_comparison.png)

### Feature Importance

![Feature importance](docs/images/feature_importance.png)

## Project Work

The project uses Apache Pig to clean the Kaggle taxi-trip data, remove invalid
records and outliers, and export a consistent dataset for machine learning.
The prepared data is then used to train and compare four regression algorithms.
The selected model estimates the expected duration of a taxi trip from the
details provided by the user.

## Judgement / Conclusion

This project demonstrates that machine-learning algorithms can predict taxi
trip duration from historical trip data. Apache Pig improves the reliability
of the system by performing structured data cleaning and preprocessing before
model training.

Random Forest Regression achieved the best performance and was selected as the
most suitable model for this project. The prediction tool can support travel
duration estimation, taxi-service planning, passenger information, and
transportation analysis. Predictions may still be affected by traffic,
weather, road closures, accidents, and other real-time factors not included
in the dataset.

## Project Outputs

The dashboard images and model result tables are available in
[`docs/images/`](docs/images/) and [`outputs/ml/`](outputs/ml/).
