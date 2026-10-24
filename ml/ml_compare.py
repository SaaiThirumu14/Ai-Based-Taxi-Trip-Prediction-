
import glob
import os
import numpy as np
import pandas as pd

from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.tree import DecisionTreeRegressor
from sklearn.ensemble import RandomForestRegressor, GradientBoostingRegressor
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score

# Read Pig-exported data
files = glob.glob("outputs/taxi_ml_ready/part-*")
if not files:
    raise FileNotFoundError("Check outputs/taxi_ml_ready/")

columns = [
    "id", "vendor_id", "pickup_datetime", "passenger_count",
    "pickup_longitude", "pickup_latitude",
    "dropoff_longitude", "dropoff_latitude",
    "store_and_fwd_flag", "trip_duration"
]

df = pd.concat(
    [pd.read_csv(f, header=None, names=columns) for f in files],
    ignore_index=True
)

# Convert data types
numeric_cols = [
    "vendor_id", "passenger_count", "pickup_longitude",
    "pickup_latitude", "dropoff_longitude",
    "dropoff_latitude", "trip_duration"
]

for col in numeric_cols:
    df[col] = pd.to_numeric(df[col], errors="coerce")

df["pickup_datetime"] = pd.to_datetime(
    df["pickup_datetime"], errors="coerce"
)

df = df.dropna(subset=numeric_cols + ["pickup_datetime"])

# Apply the same data filters as the baseline model
df = df[
    df["passenger_count"].between(1, 6) &
    df["trip_duration"].between(1, 7200) &
    df["pickup_longitude"].between(-75, -72) &
    df["dropoff_longitude"].between(-75, -72) &
    df["pickup_latitude"].between(40, 42) &
    df["dropoff_latitude"].between(40, 42)
].copy()

# Extract pickup time features
df["pickup_hour"] = df["pickup_datetime"].dt.hour
df["pickup_day"] = df["pickup_datetime"].dt.day
df["pickup_month"] = df["pickup_datetime"].dt.month
df["pickup_weekday"] = df["pickup_datetime"].dt.weekday

features = [
    "vendor_id", "passenger_count",
    "pickup_longitude", "pickup_latitude",
    "dropoff_longitude", "dropoff_latitude",
    "pickup_hour", "pickup_day", "pickup_month", "pickup_weekday"
]

# Use a fixed sample to make model comparisons fair and faster
if len(df) > 50000:
    df = df.sample(n=50000, random_state=42)

X = df[features]
y = df["trip_duration"]

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

models = {
    "Linear Regression": LinearRegression(),
    "Decision Tree": DecisionTreeRegressor(
        max_depth=18, min_samples_leaf=2, random_state=42
    ),
    "Random Forest": RandomForestRegressor(
        n_estimators=80, max_depth=18,
        min_samples_leaf=2, n_jobs=-1, random_state=42
    ),
    "Gradient Boosting": GradientBoostingRegressor(
        n_estimators=80, max_depth=3,
        learning_rate=0.1, random_state=42
    )
}

results = []

for name, model in models.items():
    print(f"Training {name}...")
    model.fit(X_train, y_train)
    predictions = model.predict(X_test)

    results.append({
        "Model": name,
        "MAE_seconds": mean_absolute_error(y_test, predictions),
        "RMSE_seconds": np.sqrt(
            mean_squared_error(y_test, predictions)
        ),
        "R2": r2_score(y_test, predictions)
    })

results_df = pd.DataFrame(results).sort_values("RMSE_seconds")
os.makedirs("outputs/ml", exist_ok=True)
results_df.to_csv("outputs/ml/model_comparison.csv", index=False)

print("\n--- Model Comparison (lower MAE/RMSE is better; higher R² is better) ---")
print(results_df.round(4).to_string(index=False))
print("\nSaved to outputs/ml/model_comparison.csv")
