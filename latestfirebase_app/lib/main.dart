import 'package:flutter/material.dart';
import 'package:latestfirebase_app/screens/chat_screen.dart';
import 'package:latestfirebase_app/screens/login_screen.dart';
import 'package:latestfirebase_app/screens/registration_screen.dart';
import 'package:latestfirebase_app/screens/welcome_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          body1: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: ChatScreen.id,
      routes: {
        WelcomeScreen.id:(context)=>WelcomeScreen(),
        ChatScreen.id:(context)=>ChatScreen(),
        LoginScreen.id:(context)=>LoginScreen(),
        RegistrationScreen.id:(context)=>RegistrationScreen(),
      },
    );
  }
}

