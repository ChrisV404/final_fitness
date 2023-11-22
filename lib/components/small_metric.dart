import 'package:flutter/material.dart';

class SmallMetric extends StatefulWidget {
  SmallMetric({super.key});

  @override
  State<SmallMetric> createState() => _SmallMetricState();
}

class _SmallMetricState extends State<SmallMetric> {
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          width: 150,
          height: 150,
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Steps',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeCap: StrokeCap.round,
                    strokeAlign: 3,
                    strokeWidth: 12,
                    value: 0.5,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  const Text(
                    '500',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Poppins',
                    ),
                  )
                ],
              ),
              const SizedBox(height: 25),
              const Text(
                'Goal: 5000',
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Poppins',
                ),
              )
            ],
          ),
        ));
  }
}
