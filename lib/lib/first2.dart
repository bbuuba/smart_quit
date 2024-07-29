import 'package:flutter/material.dart';
import 'first3.dart';

class first2Page extends StatefulWidget {
  final int cigaretteCount;

  first2Page({required this.cigaretteCount});

  @override
  _first2PageState createState() => _first2PageState();
}

class _first2PageState extends State<first2Page> {
  TextEditingController costController = TextEditingController();

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
                        "Cât costă un pachet de țigări?",
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
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          controller: costController,
                          style: TextStyle(fontSize: 14, color: Colors.black),
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.transparent, // Set to transparent to inherit container color
                            hintText: '0',
                            hintStyle: TextStyle(color: Colors.black45),
                            border: InputBorder.none,  // Remove underline
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Te rog completeaza!';
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
                              builder: (context) => first3Page(
                                cigaretteCount: widget.cigaretteCount,
                                cost: int.parse(costController.text),
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
