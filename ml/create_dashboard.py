
import os
import pandas as pd
import matplotlib.pyplot as plt

os.makedirs("docs/images", exist_ok=True)

comparison_path = "outputs/ml/model_comparison.csv"
importance_path = "outputs/ml/feature_importance.csv"

if os.path.exists(comparison_path):
    comparison = pd.read_csv(comparison_path)

    if "Model" in comparison.columns:
        # Dashboard 1: Compare model performance
        fig, axes = plt.subplots(1, 3, figsize=(16, 5))

        metrics = [
            ("MAE_seconds", "MAE (seconds)"),
            ("RMSE_seconds", "RMSE (seconds)"),
            ("R2", "R² score")
        ]

        for ax, (column, title) in zip(axes, metrics):
            if column not in comparison.columns:
                ax.set_visible(False)
                continue

            data = comparison.sort_values(
                column, ascending=(column != "R2")
            )

            ax.barh(data["Model"], data[column])
            ax.set_title(title)
            ax.set_xlabel(title)
            ax.grid(axis="x", alpha=0.25)
            ax.invert_yaxis()

        fig.suptitle(
            "Taxi Trip Duration Prediction — Model Comparison",
            fontsize=16
        )
        fig.tight_layout()
        fig.savefig(
            "docs/images/model_comparison.png",
            dpi=180,
            bbox_inches="tight"
        )
        plt.close(fig)
    else:
        print(
            f"Skipping model comparison: {comparison_path} "
            "does not contain a Model column."
        )
else:
    print(f"Skipping model comparison: {comparison_path} was not found.")

# Dashboard 2: Feature importance
if os.path.exists(importance_path):
    importance = pd.read_csv(importance_path)

    column_lookup = {column.lower(): column for column in importance.columns}
    feature_column = column_lookup.get("feature")
    importance_column = column_lookup.get("importance")

    if feature_column and importance_column:
        importance = importance.sort_values(
            importance_column, ascending=True
        )

        fig, ax = plt.subplots(figsize=(9, 6))
        ax.barh(importance[feature_column], importance[importance_column])
        ax.set_title("Random Forest — Feature Importance")
        ax.set_xlabel("Importance")
        ax.grid(axis="x", alpha=0.25)
        fig.tight_layout()
        fig.savefig(
            "docs/images/feature_importance.png",
            dpi=180,
            bbox_inches="tight"
        )
        plt.close(fig)
    else:
        print(
            f"Skipping feature importance: {importance_path} must contain "
            "Feature and Importance columns."
        )
else:
    print(f"Skipping feature importance: {importance_path} was not found.")

print("Dashboard images created in docs/images/")
