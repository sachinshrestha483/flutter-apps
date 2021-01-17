import 'package:brew_crew/constants.dart';
import 'package:brew_crew/screens/authenticate/sign_in.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  
  final Function toggleView;

  Register({this.toggleView});

  
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  


  final AuthService _auth=AuthService();
  
  final _formKey=GlobalKey<FormState>();



  bool loading=false;

  String email;
  String password;
  String errorMesage='';
  
  @override
  Widget build(BuildContext context) {
    return loading?Loading(): Scaffold(
      backgroundColor:Colors.brown[100] ,
      appBar: AppBar(title: Text('Sign Up To Brew Crew '),
      backgroundColor: Colors.brown[400],
      actions: <Widget>[
        FlatButton.icon(onPressed: (){
        widget.toggleView();  
        }, icon: Icon(Icons.person), label: Text('Login'))
      ],
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
            



              validator: (val)=>val.length<6?'Enter Password 6 + char Long':null,
              
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

                 dynamic result =await _auth.registerWithEmailAndPAssword(email,password);

           setState(() {
                 if(result==null)
                 {
                    errorMesage='Please Enter Valid Email';
                    loading=false;
                 }

                  });
  
               }


               

            },color: Colors.pink,
            child: Text('Register',style: TextStyle(color: Colors.white),),
            ),
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