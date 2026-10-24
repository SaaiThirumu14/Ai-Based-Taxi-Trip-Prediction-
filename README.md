# Taxi Trip Duration Prediction

A machine-learning project that predicts taxi trip duration using trip,
location, passenger, and pickup-time information.

## Dataset

This project uses the [Kaggle NYC Taxi Trip Duration dataset](https://www.kaggle.com/competitions/nyc-taxi-trip-duration/data).
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

Python and scikit-learn are used to compare Linear Regression, Decision Tree,
Gradient Boosting, and Random Forest models. Random Forest achieved the best
reported results:

- **MAE:** 243.90 seconds
- **RMSE:** 361.69 seconds
- **R²:** 0.7032

## Project Outputs

The dashboard and model results are available in [`docs/images/`](docs/images/)
and [`outputs/ml/`](outputs/ml/).
