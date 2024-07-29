import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class QuitSmokingWidget extends StatefulWidget {
  final int lastCost;
  final int lastCount;

  QuitSmokingWidget({
    required this.lastCount,
    required this.lastCost,
  });

  @override
  _QuitSmokingWidgetState createState() => _QuitSmokingWidgetState();
}


class _QuitSmokingWidgetState extends State<QuitSmokingWidget> {
  bool isPlaying = false;
  bool updateCigarettes = false;
  static const String _channelId = 'getCigarettes';
  DateTime quitDate = DateTime.now();
  Duration maxTime = Duration.zero;
  DateTime lastTime = DateTime(DateTime
      .now()
      .year, DateTime
      .now()
      .month, DateTime
      .now()
      .day);
  int moneyPerDay = 0;
  int cigarettes = 0;
  String currentBadge = "";
  static const platform = MethodChannel('com.example.flutter_service');
  Timer? _timer;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  String goal = "";
  int price = 0;
  bool goalSet = false;
  final TextEditingController goalController = TextEditingController();
  final TextEditingController priceController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _initialize();

    _loadQuitDate();
    getCigarettes();
    _loadGoalAndPrice();
    //SharedPreferences prefs = await SharedPrefrences.getInstance();
    //prefs.getString('userName');

    var initializationSettingsAndroid = AndroidInitializationSettings(
        '@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    _createNotificationChannel();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      DateTime now = DateTime.now();
      Duration difference = now.difference(lastTime);
      if (difference.inDays > 0) {
        calculateSavedMoney(difference.inDays);
        resetCigarettes();
      }
      getCigarettes();
      setState(() {});
    });

    platform.setMethodCallHandler((call) async {
      switch (call.method) {
        case "updateCigarettes":
          setState(() {
            cigarettes = call.arguments as int;
          });
          break;
        default:
          throw MissingPluginException();
      }
      return null;
    });
  }

  Future<void> _initialize() async {
    await _loadQuitDate();
    await getCigarettes();
    await _loadGoalAndPrice();
  }


  void toggleIsPlaying() {
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  Future<void> _createNotificationChannel() async {
    var androidNotificationChannel = AndroidNotificationChannel(
      _channelId,
      'Cigarette Alerts',
      description: 'Channel for Cigarette Alerts',
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }

  Future<void> getCigarettes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cigarettes = prefs.getInt('cigarettes') ?? 0;
    try {
      final int newCigarettes = await platform.invokeMethod('getCigarettes');
      if (newCigarettes == 1 && !updateCigarettes) {
        updateCigarettes = true;
        quitDate = DateTime.now();
        prefs.setString('stringTimeKey', quitDate.toString());
        _showNotification();
        setState(() {
          cigarettes++;
        });
        prefs.setInt('cigarettes', cigarettes);
      } else if (newCigarettes == 0 && updateCigarettes) {
        updateCigarettes = false;
      }
    } on PlatformException catch (e) {
      print("Failed to get cigarettes count: '${e.message}'.");
    }
  }

  Future<void> _showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _channelId,
      'Cigarette Alerts',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,

      'Tigare detectata',
      'Ai fumat o tigare!',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  Future<void> _loadQuitDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String strTime = prefs.getString('stringTimeKey') ?? '';
    int maxTimeInSeconds = prefs.getInt('maxTime') ?? 0;
    String lastTimeStr = prefs.getString('lastTime') ?? '';
    if (strTime.isNotEmpty) {
      setState(() {
        maxTime = Duration(seconds: maxTimeInSeconds);
        quitDate = DateTime.parse(strTime);
        lastTime = DateTime.parse(lastTimeStr);
      });
    }
    moneyPerDay = prefs.getInt('moneyKey') ?? 0;
  }

  Future<void> resetCigarettes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cigarettes', 0);
    setState(() {
      cigarettes = 0;
    });
  }

  Duration calculateQuitTime() {
    DateTime now = DateTime.now();
    return now.difference(quitDate);
  }

  Future<void> _loadGoalAndPrice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      goal = prefs.getString('goal') ?? '';
      price = prefs.getInt('price') ?? 0;
      goalSet = prefs.getBool('goalSet') ?? false;
    });
  }

  Future<void> _saveGoalAndPrice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('goal', goal);
    await prefs.setInt('price', price);
    await prefs.setBool('goalSet', true);
  }

  void _setGoal() {
    setState(() {
      goal = goalController.text;
      price = int.tryParse(priceController.text) ?? 0;
      goalSet = true;
    });
    _saveGoalAndPrice();
  }


  void changeMaxTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Duration currentDuration = DateTime.now().difference(quitDate);
    currentBadge = checkMilestones(maxTime);
    if (maxTime < currentDuration) {
      setState(() {
        maxTime = currentDuration;
      });
      prefs.setInt('maxTime', maxTime.inSeconds);
    }
  }

  String checkMilestones(Duration duration) {
    if (duration.inDays >= 30) {
      return "O lună!";
    } else if (duration.inDays >= 7) {
      return "O saptamana";
    } else if (duration.inDays >= 1) {
      return "O zi!";
    }
    return "Încă nicio realizare!";
  }

  int calculateSavedMoney(int nr) {
    double ans = nr * (widget.lastCount - cigarettes) / 20 * widget.lastCost;
    moneyPerDay += ans.toInt();
    updateMoney();
    updateTime(nr);
    return moneyPerDay;
  }

  void updateMoney() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (moneyPerDay >= price) {
      moneyPerDay -= price;
      prefs.setBool('goalSet', false);
    }
    prefs.setInt('moneyKey', moneyPerDay);
  }

  void updateTime(int nr) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime newTime = lastTime.add(Duration(days: nr));
    prefs.setString('lastTime', newTime.toString());
    lastTime = newTime;
  }

  void _toggleService() {
    try {
      platform.invokeMethod('toggleService');
    } on PlatformException catch (e) {
      print("Failed to toggle service: '${e.message}'.");
    }
  }

  String formatDuration(Duration duration) {
    int days = duration.inDays;
    int hours = duration.inHours.remainder(24);
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    return "${days}d ${hours}h ${minutes}m ${seconds}s";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Duration quitDuration = calculateQuitTime();
    changeMaxTime();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // Prevent resizing when the keyboard is opened
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.92,
          child: Padding(
            padding: EdgeInsets.all(0),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/bg.jpg'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.5),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                ),
                // Positioned white container at the bottom
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30)), // Rounded top corners
                    ),
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.4, // Adjust height as needed
                  ),
                ),
                // Main content overlaying the white box
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.02), // Top padding
                      Center(
                        child: GreetingWidget(), // Display greeting at the top center
                      ),
                      SizedBox(height: 0),
                      TimeSinceLastCigarette(
                        quitDuration: quitDuration,
                        maxTime: maxTime,
                      ),
                      SizedBox(height: 10), // Adjusted space between widgets
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CigarettesStatistics(cigarettes: cigarettes),
                          SizedBox(width: 23), // Adjusted space between widgets
                          SavedMoney(moneyPerDay: moneyPerDay),
                          SizedBox(width: 23), // Adjusted space between widgets
                          MaxTimeStatistics(maxTime: maxTime),
                        ],
                      ),
                      SizedBox(height: 22), // Adjusted space between widgets
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 300, // Adjust the maximum width as needed
                        ),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: AchievementBadge(currentBadge: currentBadge),
                          ),
                        ),
                      ),
                      // Adjusted space between widgets
                      if (goalSet)
                        Padding(
                          padding: const EdgeInsets.only(top: 90, left: 10, right: 10, bottom: 30),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.9),
                                  Colors.grey[200]!
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                              // Squircle shape
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color:Color(0x802e1b6c),
                                      // Bright color for the icon
                                      size: 30,
                                    ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: Text(
                                        'Scop: $goal',
                                        style: TextStyle(
                                          color: Colors.black,
                                          // Text color set to black
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.attach_money,
                                      color: Colors.white70,
                                      // Different color for the icon
                                      size: 30,
                                    ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: Text(
                                        'Preț: $price lei',
                                        style: TextStyle(
                                          color: Colors.black,
                                          // Text color set to black
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Column(
                          children: [
                            // Center the TextField and constrain its width
                            Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 80, left: 10, right: 10),
                                child: TextField(
                                  controller: goalController,
                                  decoration: InputDecoration(
                                    labelText: 'Introduceți scopul',
                                    labelStyle: TextStyle(color: Colors.black),
                                    // Label text color set to black
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      // Squircle shape
                                      borderSide: BorderSide(color: Colors
                                          .black), // Border color set to black
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      // Squircle shape
                                      borderSide: BorderSide(
                                        color: Color.fromARGB(255, 112, 142, 116)
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                  style: TextStyle(color: Colors
                                      .black), // Input text color set to black
                                ),
                              ),
                            ),
                            // Center the TextField and constrain its width
                            Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                                child: TextField(
                                  controller: priceController,
                                  decoration: InputDecoration(
                                    labelText: 'Introduceți prețul',
                                    labelStyle: TextStyle(color: Colors.black),
                                    // Label text color set to black
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      // Squircle shape
                                      borderSide: BorderSide(color: Colors
                                          .black), // Border color set to black
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      // Squircle shape
                                      borderSide: BorderSide(
                                        color: Color.fromARGB(255, 112, 142, 116)
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                  style: TextStyle(color: Colors.black),
                                  // Input text color set to black
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: _setGoal,
                              child: Text('Puneți scopul'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Color(0xFFbbb0ea),
                                // Button color changed to cyan
                                padding: EdgeInsets.symmetric(horizontal: 20,
                                    vertical: 10),
                                textStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      30), // Squircle shape
                                ),
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: 5),
                      ActionButton(
                        onPressed: _toggleService,
                        isPlaying: isPlaying,
                        toggleIsPlaying: toggleIsPlaying,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
class GreetingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Bună!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 5), // Adding space between 'Bună!' and username
            FutureBuilder<String>(
              future: getUsername(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Row(
                    children: [
                      Text(
                        snapshot.data ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.waving_hand,
                        color: Colors.white70.withOpacity(0.5),
                        size: 24,
                      ),
                    ],
                  );
                } else {
                  return Text(
                    'User',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<String> getUsername() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userName') ?? ''; // Provide default value if null
}

class ActionButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isPlaying;
  final VoidCallback toggleIsPlaying;

  ActionButton({
    required this.onPressed,
    required this.isPlaying,
    required this.toggleIsPlaying,
  });

  @override
  _ActionButtonState createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  @override
  Widget build(BuildContext context) {



    return ElevatedButton(
      onPressed: () {
        widget.toggleIsPlaying();
        widget.onPressed();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:Color(0x802e1b6c), // Change background color to cyan
        elevation: 5,
        shape: CircleBorder(),
        padding: EdgeInsets.all(20), // Increase padding to make the button bigger
      ),
      child: AnimatedIcon(
        icon: AnimatedIcons.play_pause,
        progress: widget.isPlaying
            ? AlwaysStoppedAnimation<double>(1)
            : AlwaysStoppedAnimation<double>(0),
        color: Colors.white, // Change icon color to white for better contrast
        size: 30, // Adjust icon size if needed
      ),
    );
  }
}

class CigarettesStatistics extends StatelessWidget {
  final int cigarettes;

  CigarettesStatistics({required this.cigarettes});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60, // Circle diameter
      height: 60, // Circle diameter
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x802e1b6c),
            blurRadius: 6,
            // offset: Offset(0, 3),
          ),
        ],
        color: Color(0xFFbbb0ea), // Turquoise color
        shape: BoxShape.circle,
      ),

      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft, // Shift icon to the left
              child: Icon(
                Icons.smoking_rooms, // Relevant icon
                color: Colors.white70.withOpacity(0.5), // Icon color
                size: 20, // Icon size
              ),
            ),
            SizedBox(width: 4), // Adjust spacing as needed
            Text(
              "$cigarettes",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16, // Adjusted font size
                fontFamily: 'Anton',
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class MaxTimeStatistics extends StatelessWidget {
  final Duration maxTime;

  MaxTimeStatistics({required this.maxTime});

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (days > 0) {
      return '$days d';
    } else if (hours > 0) {
      return '$hours h';
    } else if (minutes > 0) {
      return '$minutes m';
    } else if (seconds > 0) {
      return '$seconds s';
    } else {
      return '0 s'; // Default case if everything is zero
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60, // Container width
      height: 60, // Container height
      decoration: BoxDecoration(
        color: Color(0xFFbbb0ea), // Turquoise color
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x802e1b6c),
            blurRadius: 6,
            // offset: Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.access_time, // Relevant icon
              color: Colors.white.withOpacity(0.5), // Icon color
              size: 18, // Larger icon size
            ),
            SizedBox(height: 5),
            Text(
              formatDuration(maxTime),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 15, // Adjusted font size
                fontFamily: 'Anton',
              ),
            ),
            SizedBox(height: 5),

          ],
        ),
      ),
    );
  }
}

String formatDuration(Duration duration) {
  int days = duration.inDays;
  int hours = duration.inHours.remainder(24);
  int minutes = duration.inMinutes.remainder(60);
  int seconds = duration.inSeconds.remainder(60);
  return "${days}d ${hours}h ${minutes}m ${seconds}s";
}


class AchievementBadge extends StatelessWidget {
  final String currentBadge;

  AchievementBadge({required this.currentBadge});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.star, // Icon representing achievement
          color: Colors.white70.withOpacity(0.5), // White color for the icon
          size: 30, // Smaller icon size
        ),
        SizedBox(width: 10), // Add space between icon and text
        Text(
          currentBadge,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // White color for the text
            fontSize: 24, // Smaller font size
            fontFamily: 'Anton',
          ),
        ),
      ],
    );
  }
}

class GoalAndPrice extends StatelessWidget {
  final String goal;
  final int price;

  GoalAndPrice({required this.goal, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      // decoration: BoxDecoration(
      //   color: Color.fromARGB(255,112,142,116).withOpacity(0.5), // Opaque white color
      //   borderRadius: BorderRadius.circular(10),
      // ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.flag, // Goal icon
                color: Colors.white70.withOpacity(0.5),
                size: 40,
              ),
              SizedBox(height: 5),
              Text(
                'Tinta:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$goal',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.attach_money, // Price icon
                color: Colors.white70.withOpacity(0.5),
                size: 40,
              ),
              SizedBox(height: 5),
              Text(
                'Preț:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$price lei',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



class SavedMoney extends StatelessWidget {
  final int moneyPerDay;

  SavedMoney({required this.moneyPerDay});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80, // Circle diameter
      height: 60, // Circle diameter
      decoration: BoxDecoration(
        color: Color(0xFFbbb0ea), // Turquoise color
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x802e1b6c),
            blurRadius: 6,
            // offset: Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.attach_money, // Relevant icon
              color: Colors.white.withOpacity(0.4), // Icon color
              size: 21, // Larger icon size
            ),
            SizedBox(height: 2), // Add space between icon and text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${moneyPerDay.toInt()}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16, // Adjusted font size
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Anton',
                  ),
                ),
                SizedBox(width: 5),
                Opacity(
                  opacity: 0.5,
                  child: Text(
                    'RON',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 7, // Adjusted font size
                      fontFamily: 'Anton',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class TimeSinceLastCigarette extends StatelessWidget {
  final Duration quitDuration;
  final Duration maxTime;

  TimeSinceLastCigarette({required this.quitDuration, required this.maxTime});

  Widget buildTimeCard({required String time, required String header}) {
    List<String> timeValues = time.split(' ');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: timeValues.map((value) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 5), // Increased horizontal padding
              child: Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize:50, // Increased font size
                  fontFamily: 'Anton',
                ),
              ),
            );
          }).toList(),
        ),
        Text(
          header,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 15, // Increased header font size
            fontFamily: 'Anton',
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final days = twoDigits(quitDuration.inDays);
    final hours = twoDigits(quitDuration.inHours % 24);
    final minutes = twoDigits(quitDuration.inMinutes % 60);
    final seconds = twoDigits(quitDuration.inSeconds % 60);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildTimeCard(time: days, header: 'Zile'),
            SizedBox(width: 5), // Increased space between time cards
            buildTimeCard(time: hours, header: 'Ore'),
            SizedBox(width: 5), // Increased space between time cards
            buildTimeCard(time: minutes, header: 'Min'),
            SizedBox(width: 5), // Increased space between time cards
            buildTimeCard(time: seconds, header: 'Sec'),
          ],
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: TimeSinceLastCigarette(
          quitDuration: Duration(days: 1, hours: 3, minutes: 45, seconds: 30),
          maxTime: Duration(days: 100),
        ),
      ),
    ),
  ));
}