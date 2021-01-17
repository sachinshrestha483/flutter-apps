import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:geolocator/geolocator.dart';

var currentLocation;

var calDistance;





bool maptoggle = false;
bool clientsToggle = false;
List<double> distances=[];

bool isCal=false;
int counter=0;



Set<Marker> clients = {};
var alldata=[];
//var distances=[];
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Completer<GoogleMapController> _controller = Completer();
GoogleMapController mapController;


  @override

   void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    mapController=controller;
  }

  void initState() {
    // TODO: implement initState
    Geolocator().getCurrentPosition().then((curlocation) {
      setState(() {
        currentLocation = curlocation;
        maptoggle = true;
        populateClients();






      });
    });
  }


//function for test only
  Future<double> distanceCalculator(var dlat,var dlon) async
 {
   //calDistance=0;


  calDistance=  await Geolocator().distanceBetween(currentLocation.latitude, currentLocation.longitude, dlat,dlon);

  

   

   return calDistance;

   
  

  // return calDistance;
 }



void ZoomInMarker( lat, lon)
{
 mapController.animateCamera(
  CameraUpdate.newCameraPosition(
    CameraPosition(
      target: LatLng(lat,lon),
      tilt: 50.0,
      bearing: 45.0,
      zoom: 20.0,
    ),
  ),
);




}


  initMarker(client) {
    setState(() {
      clients.add(Marker(
        markerId: MarkerId(client.documentID.toString()),
        position: LatLng(client.data['location'].latitude,
            client.data['location'].longitude),
        infoWindow: InfoWindow(
            title: client.data['clientname'],
            snippet: client.data['clientname']),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }



//calculate distance for calculating the distances
calculateDistances()
{

  distances.clear();
   Firestore.instance.collection('markers').getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
       setState(() {
       isCal=true;
         
       });
        for (int i = 0; i < docs.documents.length; ++i) {
         distanceCalculator(docs.documents[i].data['location'].latitude,docs.documents[i].data['location'].longitude).then((x)
         {
           x=x/1000;
           distances.add(x);
           // print(i);
            //print(distances[i]);

         });
      
     
        }
      }
    });
}


printDistances()
{
  for(int i=0;i<distances.length;i++)
  {
    print(distances[i]);
  }
}

//

  populateClients()  {
    Firestore.instance.collection('markers').getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        setState(() {
          clientsToggle = true;
        });
        for (int i = 0; i < docs.documents.length; i++) {
          alldata.add(docs.documents[i].data);
      
     
          print('data is here');
          print(docs.documents[i].data['location'].latitude);
          initMarker(docs.documents[i]);
        }
      }
    });
  }



Widget MapCards(client)
{
  //counter=0;
  if(counter>distances.length)
  {
    setState(() {

    isCal=false;

      
    });
  }
 
    return  Container(
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[50],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                          child: Text(
                        client['clientname'],
                        style: TextStyle(
                            fontSize: 20, color: Colors.grey),
                      )),
                      Container(
                        width: 200,
                        child: Divider(
                          color: Colors.black,
                        ),
                      ),
                      Text('Place Near the  temple of humanity'),
                     Text("Latitude : ${client['location'].latitude}" ),
                      Text('Latitude : ${client['location'].longitude}'),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          isCal?Text('${distances[counter++]}'):Text('Tap on Refresh To Load the Data'),


                          
                          
                        ],
                      ),
                      GestureDetector(
                        onTap: (){
                          ZoomInMarker(client['location'].latitude,client['location'].longitude);
                          },
                                              child: Icon(
                          Icons.map,
                          size: 40,
                        ),
                      )
                    ],
                  ),
                ),
              );

             
}
 
  @override
  Widget build(BuildContext context) {
   
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Maps Sample App'),
            backgroundColor: Colors.green[700],
          ),
          body: Stack(
            children: <Widget>[
              maptoggle
                  ? GoogleMap(
                      onMapCreated: _onMapCreated,
                      myLocationEnabled: true,
                      initialCameraPosition: CameraPosition(
                          target: LatLng(currentLocation.latitude,
                              currentLocation.longitude),
                          zoom: 12),
                      markers: clients,
                      mapToolbarEnabled: true,
                      //minMaxZoomPreference:MinMaxZoomPreference.unbounded,
                    )
                  : Center(
                      child: Text('Loading Please  Wait'),
                    ),
             clientsToggle?
              Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
            children: alldata.map((element){
              return MapCards(element);
            }).toList()
          ),
        ),
      ],
 ):Text('You Dont Have Any Saved Locations'),

GestureDetector(

  onTap: ()async {
          //await    distanceCalculator(client['location'].latitude, client['location'].longitude);
          counter=0;
  calculateDistances();                         
  

  },
  child:   Row(children: <Widget>[
  
  Icon(Icons.restore,size: 40,),
  
  Text("Calculate Distance",style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold),)
  
  
  
  ],),
)
 


            ],
          )),
    );
  }

  //distancecalculator(latitude, longitude) {}
}











 