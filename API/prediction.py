# main.py

import os
import uvicorn
import joblib
import numpy as np
import pandas as pd
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

# --- 1. Load Models and Scalers at Startup ---
try:
    model = joblib.load("C:\\Users\\LENOVO\\Cloned repos\\lrm_summative\\linear_regression_model\\linear_regression\\anxiety_model.pkl")
    scaler = joblib.load("C:\\Users\\LENOVO\\Cloned repos\\lrm_summative\\linear_regression_model\\linear_regression\\feature_scaler.pkl")
    print("Model and scaler loaded successfully.")
except Exception as e:
    print(f"ERROR: A model or scaler file could not be loaded. {e}")
    model = None
    scaler = None

# --- 2. Initialize FastAPI App ---
app = FastAPI(
    title="Anxiety Prediction API",
    description="API for predicting anxiety levels based on user input.",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- 3. Define Pydantic Input Model ---
class AnxietyInput(BaseModel):
    Schizophrenia: float
    Bipolar_disorder: float
    Eating_disorders: float
    Drug_use_disorders: float
    Depression: float
    Alcohol_use_disorders: float

# --- 4. Define API Endpoints ---

@app.get("/")
def read_root():
    """Health check endpoint."""
    if model and scaler:
        return {"status": "OK", "message": "Anxiety Prediction API is running and all models are loaded."}
    else:
        return {"status": "ERROR", "message": "API is running, but a model or scaler file is missing."}

@app.post("/predict")
def predict_anxiety(data: AnxietyInput):
    """Predict anxiety level based on scaled input data."""
    if not model or not scaler:
        raise HTTPException(
            status_code=503,
            detail="Model or scaler is not available. Check server logs."
        )

    try:
        # Convert the incoming Pydantic data into a pandas DataFrame
        input_df = pd.DataFrame([data.dict()])

        # -- START OF THE FIX --
        # Create a mapping from the API's variable names to the model's training column names
        column_mapping = {
            "Schizophrenia": "Schizophrenia (%)",
            "Bipolar_disorder": "Bipolar disorder (%)",
            "Eating_disorders": "Eating disorders (%)",
            "Drug_use_disorders": "Drug use disorders (%)",
            "Depression": "Depression (%)",
            "Alcohol_use_disorders": "Alcohol use disorders (%)"
        }

        # Rename the DataFrame columns to match what the model expects
        input_df.rename(columns=column_mapping, inplace=True)
        # -- END OF THE FIX --

        # Ensure the column order matches the original training data
        # Note: Now we use the original names with spaces and parentheses
        feature_order = [
            'Schizophrenia (%)', 'Bipolar disorder (%)', 'Eating disorders (%)',
            'Drug use disorders (%)', 'Depression (%)', 'Alcohol use disorders (%)'
        ]
        input_df = input_df[feature_order]

        # Scale the input features using the loaded scaler
        scaled_features = scaler.transform(input_df)

        # Make the prediction using the scaled features
        prediction = model.predict(scaled_features)[0]

        return {"predicted_anxiety_level": prediction}

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"An error occurred during prediction: {e}")

