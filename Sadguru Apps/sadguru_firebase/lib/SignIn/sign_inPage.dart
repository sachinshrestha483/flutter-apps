import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  String email;
  String password;

  final databaseReference = Firestore.instance;

  void getData() {
    databaseReference
        .collection("Podcasts")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => print('${f.data}}'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("This App"),
          centerTitle: true,
          elevation: 50,
        ),
        body: Column(
          children: [
            RaisedButton(
              onPressed: _signInAnonymously,
              child: Text("Go Anony Mous"),
            ),
          ],
        ));
  }

  void _signInAnonymously() async {
    final authResult = await FirebaseAuth.instance.signInAnonymously();
    print('${authResult.user.uid}');
    getData();
  }
}
