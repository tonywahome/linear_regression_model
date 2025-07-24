// main.dart

import 'package:anxiety_predict/screens/prediction_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AnxietyPredictorApp());
}

class AnxietyPredictorApp extends StatelessWidget {
  const AnxietyPredictorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anxiety Predictor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.lightBlue[50], // Sky blue background
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(secondary: Colors.blueAccent),
      ),
      // Set the PredictionScreen as the home page
      home: const PredictionScreen(),
    );
  }
}
