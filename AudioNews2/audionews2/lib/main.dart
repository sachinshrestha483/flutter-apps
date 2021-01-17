import 'package:audioplayer/audioplayer.dart';
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
      home: Scaffold(
        backgroundColor: Colors.teal,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Text("gjg"),
              RaisedButton(
                onPressed: () async {
                  AudioPlayer audioPlugin = AudioPlayer();

                  print("p1");
                  await audioPlugin.play(
                      "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3");

                  print("p2");
                },
                child: Text("Play"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
