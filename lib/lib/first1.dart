import 'package:flutter/material.dart';
import 'first2.dart';

class first1Page extends StatefulWidget {
  @override
  _first1PageState createState() => _first1PageState();
}

class _first1PageState extends State<first1Page> {
  TextEditingController cigaretteCountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/green.jpg'), // Replace with your image path
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
                      Text(
                        "Câte țigări fumezi pe zi?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextFormField(
                          controller: cigaretteCountController,
                          style: TextStyle(fontSize: 14, color: Colors.black),
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.transparent, // Set to transparent to inherit container color
                            hintText: '0',
                            hintStyle: TextStyle(color: Colors.black45),
                            border: InputBorder.none, // Remove underline
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please fill in!';
                            }
                            return null;
                          },
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => first2Page(
                                cigaretteCount: int.parse(cigaretteCountController.text),
                              ),
                            ),
                          );
                        },
                        child: Text("Next", style: TextStyle(color: Colors.white)),
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
}
