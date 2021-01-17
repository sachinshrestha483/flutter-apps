import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'database.dart';
import 'dart:math';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:share/share.dart';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'models/locationdetails.dart';

class ShowLocations extends StatefulWidget {
  static String id = 'ShowLocations';

  @override
  _ShowLocationsState createState() => _ShowLocationsState();
}

class _ShowLocationsState extends State<ShowLocations> {
  Stream<QuerySnapshot> resultDocuments;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData().then((result) {
      setState(() {
        resultDocuments = result;
      });
    });
  }

  LocationFbModel lfb = LocationFbModel();

  @override
  Widget build(BuildContext context) {
    Future<void> _UpdateDialogBox(String userId) async {
      lfb.locationName = null;
      lfb.locationDetails = null;

      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update The  Details'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextField(
                    onChanged: (val) {
                      lfb.locationName = val;
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Location Name'),
                  ),
                  TextField(
                    onChanged: (val) {
                      lfb.locationDetails = val;
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Location Description'),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Update'),
                onPressed: () async {
                  await updateData(userId, lfb);

                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                stream: resultDocuments,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.black,
                      ),
                    );
                  }
                  final messages = snapshot.data.documents;

                  List<Container> containers = [];

                  for (var message in messages) {
                    final placeDescription = message.data['description'];
                    final placeName = message.data['name'];
                    String placePhotoUrl = message.data['photoUrl'];

                    final placeLat = message.data['position'].latitude;
                    final placeLon = message.data['position'].longitude;
                    print(  'https://akcazevoen.cloudimg.io/v7/https://demo.cloudimg.io/width/300/n/$placePhotoUrl?w=300');
                    var rng = new Random();
                    if (placePhotoUrl == null) {
                      placePhotoUrl =
                          'https://firebasestorage.googleapis.com/v0/b/demomap2-4182c.appspot.com/o/default${rng.nextInt(2)}.jpg?alt=media&token=877cfb26-9c13-4eeb-9050-50d0763b7502';
                    }

                    var con = Container(
                      padding: EdgeInsets.all(40),
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        color: Colors.grey[300],
                      ),
                      margin: EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.network(
                              //https://akcazevoen.cloudimg.io/v7/https://demo.cloudimg.io/width/300/n/$placePhotoUrl?w=150
                              'https://akcazevoen.cloudimg.io/v7/https://demo.cloudimg.io/width/300/n/$placePhotoUrl?w=300',
                              //width: 300,
                              height: 300,
                              fit: BoxFit.fill),
                          Text(
                            '$placeName',
                            style: TextStyle(fontSize: 30),
                          ),
                          Divider(color: Colors.black),
                          Text(
                            '$placeDescription',
                            style: TextStyle(fontSize: 20),
                          ),
                          Divider(color: Colors.black),
                          Text(
                            'Latitude: $placeLat',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            'Longotude: $placeLon',
                            style: TextStyle(fontSize: 20),
                          ),
                          Divider(color: Colors.black),
                          Row(
                            children: <Widget>[
                              GestureDetector(
                                  onTap: () async {
                                    //Share.share('Cordinates of $placeName : Lat:$placeLat,Lon:$placeLon  https://www.google.com/maps/search/?api=1&query=$placeLat,$placeLon');
                                    var request = await HttpClient().getUrl(
                                        Uri.parse(
                                            'https://akcazevoen.cloudimg.io/v7/https://demo.cloudimg.io/width/300/n/$placePhotoUrl?w=300'));
                                    var response = await request.close();
                                    Uint8List bytes =
                                        await consolidateHttpClientResponseBytes(
                                            response);
                                    await Share.file('ESYS AMLOG', 'amlog.jpg',
                                        bytes, 'image/jpg',
                                        text:
                                            '🗺️ Mapify app By Sachin\nLocationName:$placeName\nDescription:$placeDescription\n📍Latitude:$placeLat,\n📍Longitude:$placeLon\nLink:https://www.google.com/maps/search/?api=1&query=$placeLat,$placeLon');
                                  },
                                  child: Icon(
                                    Icons.share,
                                    size: 30,
                                  )),
                              SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    launch(
                                        'https://www.google.com/maps/search/?api=1&query=$placeLat,$placeLon');
                                  },
                                  child: Icon(
                                    Icons.map,
                                    size: 30,
                                  )),
                              SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _UpdateDialogBox(message.documentID);
                                },
                                child: Icon(Icons.edit, size: 30),
                              ),
                            ],
                          )
                        ],
                      ),
                    );

                    containers.add(con);
                  }
                  return Expanded(
                    flex: 2,
                    child: SizedBox(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        children: containers,
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
