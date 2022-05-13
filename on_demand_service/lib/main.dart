import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:on_demand_service/login_register/prof_login_screen.dart';
import 'package:on_demand_service/login_register/prof_signup_screen.dart';
import 'package:on_demand_service/login_register/prof_signup_screen1.dart';
import 'package:on_demand_service/login_register/user_login_screen.dart';
import 'package:on_demand_service/login_register/user_signup_screen.dart';
import 'package:on_demand_service/user/date_time.dart';
import 'package:on_demand_service/user/prof_detail.dart';
import 'package:on_demand_service/user/user_home_screen.dart';
import 'welcome_screen.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'welcome_screen',
      routes: {
        'welcome_screen': (context) => WelcomeScreen(),
        'user_registration_screen': (context) => UserRegistrationScreen(),
        'prof_registration_screen': (context) => ProfRegistrationScreen(),
        'prof_registration_screen1': (context) => ProfRegistrationScreen1(),
        'user_login_screen': (context) => UserLoginScreen(),
        'prof_login_screen': (context) => ProfLoginScreen(),
        'home_screen': (context) => HomeScreen(),
        'user_home_screen': (context) => UserHomeScreen(),
        'prof_detail_screen': (context) => ProfDetailScreen(),
        'date_time': (context) => DateAndTime()
      },
    );
  }
}
