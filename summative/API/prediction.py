from http.client import HTTPException
import uvicorn
import joblib
import pandas as pd
from fastapi import FastAPI
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

app = FastAPI(
    title="Anxiety Prediction API",
    description="API for predicting anxiety levels based on user input.",
    version="1.0.0"
)

# Load the pre-trained model
def load_model():
    try:
        import os
        current_dir = os.path.dirname(__file__)
        model_path = os.path.join(current_dir, "..", "anxiety_model.pkl")
        model = joblib.load(model_path)
        return model
    except Exception as e:
        print(f"Error loading model: {e}")
        return None

model = load_model()

# Define the input data model
class PredictionResponse(BaseModel):
    anxiety_level: float
    depression: float
    stress: float

    class Config:
        json_schema_extra = {
            "example": {
                "anxiety_level": 0.75,
                "depression": 0.60,
                "stress": 0.80
            }
        }


@app.post("/predict")
async def predict(request: PredictionResponse):
    if model is None:
        return {"error": "Model not loaded"}
    try:
        # Prepare the input data
        input_data = pd.DataFrame([{
            "anxiety_level": request.anxiety_level,
            "depression": request.depression,
            "stress": request.stress
        }])

        # Make prediction
        prediction = model.predict(input_data)

        return {"predicted anxiety levels": prediction[0]}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/anxiety")
async def get_anxiety_levels():
    """Return anxiety levels from the model."""
    if model is None:
        raise HTTPException(status_code=500, detail="Model not loaded")

    return {"anxiety_levels": list(range(1, 11))}

@app.get("/")
async def root():
    return {"message": "Welcome to the Anxiety Prediction API"} 