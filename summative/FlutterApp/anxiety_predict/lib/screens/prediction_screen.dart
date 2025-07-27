// prediction_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text editing controllers for the input fields
  final TextEditingController _depressionController = TextEditingController();
  final TextEditingController _schizophreniaController =
      TextEditingController();
  final TextEditingController _bipolarController = TextEditingController();
  final TextEditingController _eatingController = TextEditingController();
  final TextEditingController _alcoholController = TextEditingController();
  final TextEditingController _drugController = TextEditingController();

  String _predictionResult = '';
  bool _isLoading = false;

  // Function to call the API and get the prediction
  Future<void> _predictAnxiety() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _predictionResult = '';
      });

      final url = Uri.parse(
        'https://linear-regression-model-yd0p.onrender.com/predict',
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
        final response = await http
            .post(
              url,
              headers: {"Content-Type": "application/json"},
              body: json.encode(data),
            )
            .timeout(const Duration(seconds: 30));

        print("Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");

        if (response.statusCode == 200) {
          final result = json.decode(response.body);
          if (result.containsKey('predicted_anxiety_level')) {
            setState(() {
              _predictionResult =
                  "Predicted Anxiety Level: ${double.parse(result['predicted_anxiety_level'].toString()).toStringAsFixed(4)}%";
            });
          } else {
            setState(() {
              _predictionResult = "Error: Invalid response format.";
            });
          }
        } else {
          setState(() {
            _predictionResult =
                "Error: ${response.reasonPhrase} (Code: ${response.statusCode})";
          });
        }
      } catch (e) {
        print("Exception: $e");
        setState(() {
          _predictionResult = "Error: Could not connect to the API server.";
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
      appBar: AppBar(
        title: const Text('Anxiety Prevalence Predictor'),
        centerTitle: true,
        leading: const Icon(Icons.psychology_alt),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'Enter the prevalence rates (%) for each disorder.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  _depressionController,
                  'Depression (%)',
                  Icons.sentiment_very_dissatisfied,
                ),
                _buildTextField(
                  _schizophreniaController,
                  'Schizophrenia (%)',
                  Icons.psychology,
                ),
                _buildTextField(
                  _bipolarController,
                  'Bipolar Disorder (%)',
                  Icons.theater_comedy,
                ),
                _buildTextField(
                  _eatingController,
                  'Eating Disorders (%)',
                  Icons.fastfood,
                ),
                _buildTextField(
                  _alcoholController,
                  'Alcohol Use Disorders (%)',
                  Icons.local_bar,
                ),
                _buildTextField(
                  _drugController,
                  'Drug Use Disorders (%)',
                  Icons.medical_services,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isLoading ? null : _predictAnxiety,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        )
                      : const Text('Predict', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 30),
                if (_predictionResult.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      _predictionResult,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _predictionResult.startsWith('Error')
                            ? Colors.redAccent
                            : Colors.blue[800],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for creating styled text input fields
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            icon: Icon(icon, color: Colors.grey[600]),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 12.0,
            ),
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
      ),
    );
  }
}
