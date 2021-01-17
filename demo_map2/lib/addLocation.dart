import 'dart:math';
import 'dart:core';
import 'package:demo_map2/showLocations.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'database.dart';
import 'package:demo_map2/models/locationdetails.dart';

import 'package:geolocator/geolocator.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

bool isuploaded = false;
bool showpos = false;
bool isImageselected = false;


Position currentLocation;
var sampleImage;
String errorMessage='';
const chars = "abcdefghijklmnopqrstuvwxyz0123456789";

class AddLocation extends StatefulWidget {
  static String id = 'AddLocation';
  @override
  _AddLocationState createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
//  final _formKey = GlobalKey<FormState>();
  String locationName;
  String locationDesc;

 



  Future getImage() async {
    var tempimage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = tempimage;
      isImageselected = true;
    });
  }

  
  Future getImageFromCam() async {
    var tempimage = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      sampleImage = tempimage;
      isImageselected = true;
    });
  }


  String RandomString(int strlen) {
    Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
    String result = "";
    for (var i = 0; i < strlen; i++) {
      result += chars[rnd.nextInt(chars.length)];
    }
    return result;
  }

  void GetLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);

    setState(() {
      showpos = true;
      currentLocation = position;
    });
    currentLocation = position;
    print(position.latitude);
    print(position.longitude);
  }

  @override
  void initState() {
    super.initState();
    GetLocation();
  }

  LocationFbModel lfb=LocationFbModel();

  @override
  Widget build(BuildContext context) {
    return isuploaded
        ? SpinKitRotatingCircle(
            color: Colors.white,
            size: 50.0,
          )
        : Scaffold(
            appBar: AppBar(title: Text('Add Locat')),
            body: SafeArea(
                child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: sampleImage == null
                              ? Text('')
                              : Image.file(sampleImage,
                                  height: 300, width: 300),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RaisedButton(
                              color: Colors.grey,
                              textColor: Colors.white,
                              disabledColor: Colors.grey,
                              disabledTextColor: Colors.black,
                              padding: EdgeInsets.all(8.0),
                              splashColor: Colors.amberAccent,
                              onPressed: () {
                                getImage();
                              },
                              child: Text(
                                "${isImageselected ? 'Gallery' : 'Gallery '}",
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ),



                            SizedBox(width: 15,),




                             RaisedButton(
                              color: Colors.grey,
                              textColor: Colors.white,
                              disabledColor: Colors.grey,
                              disabledTextColor: Colors.black,
                              padding: EdgeInsets.all(8.0),
                              splashColor: Colors.amberAccent,
                              onPressed: () {
                                getImageFromCam();
                              },
                              child: Text(
                                "${isImageselected ? ' Camera' : 'Camera'}",
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ),
                          ],
                        ),
                        Text('$errorMessage',style: TextStyle(color:Colors.red,fontSize:20),),
                        SizedBox(
                          height: 12,
                        ),
                        TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter a Place Name'),
                          // The validator receives the text that the user has entered.
                         
                          onChanged: (value) {
                            lfb.locationName= value;

                          },
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter  Location Description'),
                          // The validator receives the text that the user has entered.
                          
                          onChanged: (val) {
                            lfb.locationDetails = val;
                          },
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Latitude:${showpos ? currentLocation.latitude : 'loading'}',
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Text(
                                'Longitude:${showpos ? currentLocation.longitude : 'loading'}',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        RaisedButton(
                          onPressed: () async {
                            //// Validate returns true if the form is valid, otherwise false.
                            
                            if(lfb.locationName!=null&&sampleImage!=null)
                            {

                              setState(() {
                                isuploaded = true;
                                print('from inside the if loop');
                               
                              });
                              lfb.latitude=currentLocation.latitude;
                              lfb.longitude=currentLocation.longitude;
                              /*  print(lfb.locationName);
                                print(lfb.locationDetails);
                                print(lfb.latitude);
                                print(lfb.longitude);
                             */

                            print('from outside the if loop');

                            var rng = new Random();
                            final StorageReference firebaseStorageRef =
                                FirebaseStorage.instance.ref().child(
                                    rng.nextInt(100000).toString() +
                                        RandomString(10) +
                                        'myimage' +
                                        rng.nextInt(100000).toString() +
                                        rng.nextInt(1000000).toString() +
                                        '.jpg');

                            final StorageUploadTask task =
                                firebaseStorageRef.putFile(sampleImage);

                            await task.onComplete;
                            var url =
                                await firebaseStorageRef.getDownloadURL();

                                lfb.photoUrl=url;

                             addData(lfb);
                             lfb.locationName=null;   
                            setState(() {
                              isuploaded = false;
                            });

                            print(lfb.photoUrl);
                            }


                            else{
                              setState(() {
                                errorMessage="Please Enter Location Name only";
                              });
                            }
                          },
                          child: Text('Submit'),
                        ),


                        SizedBox(height: 12,),

                        new RaisedButton(
                    onPressed: (){
                      Navigator.pushNamed(context,  ShowLocations.id);
                     
                    },
                    textColor: Colors.white,
                    color: Colors.red,
                    padding: const EdgeInsets.all(8.0),
                    child: new Text(
                      "Go to Show Locations",
                    ),
                        ),
                      ]),
                ),
              ],
            )),
          );
  }
}

Widget enableUpload() {
  return Container(
    child: Column(
      children: <Widget>[
        Image.file(sampleImage, height: 300, width: 300),
        RaisedButton(
          child: Text('Upload'),
          textColor: Colors.white,
          color: Colors.blue,
          onPressed: () async {
            final StorageReference firebaseStorageRef =
                FirebaseStorage.instance.ref().child('myimage.jpg');
            var url = await firebaseStorageRef.getDownloadURL();
            print(url);
            final StorageUploadTask task =
                firebaseStorageRef.putFile(sampleImage);
          },
        )
      ],
    ),
  );
}
