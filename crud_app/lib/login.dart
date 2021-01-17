import 'package:crud_app/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {

  static  String id='LoginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

String email;
String password;


final _auth=FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(title: Text('Login Here'),),
  body:Padding(
    padding: const EdgeInsets.all(50.0),
    child: Column(children: <Widget>[
 TextField(
               decoration: InputDecoration(
                  border: InputBorder.none,
                 hintText: 'Enter a email'
                    ),
                    onChanged: (value){
                      email=value;
                    //  print(value);
                    },
                   ),
 TextField(
               decoration: InputDecoration(
                  border: InputBorder.none,
                 hintText: 'Enter a Password'
                    ),
                    onChanged: (value){
                      password=value;
                    //  print(value);
                    },
                   ),

RaisedButton(
          onPressed: () async {
            print(email);
            print(password);
            try{
              final newUser=await _auth.signInWithEmailAndPassword(email: email, password: password);
            if(newUser!=null)
            {
              Navigator.pushNamed(context, Dashboard.id);
            }

            }
            catch(e)
            {
              print(e);
            }

            



          },
          child: const Text(
            'Login',
            style: TextStyle(fontSize: 20)
          ),
        ),
    ],),
  ),
    );
  }
}