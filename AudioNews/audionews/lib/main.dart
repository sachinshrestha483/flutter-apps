import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_extractor/youtube_extractor.dart';

void main() => runApp(HomePage());

bool play = false;
AudioPlayer audioPlayer = AudioPlayer();
var extractor = YouTubeExtractor();
String dd = "link";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Title(color: Colors.amber, child: Text("Audio News")),
          backgroundColor: Colors.indigo[150],
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[],
          ),
        ),
      ),
    );
  }
}
