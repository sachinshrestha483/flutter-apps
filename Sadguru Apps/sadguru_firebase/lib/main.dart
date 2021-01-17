import 'package:flutter/material.dart';

import 'SignIn/sign_inPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Time Tracker App",
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: SignInPage(), //
    );
  }
}
