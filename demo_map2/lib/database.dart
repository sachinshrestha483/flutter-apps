import 'package:flutter/material.dart';
import 'package:demo_map2/models/locationdetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void>addData(LocationFbModel l)
{
   Firestore.instance
   .collection('locations')
   .add({'name':l.locationName,'description':l.locationDetails,'position':new GeoPoint(l.latitude, l.longitude),'photoUrl':l.photoUrl
   }).catchError((e) {
         print(e);
        });
}



Future<Stream<QuerySnapshot>>getData() async
{
  return  await  Firestore.instance.collection('locations').snapshots();
}



Future<void>updateData(selectedDoc,LocationFbModel newValues) async
 {
   //selected doc is the user id

try{
 Firestore.instance
   .collection('locations')
   .document(selectedDoc)
   .updateData({'name':newValues.locationName,
   'description':newValues.locationDetails,

  });
}
catch(e)
{
 print(e);
}
  
    
 }

