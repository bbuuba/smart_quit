import 'package:flutter/material.dart';

class HealthIndicatorCard extends StatelessWidget {
  final String title;
  final Duration totalDuration;
  final double progress;

  HealthIndicatorCard({
    required this.title,
    required this.totalDuration,
    this.progress = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300, // Adjust width as needed
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            SizedBox(height: 10),
            Text(
              'Progress: ${(progress * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Time left to normalization: ${Duration(seconds: (totalDuration.inSeconds * (1 - progress)).round()).toString()}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
