import uvicorn
import joblib
import numpy as np
import pandas as pd

from fastapi.middleware.cors import CORSMiddleware
from http.client import HTTPException
from fastapi import FastAPI
from pydantic import BaseModel

# Initialize FastAPI app
app = FastAPI(
    title="Anxiety Prediction API",
    description="API for predicting anxiety levels based on user input.",
    version="1.0.0"
)

# add CORS middleware to allow requests from any origin
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load the saved model
model = joblib.load(r'C:\Users\LENOVO\Desktop\Stuff\Software Eng\Math for ML\Datasets for Summative\lr\linear_regression_model\summative\anxiety_model.pkl')

# Define the input data model
class AnxietyInput(BaseModel):
    Schizophrenia: float
    Bipolar_disorder: float
    Eating_disorders: float
    Anxiety_disorders: float
    Drug_use_disorders: float
    Depression: float
    Alcohol_use_disorders: float

# Define the prediction endpoint
@app.post("/predict")
def predict_anxiety(data: AnxietyInput):
    """Predict anxiety level based on input data."""
    input_df = pd.DataFrame([data.dict()])
    
    feature_order = [
        'Schizophrenia', 'Bipolar_disorder', 'Eating_disorders', 'Anxiety_disorders',
        'Drug_use_disorders', 'Depression', 'Alcohol_use_disorders'
    ]
    input_df = input_df[feature_order]
    #make a prediction
    prediction = model.predict(input_df)[0]

    return {"predicted_anxiety_level": prediction}

# Health check endpoint
@app.get("/")
def read_root():
    """Health check endpoint."""
    return {"message": "Anxiety Prediction API is running."}
