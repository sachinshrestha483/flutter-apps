import 'package:brew_crew/models/brew.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class DatabaseService{

 final String uid;
  DatabaseService({this.uid});
 // if collection not exist then it would  create it
  final CollectionReference brewColection=Firestore.instance.collection('brews');

  Future updateUserData(String sugars,String name,int strength) async{

    return await brewColection.document(uid).setData({
      'sugars':sugars,
      'name':name,
      'strength':strength,
    });



  }


List<Brew>_brewListFromSnapShots(QuerySnapshot snapshot)
{
  return snapshot.documents.map((doc){

    return Brew(
      name:doc.data['name']??' ',
      strength: doc.data['stregth']?? 0,
      
      sugars: doc.data['sugars']??'0'


    );

  }).toList();
}




//brew list from snam shot

  Stream<List<Brew>> get brews{
    return brewColection.snapshots()
    .map(_brewListFromSnapShots);
  }
   
}