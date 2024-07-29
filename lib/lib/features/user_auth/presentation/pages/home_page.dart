import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'timer/quit_smoking_widget.dart';
import 'health_page.dart'; // Add this import

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  int _selectedIndex = 0; // Default to Wallet page
  int? countCnt, countCost;
  String _username = 'Default Username';
  String _email = 'example@example.com';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
    _initializeCounters();
    _loadUserData();
  }

  Future<void> _initializeCounters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      countCnt = prefs.getInt('cnt');
      countCost = prefs.getInt('cost');
    });
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'Default Username';
      _email = prefs.getString('email') ?? 'example@example.com';
    });
  }

  @override
  Widget build(BuildContext context) {
    Color greenColor = Color.fromARGB(255, 142, 185, 146);

    return Scaffold(
      body: Container(
        color: Color(0x802e1b6c),

          child: Column(
          children: [
            Expanded(
              child: _getBody(_selectedIndex),
            ),
            _buildBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color:
        Color(0xFFbbb0ea),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color:
            Color(0xFFbbb0ea),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.black,
        elevation: 0,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFF02e1b6c)
        ,
        unselectedItemColor: Color(0xFFbbb0ea),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: " "

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.health_and_safety),
              label: " "
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
              label: " "
          ),
        ],
      ),
    );
  }

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return FadeTransition(
          opacity: _animation,
          child: _buildWalletPage(),
        );
      case 1:
        return FadeTransition(
          opacity: _animation,
          child: HealthPage(), // Update this line
        );
      case 2:
        return FadeTransition(
          opacity: _animation,
          child: _buildAccountPage(),
        );
      default:
        return _buildWalletPage();
    }
  }

  Widget _buildWalletPage() {
    if (countCnt == null || countCost == null) {
      return Center(child: CircularProgressIndicator(color: Color(0xFF3E92CC)));
    } else {
      return Center(
        child: QuitSmokingWidget(
          lastCount: countCnt ?? 0,
          lastCost: countCost ?? 0,
        ),
      );
    }
  }

  Widget _buildAccountPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            child: Transform.scale(
              scale: 5.0,
              child: SvgPicture.asset(
                'assets/profile-circle.svg',
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: 250,
            child: Divider(
              color: Colors.white70,
            ),
          ),
          ListTile(
            title: Center(
              child: Text(
                'Username',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            subtitle: Center(
              child: Text(
                _username,
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
            ),
            trailing: Padding(
              padding: EdgeInsets.only(right: 45.0),
              child: IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: _showChangeUsernameDialog,
              ),
            ),
          ),
          Container(
            width: 250,
            child: Divider(
              color: Colors.white70,
            ),
          ),
          ListTile(
            title: Center(
              child: Text(
                'Email',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            subtitle: Center(
              child: Text(
                _email,
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
            ),
          ),
          Container(
            width: 250,
            child: Divider(
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              logOut();
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, "/login");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0x802e1b6c),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Sign Out',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', ' ');
    prefs.setString('password', ' ');
  }

  Future<void> _showChangeUsernameDialog() async {
    TextEditingController _usernameController = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Username'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(hintText: 'Enter new username'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Change'),
              onPressed: () {
                setState(() {
                  _username = _usernameController.text;
                  _saveUsername(_username);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
