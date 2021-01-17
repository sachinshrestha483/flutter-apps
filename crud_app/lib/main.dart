import 'package:crud_app/dashboard.dart';
import 'package:crud_app/login.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      initialRoute: LoginScreen.id,

      routes: {

        LoginScreen.id:(context)=>LoginScreen(),
        Dashboard.id:(context)=>Dashboard()

        
      },

    );
  }
}