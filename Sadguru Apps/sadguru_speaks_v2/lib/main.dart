import 'dart:convert';

//import 'package:admob_flutter/admob_flutter.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:marquee_widget/marquee_widget.dart';
////import 'package:just_audio/just_audio.dart';

import 'Models/podcast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Podcast> listModel = [];

  //final ans = AdMobService();

  AudioPlayer audioPlayer = AudioPlayer();
  bool play = false;
  bool loadingAudio = false;
  String currentUrl = "";
  String nameofPodcast = "";
  int podcastNumber = -1;
  Duration dummyDuration = new Duration(minutes: 0);

  /// for slider
  Duration durationofSong;
  Duration currentPositionofsong;

  double cduration = 0;

  void playbyNumber(int index) {
    if (index > listModel.length - 1) {
    } else {
      audioPlayer.play(listModel[index].url);
      setState(() {
        play = true;
        currentUrl = listModel[index].url;
        podcastNumber = index;
      });
      currentUrl = listModel[index].url;
      podcastNumber = index;
      play = true;
    }
  }

  void mPlayer(String url, int index) async {
    /*
    print("jjjj->");
    print(url);
    // await audioPlayer.setUrl(url); //
    audioPlayer.play(url, isLocal: false);
*/

    if (currentUrl == url && play == true) {
      audioPlayer.pause();
      setState(() {
        play = false;
      });
      play = false;
    } else if (currentUrl == url && play == false) {
      audioPlayer.play(url);
      setState(() {
        play = true;
      });
      play = true;
    } else if (currentUrl != url && play == false) {
      setState(() {
        loadingAudio = true;
      });
      loadingAudio = true;
      await audioPlayer.setUrl(url);

// new song plays setting value of it in player
      audioPlayer.onDurationChanged.listen((Duration d) {
        print('Max duration: $d');
        setState(() => durationofSong = d);
      });
      audioPlayer.onAudioPositionChanged.listen((Duration p) {
        print('Current position: $p');
        setState(() => currentPositionofsong = p);
      });

      setState(() {
        cduration = durationofSong.inSeconds.toDouble();
      });
      cduration = durationofSong.inSeconds.toDouble();
      currentUrl = url;
      audioPlayer.play(url);
      setState(() {
        loadingAudio = false;
      });
      loadingAudio = false;

      setState(() {
        play = true;
        currentUrl = url;
      });

      // set the number of song
      podcastNumber = index;

      setState(() {
        podcastNumber = index;
      });

      play = true;
    } else if (currentUrl != url && play == true) {
      audioPlayer.pause();
      currentUrl = url;
      setState(() {
        loadingAudio = true;
      });
      loadingAudio = true;
      await audioPlayer.setUrl(url);
      audioPlayer.onDurationChanged.listen((Duration d) {
        print('Max duration: $d');
        setState(() => durationofSong = d);
      });
      audioPlayer.onAudioPositionChanged.listen((Duration p) {
        print('Current position: $p');
        setState(() => currentPositionofsong = p);
      });
      setState(() {
        cduration = durationofSong.inSeconds.toDouble();
      });
      audioPlayer.play(url);
      setState(() {
        loadingAudio = false;
      });
      loadingAudio = false;

      setState(() {
        currentUrl = url;
      });
      podcastNumber = index;
      setState(() {
        podcastNumber = index;
      });
    }
  }

  /*final player = AudioPlayer();
  bool play = false;
  String currentUrl = "";
  void setSong(String url) async {
    print(url);
 
    if (currentUrl == url && play == true) {
      player.pause();
      play = false;
    } else if (currentUrl == url && play == false) {
      player.play();
      play = true;
    } else if (currentUrl != url && play == false) {
      await player.setUrl(url);
      currentUrl = url;
      player.play();
      play = true;
    } else if (currentUrl != url && play == true) {
      player.pause();
      currentUrl = url;
      await player.setUrl(url);
      player.play();
    }
  }
*/

  var loading = false;

  Future<Null> getData() async {
    setState(() {
      loading = true;
    });

    final responseData =
        await http.get("https://sadgurupodcast.netlify.app/podcasts.json");

    if (responseData.statusCode == 200) {
      final data = jsonDecode(responseData.body);
      print(data);
      setState(() {
        for (Map i in data) {
          listModel.add(Podcast.fromJson(i));
        }
        loading = false;
      });
      for (int i = 0; i < listModel.length; i++) {
        print(listModel[i]);
      }
    }
  }

  String status = 'hidden';
  bool loadScreen = false;
  void Showwelcomescreen() async {
    loadScreen = true;
    await new Future.delayed(const Duration(seconds: 5));

    loadScreen = false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    currentPositionofsong = Duration(minutes: 0);
    durationofSong = Duration(minutes: 1);
    //Showwelcomescreen();

    // Admob.initialize(ans.getAdMobAppId());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(accentColor: Colors.deepOrangeAccent),
      home: Scaffold(
        appBar: AppBar(
            title: Text(
              "Sadguru Speaks",
              style: TextStyle(
                fontFamily: 'Gd',
                fontSize: 24,
                letterSpacing: 0,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.brown,
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      getData();
                    },
                    child: Icon(
                      Icons.refresh,
                      size: 26.0,
                    ),
                  )),
            ]),
        body: SafeArea(
          child: (loading)
              ? Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 5,
                  ),
                )
              : Stack(
                  children: [
                    ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                              color: Colors.black,
                            ),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                        itemCount: listModel.length,
                        itemBuilder: (BuildContext context, int index) {
                          return MaterialButton(
                              onPressed: () {
                                // setSong(listModel[index].url);
                                print('button pressed ${listModel[index].url}');
                                mPlayer(listModel[index].url, index);
                              },
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        child: Image.network(
                                          listModel[index].photo,
                                          height: 250.0,
                                          //  width: 150.0,
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                            height: 150,
                                          ),
                                          (play == true &&
                                                  currentUrl ==
                                                      listModel[index].url)
                                              ? Icon(
                                                  Icons.pause,
                                                  size: 40,
                                                  color: Colors.white70,
                                                )
                                              : (loadingAudio &&
                                                      currentUrl ==
                                                          listModel[index].url)
                                                  ? CircularProgressIndicator()
                                                  : Icon(
                                                      Icons.play_arrow_sharp,
                                                      size: 40,
                                                      color: Colors.white70,
                                                    ),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: (index == listModel.length - 1)
                                        ? 150
                                        : 0,
                                  )
                                ],
                              ));
                        }),
                    (podcastNumber == -1)
                        ? SizedBox(
                            height: 1,
                            width: 1,
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(), color: Colors.white),
                                //alignment: Alignment.bottomCenter,
                                height: 170,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: 15,
                                      width: 15,
                                    ),
                                    /*   Marquee(
                                  text:
                                      'There once was a boy who told this story about a boy: "',
                                ),
                                */
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(12, 0, 12, 0),
                                      child: Center(
                                        child: Marquee(
                                          child: Text(
                                            listModel[podcastNumber].name,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                                wordSpacing: 2),
                                          ),
                                          textDirection: TextDirection.rtl,
                                          animationDuration:
                                              Duration(seconds: 1),
                                          backDuration:
                                              Duration(milliseconds: 5000),
                                          pauseDuration:
                                              Duration(milliseconds: 2500),
                                          directionMarguee:
                                              DirectionMarguee.oneDirection,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        MaterialButton(
                                          onPressed: () {
                                            (podcastNumber == 0)
                                                ? print("firstSong")
                                                : playbyNumber(
                                                    podcastNumber - 1);
                                          },
                                          child: Icon(
                                            Icons.arrow_left,
                                            size: 50,
                                          ),
                                        ),
                                        (play == true)
                                            ? MaterialButton(
                                                onPressed: () async {
                                                  int result =
                                                      await audioPlayer.pause();
                                                  if (result == 1) {
                                                    setState(() {
                                                      play = false;
                                                    });
                                                    play = false;
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.pause,
                                                  size: 40,
                                                ),
                                              )
                                            : MaterialButton(
                                                onPressed: () async {
                                                  int result = await audioPlayer
                                                      .resume();
                                                  if (result == 1) {
                                                    setState(() {
                                                      play = true;
                                                    });
                                                    play = true;
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.play_arrow,
                                                  size: 40,
                                                ),
                                              ),
                                        MaterialButton(
                                          onPressed: () {
                                            (podcastNumber ==
                                                    listModel.length - 1)
                                                ? print("s")
                                                : playbyNumber(
                                                    podcastNumber + 1);
                                          },
                                          child: Icon(
                                            Icons.arrow_right,
                                            size: 50,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Slider(
                                        value: (currentPositionofsong == null)
                                            ? 0
                                            : currentPositionofsong.inSeconds
                                                .toDouble(),
                                        onChanged: (double value) {
                                          setState(() async {
                                            value = value;
                                            await audioPlayer.seek(Duration(
                                                seconds: value.toInt()));
                                            value =
                                                (currentPositionofsong == null)
                                                    ? 0
                                                    : currentPositionofsong
                                                        .inSeconds
                                                        .toDouble();
                                          });
                                        },
                                        min: 0.0,
                                        max: (durationofSong == null)
                                            ? 0
                                            : durationofSong.inSeconds
                                                .toDouble()),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 0, 20, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            ((currentPositionofsong.inSeconds) /
                                                        60)
                                                    .toInt()
                                                    .toString() +
                                                ":" +
                                                ((currentPositionofsong
                                                            .inSeconds) %
                                                        60)
                                                    .toInt()
                                                    .toString(),
                                            textAlign: TextAlign.end,
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          Text(
                                            (durationofSong.inSeconds / 60)
                                                    .toInt()
                                                    .toString() +
                                                ":" +
                                                (durationofSong.inSeconds % 60)
                                                    .toInt()
                                                    .toString(),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
        ),
      ),
    );
  }
}
