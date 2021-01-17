import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DataBaseService{

final _firestore=Firestore.instance;


Future addMessages(String message,String email) async {
  return await _firestore.collection('messages')
  .add({
    'text':message,
    'sender':email

  });

}

/*
void  getMessages() async
{
   final messages=await _firestore.collection('messages').getDocuments();

   for(var message in messages.documents)
   {
     print(message.data);
   }
}
*/




void messageStream()async{

  await for(var snapshot in _firestore.collection('messages').snapshots())
  {
    for(var message in snapshot.documents)
    {
      print(message.data);
    }
  }
}






}

 