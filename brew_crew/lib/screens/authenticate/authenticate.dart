import 'package:brew_crew/screens/authenticate/register.dart';
import 'package:brew_crew/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  //togle betwen login and signup page
  bool showSignin=true;

  void toggleView()
  {
    setState(() {
      showSignin=!showSignin;
    });

  }



  @override
  Widget build(BuildContext context) {
    if(showSignin==true)
    {
      return SignIn(toggleView:toggleView);
    }
    else{
      return Register(toggleView:toggleView);
    }
    
  }
}