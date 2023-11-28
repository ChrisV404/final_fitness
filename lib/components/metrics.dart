import 'package:flutter/material.dart';

class Metrics extends StatefulWidget {
  // final String data;
  Metrics({super.key});

  @override
  State<Metrics> createState() => _MetricsState();
}

class _MetricsState extends State<Metrics> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate.fixed(
        <Widget>[
          Row(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: const Text(
                  'Metrics',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                  ),
                ),
              )
            ],
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Current',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Goal',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(width: 10)
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        'Calories',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(width: 194),
                      Text(
                        '2000',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(width: 30),
                      Text(
                        '2500',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: LinearProgressIndicator(
                    minHeight: 12,
                    borderRadius: BorderRadius.circular(20),
                    value: 0.5,
                    backgroundColor: Color.fromARGB(255, 224, 189, 189),
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 240, 81, 57)),
                  ),
                ),
                const Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      'Carbs',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(width: 210),
                    Text(
                      '2000',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(width: 30),
                    Text(
                      '2500',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: LinearProgressIndicator(
                    minHeight: 12,
                    borderRadius: BorderRadius.circular(20),
                    value: 0.5,
                    backgroundColor: const Color.fromARGB(255, 173, 217, 241),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 57, 191, 240)),
                  ),
                ),
                const Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      'Fat',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(width: 232),
                    Text(
                      '2000',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(width: 30),
                    Text(
                      '2500',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: LinearProgressIndicator(
                    minHeight: 12,
                    borderRadius: BorderRadius.circular(20),
                    value: 0.5,
                    backgroundColor: const Color.fromARGB(255, 198, 233, 195),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 78, 240, 57)),
                  ),
                ),
                const Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      'Protein',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(width: 204),
                    Text(
                      '2000',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(width: 30),
                    Text(
                      '2500',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: LinearProgressIndicator(
                    minHeight: 12,
                    borderRadius: BorderRadius.circular(20),
                    value: 0.5,
                    backgroundColor: const Color.fromARGB(255, 219, 195, 233),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 186, 102, 236)),
                  ),
                ),
                const  Row(
                  children: [],
                ),
                const Row(
                  children: [],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
