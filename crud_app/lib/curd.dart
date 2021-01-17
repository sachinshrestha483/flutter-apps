import 'dart:async';
 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_app/Models/VehicleModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
 
class crudMedthods {
  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else {
      return false;
    }
  }
 
  Future<void> addData(Vehicle v) async {
    if (isLoggedIn()) {
      Firestore.instance.
      collection('testcrud')
      .add({'model':v.modelname,'color':v.color})
      .catchError((e) {
         print(e);
       });
    } else {
      print('You need to be logged in');
    }
  }

Future<Stream<QuerySnapshot>>getData() async
{
  return  await  Firestore.instance.collection('testcrud').snapshots();
}



 Future<void>updateData(selectedDoc,newValues) async
 {

try{
 Firestore.instance
   .collection('testcrud')
   .document(selectedDoc)
   .updateData({'model':newValues.modelname,'color':newValues.color});
}
catch(e)
{
 print(e);
}
  
    
 }



 Future<void> deleData(docId)
 {

   try{

     Firestore.instance
   .collection('testcrud')
   .document(docId)
   .delete();


   }

   catch(e)
   {
     print(e);
   }
   
   
   
   
 }


}