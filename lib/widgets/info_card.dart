import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color backgroundColor; // Add a parameter for background color

  const InfoCard({
    Key? key,
    required this.title,
    required this.onTap,
    this.backgroundColor = const Color(0xFFF84C4C), required Color color, // Default color is set to #F84C4C
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.all(8),
        color: backgroundColor, // Use the background color passed as a parameter
        child: Container(
          padding: EdgeInsets.all(16),
          alignment: Alignment.center, // Center the text within the container
          child: Text(
            title,
            style: TextStyle(fontSize: 18, color: Colors.white), // Set text color to white for better contrast
          ),
        ),
      ),
    );
  }
}