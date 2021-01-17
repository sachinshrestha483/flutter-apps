import 'package:flutter/material.dart';
import 'package:tchat_app/constant.dart';
import 'package:tchat_app/screens/chat_screen.dart';
import 'package:tchat_app/services/auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static String id='LoginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}




class _LoginScreenState extends State<LoginScreen> {
final AuthService _auth=AuthService();

String email;
String password;
String errorMesage='';
bool showSpinner=false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
          child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                              child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(

                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,




               style: TextStyle(color: Colors.black),





                onChanged: (value) {

                  
                  email=value;

                },
                decoration:ktextFieldDecoration.copyWith(hintText:'Enter Email')
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(


                obscureText: true,



                textAlign: TextAlign.center,


               style: TextStyle(color: Colors.black),




                onChanged: (value) async {
                  password=value;
                  
                },
                decoration:ktextFieldDecoration.copyWith(hintText:'Enter   Password ')
              ),
              SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: ()async {
                      setState(() {
                        showSpinner=true;
                      });
                      var user= await _auth.signInWithEmailAndPAssword(email, password);

                      if(user!=null)
                      {

                        Navigator.pushNamed(context, ChatScreen.id);

                      }


                      else{

                        setState(() {
                        errorMesage="Wrong email And Pasword";
                          
                        });


                      }

                      setState(() {
                        showSpinner=false;
                      });
                      


                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Log In',
                    ),
                  ),
                ),
              ),

              Text('$errorMesage',style: TextStyle(color: Colors.red,fontSize: 35),)
            ],
          ),
        ),
      ),
    );
  }
}