## ANXIETY PREDICITNG APPLICATION

I developed an anxiety prediciting application that leverages Random Forest regression Model to self diagnose patients based on factors such as history of mental health disorders, level of alcohol and drug use and mood.

The model analyses the prevalence of mental health disorders, depression, alcohol and drug use and gives a percentage score of the anxiety level of the user.

This model aims to give a quick quantified score of anxiety based on factors that tend to be correlated to anxiety according to the [American Psychological Association](https://www.apa.org/education-career/training/psyclearn-anxiety-addictive-behaviors-series)

Data obtained from Kaggle https://www.kaggle.com/datasets/kamaumunyori/global-health-data-analysis-1990-2019

# ROCCC of Data:

- Reliablity — High — The data comes from global population sample data sources including African countries.

- Originality — LOW — Third party provider (WHO).

- Comprehensive — HIGH — There are several variables summarized into between 1,700-10,980 observations for a period of over 15 years which was fairly comprehensive.

- Current — MID — Data is 3 years old and may not be as relevant as there is no covid data updated to it.

- Cited — HIGH — Data collected from a reliable third party that comprehensively reports its data collection process publicly.

## Access the model here hosted on Render

[Anxiety API](https://linear-regression-model-yd0p.onrender.com/docs)

# Anxiety level API

How to Use:

- Visit the Swagger UI documentation:
- Access the API here [Anxiety API](https://linear-regression-model-yd0p.onrender.com/docs)
- Click on the /predict endpoint.
- Input values for depression, schizophrenia, bipolar eating disorder alcohol use disorder and drug use disorder
- You can fill at least one of the six inputs.
- Click "Predict" to get the predicted anxiety level.

## Run the Backend Locally

# Prerequisites:

- Python 3.13.9
- pip package manager

# Steps:

- Clone the repository: git clone https://github.com/tonywahome/linear_regression_model
- cd linear_regression_model
- Create a virtual environment (recommended):
- python -m venv venv
- source venv/bin/activate # On Windows: venv\Scripts\activate
- Install dependencies:
- pip install -r requirements.txt
- pip install -r requirements.txt
- uvicorn API.prediction:app --host 0.0.0.0 --port 8000
- Open the interactive docs at: http://localhost:8000/docs
- Run The Flutter Frontend Application

## Prerequisites:

- Flutter SDK installed
- Android Studio / Xcode / or emulator configured
- Device or emulator running

# Steps:

- Navigate into the summative folder: cd summative/FlutterAPP/anxiety_predict

- Get flutter packages: flutter pub get

- Run the app: flutter run

# Using the App:

Enter the required input values (Depression, Schizophrenia, Bipolar, Eating disorders, Alcohol and Drug use).
Press the "Predict" button to receive a predicted Anxiety level.
