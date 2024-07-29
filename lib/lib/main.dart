import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'features/app/splash_screen/splash_screen.dart';
import 'features/user_auth/presentation/pages/home_page.dart';
import 'features/user_auth/presentation/pages/login_page.dart';
import 'features/user_auth/presentation/pages/timer/quit_smoking_widget.dart';
import 'first1.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDuEEcWTqN_8i6uLI_r-yrL7W5Tu0N-rPk",
        appId: "1:266538763852:web:c0f5a4f2613e64f769d6e9",
        messagingSenderId: "266538763852",
        projectId: "terog-d08c4",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Quit',
      routes: {
        '/': (context) => SplashScreen(
          child: LoginPage(),
        ),
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/first1': (context) => first1Page(),
        '/quitSmoking': (context) => QuitSmokingWidget(lastCount: 20, lastCost: 15), // Example values
      },
    );
  }
}
