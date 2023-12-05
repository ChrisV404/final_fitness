import 'package:final_fitness/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SmallMetric extends StatefulWidget {
  SmallMetric(
      {super.key,
      required this.metricName,
      required this.metricAmount,
      required this.goal});
  final String metricName;
  int metricAmount;
  dynamic goal;

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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.metricName,
                    style: const TextStyle(
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
                    value: (widget.goal is int) ? widget.metricAmount / widget.goal : 0,
                    backgroundColor: Colors.grey[300],
                    valueColor: (widget.goal == "-") ? const AlwaysStoppedAnimation<Color>(Colors.grey) : const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  Text(
                    widget.metricAmount.toString(),
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Poppins',
                    ),
                  )
                ],
              ),
              const SizedBox(height: 25),
              Text(
                'Goal: ${widget.goal}',
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
