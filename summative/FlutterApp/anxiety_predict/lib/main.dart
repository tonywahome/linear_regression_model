// main.dart

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const PredictionScreen(),
    );
  }
}

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _depressionController = TextEditingController();
  final TextEditingController _schizophreniaController =
      TextEditingController();
  final TextEditingController _bipolarController = TextEditingController();
  final TextEditingController _eatingController = TextEditingController();
  final TextEditingController _alcoholController = TextEditingController();
  final TextEditingController _drugController = TextEditingController();

  String _predictionResult = '';
  bool _isLoading = false;

  Future<void> _predictAnxiety() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _predictionResult = '';
      });

      final url = Uri.parse(
        'https://anxiety-prediction-api.onrender.com/predict',
      );

      final Map<String, double> data = {
        "Depression": double.tryParse(_depressionController.text) ?? 0.0,
        "Schizophrenia": double.tryParse(_schizophreniaController.text) ?? 0.0,
        "Bipolar_disorder": double.tryParse(_bipolarController.text) ?? 0.0,
        "Eating_disorders": double.tryParse(_eatingController.text) ?? 0.0,
        "Alcohol_use_disorders":
            double.tryParse(_alcoholController.text) ?? 0.0,
        "Drug_use_disorders": double.tryParse(_drugController.text) ?? 0.0,
      };

      try {
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(data),
        );

        if (response.statusCode == 200) {
          final result = json.decode(response.body);
          setState(() {
            _predictionResult =
                "Predicted Anxiety Prevalence: ${result['predicted_anxiety_prevalence'].toStringAsFixed(4)}%";
          });
        } else {
          setState(() {
            _predictionResult = "Error: ${response.reasonPhrase}";
          });
        }
      } catch (e) {
        setState(() {
          _predictionResult = "Error: Could not connect to the server.";
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Anxiety Prevalence Predictor')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildTextField(_depressionController, 'Depression (%)'),
                _buildTextField(_schizophreniaController, 'Schizophrenia (%)'),
                _buildTextField(_bipolarController, 'Bipolar Disorder (%)'),
                _buildTextField(_eatingController, 'Eating Disorders (%)'),
                _buildTextField(
                  _alcoholController,
                  'Alcohol Use Disorders (%)',
                ),
                _buildTextField(_drugController, 'Drug Use Disorders (%)'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _predictAnxiety,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        )
                      : const Text('Predict'),
                ),
                const SizedBox(height: 20),
                if (_predictionResult.isNotEmpty)
                  Text(
                    _predictionResult,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        validator: (value) {
          if (value != null &&
              value.isNotEmpty &&
              double.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          return null;
        },
      ),
    );
  }
}
