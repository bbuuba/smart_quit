import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'first5.dart';

class first4Page extends StatefulWidget {
  final int cigaretteCount;
  final int cost;
  final int years;

  first4Page({
    required this.cigaretteCount,
    required this.cost,
    required this.years,
  });

  @override
  _first4PageState createState() => _first4PageState();
}

int func(int nr, int cost, int years) {
  double ans = 365 * years * cost * nr / 20;
  return ans.toInt();
}

class _first4PageState extends State<first4Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/green.jpg'), // Replace 'assets/background_image.jpg' with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Color(0x802e1b6c), // 50% opacity purple overlay
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          "Ai cheltuit: ${func(widget.cigaretteCount, widget.cost, widget.years)} de lei",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(101, 149, 108, 1.0),
                        ),
                        onPressed: () {
                          getNumbers();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => first5Page(
                                cigaretteCount: widget.cigaretteCount,
                                cost: widget.cost,
                                years: widget.years,
                              ),
                            ),
                          );
                        },
                        child: Text("Next!", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getNumbers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cnt', widget.cigaretteCount);
    prefs.setInt('cost', widget.cost);
  }
}
