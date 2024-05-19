import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '/features/app/splash_screen/splash_screen.dart';
import '/features/user_auth/presentation/pages/home_page.dart';
import '/features/user_auth/presentation/pages/login_page.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(options: FirebaseOptions(apiKey: "AIzaSyAbSpk6dOI79budR7XxCiBJ0_xi5iCKiXw", appId: "1:1068779181423:android:9e5eb04f3ca6985601049a", messagingSenderId: "1068779181423", projectId: "smartquit-4c777"));
  }
  if(defaultTargetPlatform == TargetPlatform.android) {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      routes: {
        '/': (context) => SplashScreen(
          // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
          child: LoginPage(),
        ),
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}