import 'package:flutter/material.dart';

class BMIScreen extends StatefulWidget {
  @override
  _BMIScreenState createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  double? _bmi;
  String? _bmiCategory;
  Color? _categoryColor;

  void calculateBMI() {
    double height = double.parse(_heightController.text) / 100;
    double weight = double.parse(_weightController.text);
    setState(() {
      _bmi = weight / (height * height);
      _bmiCategory = getBMICategory(_bmi!);
      _categoryColor = getCategoryColor(_bmi!);
    });
  }

  String getBMICategory(double bmi) {
    if (bmi < 16.0) return 'Severely Underweight';
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25.0) return 'Normal';
    if (bmi < 30.0) return 'Overweight';
    if (bmi < 35.0) return 'Moderately Obese';
    if (bmi < 40.0) return 'Severely Obese';
    return 'Morbidly Obese';
  }

  Color getCategoryColor(double bmi) {
    if (bmi < 18.5) return Colors.yellow; // Covers both Severely Underweight and Underweight
    if (bmi < 25.0) return Colors.green;
    if (bmi < 30.0) return Colors.orange;
    return Colors.red; // Covers Moderately Obese, Severely Obese, and Morbidly Obese
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _heightController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Height in cm',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Weight in kg',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: calculateBMI,
                child: Text('Calculate BMI'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Color(0xFFF84C4C), // Text color
                ),
              ),
              SizedBox(height: 20),
              if (_bmi != null) ...[
                Text(
                  'Your BMI is ${_bmi!.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 25, 26, 25),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Category: $_bmiCategory',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _categoryColor, // Color based on BMI category
                  ),
                ),
              ],
              SizedBox(height: 20),
              DataTable(
                columns: const <DataColumn>[
                  DataColumn(label: Text('BMI')),
                  DataColumn(label: Text('Category')),
                ],
                rows: const <DataRow>[
                  DataRow(cells: [
                    DataCell(Text('< 16.0')),
                    DataCell(Text('Severely Underweight')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('16.0 - 18.4')),
                    DataCell(Text('Underweight')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('18.5 - 24.9')),
                    DataCell(Text('Normal')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('25.0 - 29.9')),
                    DataCell(Text('Overweight')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('30.0 - 34.9')),
                    DataCell(Text('Moderately Obese')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('35.0 - 39.9')),
                    DataCell(Text('Severely Obese')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('≥ 40.0')),
                    DataCell(Text('Morbidly Obese')),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
