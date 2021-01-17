import 'package:demo_map2/addLocation.dart';
import 'package:demo_map2/showLocations.dart';
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
      initialRoute: AddLocation.id,
    routes: {
      AddLocation.id:(context)=>AddLocation(),
      ShowLocations.id:(context)=>ShowLocations(),
    },
    );
  }
}