import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'features/user_auth/presentation/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class first5Page extends StatefulWidget {
  final int cigaretteCount;
  final int cost;
  final int years;

  first5Page({
    required this.cigaretteCount,
    required this.cost,
    required this.years,
  });

  @override
  _first5PageState createState() => _first5PageState();
}

class _first5PageState extends State<first5Page> {
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
                          "Ai completat toți pașii. Acum ești gata să faci tranziția către o viață sănătoasă.",
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
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        },
                        child: Text("Sunt gata!", style: TextStyle(color: Colors.white)),
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
