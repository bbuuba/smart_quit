import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'graph.dart';


class HealthPage extends StatefulWidget {
  @override
  _HealthPageState createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  int _selectedImprovement = 1;
  final ScrollController _scrollController = ScrollController();
  List<String> improvementTypes = [
    'Reducerea monoxidului de carbon din sânge',
    'Îmbunătățirea nivelului de oxigen din sânge',
    'Scăderea ritmului cardiac și a tensiunii arteriale',
    'Îmbunătățirea funcțiilor senzoriale',
    'Îmbunătățirea circulației și a funcției pulmonare',
    'Îmbunătățirea nivelului de activitate fizică',
    'Reducerea simptomelor respiratorii',
    'Îmbunătățirea funcției pulmonare',
    'Reducerea riscului de accident vascular cerebral',
    'Scăderea infecțiilor respiratorii',
    'Scăderea riscului de atac de cord',

    'idk'
  ];
  Duration time = Duration(hours: 48);
  List<List<FlSpot>> improvements = [];
  List<List<DurationIntPair>> data = [];

  @override
  void initState() {
    super.initState();
    /// _loadTime();
    _loadData();
    _loadImprovements();
  }
  bool isLevelCompleted(int index) {
    if (index >= improvements.length) return false;
    if (improvements[index].isEmpty) return false;
    return improvements[index].last.x >= extractDurationValue(data[index].last.duration, index > 2 ? 'days' : 'hours');
  }


  void _loadTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String strTime = prefs.getString("stringTimeKey") ?? '';
    if (strTime.isNotEmpty) {
      DateTime lastTime = DateTime.parse(strTime);
      setState(() {
        time = DateTime.now().difference(lastTime);
      });
    }
  }

  void _loadData() {
    data = [
      [
        DurationIntPair(Duration(hours: 0), 0),
        DurationIntPair(Duration(hours: 1), 5),
        DurationIntPair(Duration(hours: 12), 10),
        DurationIntPair(Duration(hours: 24), 20),
      ],
      [
        DurationIntPair(Duration(hours: 0), 50),
        DurationIntPair(Duration(hours: 8), 25),
        DurationIntPair(Duration(hours: 12), 10),
        DurationIntPair(Duration(hours: 24), 5),
        DurationIntPair(Duration(hours: 48), 0),
      ],
      [
        DurationIntPair(Duration(hours: 0), 0),
        DurationIntPair(Duration(hours: 8), 5),
        DurationIntPair(Duration(hours: 12), 10),
        DurationIntPair(Duration(hours: 24), 15),
        DurationIntPair(Duration(hours: 48), 20),
      ],
      [
        DurationIntPair(Duration(days: 0), 0),
        DurationIntPair(Duration(days: 1), 10),
        DurationIntPair(Duration(days: 2), 20),
        DurationIntPair(Duration(days: 3), 30),
        DurationIntPair(Duration(days: 7), 50),
        DurationIntPair(Duration(days: 14), 70),
        DurationIntPair(Duration(days: 30), 90),
      ],
      [
        DurationIntPair(Duration(days: 0), 0),
        DurationIntPair(Duration(days: 7), 5),
        DurationIntPair(Duration(days: 14), 10),
        DurationIntPair(Duration(days: 21), 15),
        DurationIntPair(Duration(days: 28), 20),
        DurationIntPair(Duration(days: 42), 30),
        DurationIntPair(Duration(days: 56), 40),
        DurationIntPair(Duration(days: 84), 50),
      ],
      [
        DurationIntPair(Duration(days: 0), 0),
        DurationIntPair(Duration(days: 7), 5),
        DurationIntPair(Duration(days: 14), 10),
        DurationIntPair(Duration(days: 28), 20),
        DurationIntPair(Duration(days: 56), 30),
        DurationIntPair(Duration(days: 84), 40),
      ],
      [
        DurationIntPair(Duration(days: 0), 0),
        DurationIntPair(Duration(days: 1), 1),
        DurationIntPair(Duration(days: 2), 2),
        DurationIntPair(Duration(days: 3), 3),
        DurationIntPair(Duration(days: 7), 5),
        DurationIntPair(Duration(days: 14), 10),
        DurationIntPair(Duration(days: 30), 15),
        DurationIntPair(Duration(days: 60), 20),
        DurationIntPair(Duration(days: 90), 25),
      ],
      [
        DurationIntPair(Duration(days: 0), 0),
        DurationIntPair(Duration(days: 1), 2),
        DurationIntPair(Duration(days: 2), 5),
        DurationIntPair(Duration(days: 7), 10),
        DurationIntPair(Duration(days: 14), 15),
        DurationIntPair(Duration(days: 30), 20),
        DurationIntPair(Duration(days: 60), 25),
        DurationIntPair(Duration(days: 90), 30),
      ],
      [
        DurationIntPair(Duration(days: 0), 0),
        DurationIntPair(Duration(days: 1), 1),
        DurationIntPair(Duration(days: 2), 2),
        DurationIntPair(Duration(days: 3), 3),
        DurationIntPair(Duration(days: 7), 5),
        DurationIntPair(Duration(days: 14), 10),
        DurationIntPair(Duration(days: 30), 20),
        DurationIntPair(Duration(days: 60), 30),
        DurationIntPair(Duration(days: 90), 40),
      ],
      [
        DurationIntPair(Duration(days: 0), 0),
        DurationIntPair(Duration(days: 30), 5),
        DurationIntPair(Duration(days: 90), 10),
        DurationIntPair(Duration(days: 180), 20),
        DurationIntPair(Duration(days: 360), 30),
        DurationIntPair(Duration(days: 720), 40),
      ],
      [
        DurationIntPair(Duration(days: 0), 0),
        DurationIntPair(Duration(days: 30), 5),
        DurationIntPair(Duration(days: 90), 10),
        DurationIntPair(Duration(days: 180), 20),
        DurationIntPair(Duration(days: 360), 30),
        DurationIntPair(Duration(days: 720), 40),
        DurationIntPair(Duration(days: 1080), 50),
      ],
      [
        DurationIntPair(Duration(hours: 0), 0),
        DurationIntPair(Duration(hours: 30), 5),
        DurationIntPair(Duration(hours: 90), 10),
      ]
    ];
  }

  double extractDurationValue(Duration x, String s) {
    switch (s) {
      case 'hours':
        return x.inHours.toDouble();
      case 'days':
        return x.inDays.toDouble();
      default:
        return 0;
    }
  }

  void _loadImprovements() {
    for (int i = 0; i < data.length; i++) {
      List<FlSpot> list = [];
      for (int j = 0; j < data[i].length; j++) {
        if (time >= data[i][j].duration) {
          String str = 'hours';
          if (i > 2) str = 'days';
          double x = extractDurationValue(data[i][j].duration, str);
          list.add(FlSpot(x, data[i][j].value));
        }
      }
      improvements.add(list);
    }
  }

  List<FlSpot> _getDataPoints(int improvementType) {
    switch (improvementType) {
      case 0:
        return improvements[0];
      case 1:
        return improvements[1];
      case 2:
        return improvements[2];
      case 3:
        return improvements[3];
      case 4:
        return improvements[4];
      default:
        return [];
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/mama4.jpg'), // Path to your background image
                  fit: BoxFit.cover, // Ensure the image covers the entire background
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5), // Black overlay with opacity
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
          ),
          // Scrollable Content
          Positioned.fill(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 20),
                      Container(
                        height: MediaQuery.of(context).size.height * 1.5,
                        child: Stack(
                          children: [
                            CustomPaint(
                              size: MediaQuery.of(context).size,
                              painter: LinePainter(),
                            ),
                            ...List.generate(improvementTypes.length, (index) {
                              // Set custom positions for each Improvement widget
                              double top = MediaQuery.of(context).size.height * ((index + 1) / 8 - 0.1);
                              double left = MediaQuery.of(context).size.width;
                              if (index % 2 == 0) left *= 0.42;
                              else left *= (((index % 4) - 1) * 0.32 + 0.1);
                              return Positioned(
                                top: top,
                                left: left,
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return BackdropFilter(
                                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                          child: Container(
                                            color: Colors.white.withOpacity(0.1),
                                            child: Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(20.0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[
                                                      Text(improvementTypes[index], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                                                      SizedBox(height: 50),
                                                      Container(
                                                        height: 200, // Adjust the height as needed
                                                        child: StyledGraph(dataPoints: _getDataPoints(_selectedImprovement)),
                                                      ),
                                                      SizedBox(height: 20.0),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: Text('Close', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                    setState(() {
                                      _selectedImprovement = index;
                                    });
                                  },
                                  child: Improvement(
                                    title: (index + 1).toString(),
                                    isCompleted: isLevelCompleted(index),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class Improvement extends StatelessWidget {
  final String title;
  final bool isCompleted;

  Improvement({required this.title, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [Color(0xFFd1c4e9), Color(0xFF311b92)], // Lighter to darker purple
          center: Alignment.center,
          radius: 0.8,
          stops: [0.3, 1.0],
        ),
      ),
      child: Center(
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted ? Color(0xFFd1c4e9) : Colors.black, // Light purple if completed
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.6),
                spreadRadius: 3,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              isCompleted ? '✔' : title,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class DurationIntPair {
  Duration duration;
  double value;
  DurationIntPair(this.duration, this.value);
}

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFFbbb0ea)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Define the points for the dotted line
    final List<Offset> points = [];

    // Add points along the path
    void addDottedLine(Offset start, Offset end, int nr, int variable) {
      const int step = 17;
      final double dx = end.dx - start.dx;
      final double dy = end.dy - start.dy;
      final double distance = sqrt(dx * dx + dy * dy);
      final int numDots = (distance / step).toInt();
      double stepX = dx / numDots;
      double stepY = dy / numDots;
      double k = 0,
          p = numDots / 1,
          ratie = 2;
      if (variable == 0 && size.width < 500) {
        p *= 4 / 2;
        ratie = 4;
      }
      else if (size.width >= 600){
        p *= 3 / 4;
        ratie = 3 / 2;
      }
      for (int i = 0; i <= numDots; i++) {
        points.add(Offset(start.dx + i * stepX, start.dy + i * stepY + nr * k));
        k += p;
        p -= ratie;
      }
    }

    // Add dotted lines for each segment
    // addDottedLine(Offset(size.width * 0.5, size.height * 0.1), Offset(size.width * 0.5, size.height * 0.3));
    // addDottedLine(Offset(size.width * 0.5, size.height * 0.3), Offset(size.width * 0.5, size.height * 0.5));
    // addDottedLine(Offset(size.width * 0.5, size.height * 0.5), Offset(size.width * 0.5, size.height * 0.7));
    // addDottedLine(Offset(size.width * 0.5, size.height * 0.7), Offset(size.width * 0.5, size.height * 0.9));

    // addDottedLine(Offset(size.width * 0.2, size.height * 0.1), Offset(size.width * 0.1, size.height * 0.2));

    for(int i = 0; i < 11; i++){////////////////////////////////////// impovements.length - 1
      double x = size.width, xx = size.width, y =  size.height * ((i + 1) / 8 - 0.1), yy = size.height * ((i + 2) / 8 - 0.1);
      if(i % 2 == 0) {
        x *= 0.42;
        xx *= ((i % 4) * 0.32 + 0.1);
      }
      else {
        x *= (((i - 1) % 4) * 0.32 + 0.1);
        xx *= 0.42;
      }

      // double left = MediaQuery.of(context).size.width;
      // if(index % 2 == 0) left *= 0.45;
      // else left *= (((index % 4) - 1) * 0.35 + 0.1);

      int variable = i % 3;
      x += 25;
      xx += 25;
      y += 20;
      yy += 20;
      addDottedLine(Offset(x, y), Offset(xx, yy), (i % 2) * 2 - 1, variable);
    }

    // Draw the dotted line
    for (Offset point in points) {
      canvas.drawCircle(point, 1, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}