import 'package:brew_crew/screens/authenticate/register.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/constants.dart';


class SignIn extends StatefulWidget {

final Function toggleView;

  SignIn({this.toggleView});
  

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  

bool loading=false;

  final AuthService _auth=AuthService();

  final _formKey=GlobalKey<FormState>();


//text field Statte
  String email;

  String password;

  String errorMesage='';



  @override
  Widget build(BuildContext context) {
    return loading?Loading(): Scaffold(
      backgroundColor:Colors.brown[100] ,
      appBar: AppBar(title: Text('Sign in '),
      actions: <Widget>[
         FlatButton.icon(onPressed: (){
          widget.toggleView();
        }, icon: Icon(Icons.person), label: Text('Register'))
      ],
      backgroundColor: Colors.brown[400],

      ),
      body: Container( 
        padding: EdgeInsets.symmetric(vertical:20,horizontal:50),

        child:Form(
          key: _formKey,

                  child: Column(children: <Widget>[

            SizedBox(height: 20,),
            TextFormField(

              decoration:kTextFieldDecoration.copyWith(hintText: 'Enter Your Email'), 




              validator: (val)=>val.isEmpty?'Enter Email':null,

              onChanged: (val)
              {
                email=val;


              },
            ),
            SizedBox(height: 20,),

            TextFormField(
              decoration:kTextFieldDecoration.copyWith(hintText: 'Enter Your Password'), 
              
              validator: (val)=>val.length<6?'Password is greater Than 6 Letter ':null,
              
              onChanged: (val){


              password=val;



            },
            obscureText: true,
            ),

            SizedBox(height: 20,),
            RaisedButton(onPressed:
             ()async{


               if(_formKey.currentState.validate())
               {
                 setState(() {
                   loading=true;
                 });
                 dynamic result=await _auth.signInWithEmailAndPAssword(email, password);
                 
                 
                 setState(() {
                 if(result==null)
                 {
                    errorMesage='Could Not Signin With Given Email And Password jbjb';
                    
                    loading=false;


                 }

                  });
               }

               print(email);
               print(password);

            },color: Colors.pink,
            child: Text('Sign in ',style: TextStyle(color: Colors.white),),),
            SizedBox(height: 12,),
            Text(
              errorMesage,style: TextStyle(color: Colors.red
              ,fontSize: 15),
            )


          ],),
        )
        ),

    );
  }
}  