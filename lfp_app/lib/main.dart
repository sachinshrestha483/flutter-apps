import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
    final _auth =FirebaseAuth.instance;



  String email;
  String password;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          home: Scaffold(
         
        appBar: AppBar(title:Text('Demo App'),backgroundColor: Colors.green[100],),
        backgroundColor: Colors.white,
        body:SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  TextField(
               decoration: InputDecoration(
                  border: InputBorder.none,
                 hintText: 'Enter a email'
                    ),
                    onChanged: (value){
                      email=value;
                      print(value);
                    },
                   ),

               TextField(
                 obscureText: true,
               decoration: InputDecoration(
                  border: InputBorder.none,
                 hintText: 'Enter a Password'
                    ),
                    onChanged: (value){
                      password=value;
                      print(value);
                    },
                   ),


                   MaterialButton(onPressed: ()async {

                    try{

                     AuthResult newUser= await _auth.createUserWithEmailAndPassword(email: email, password: password);
                     if(newUser!=null)
                     {
                       print('Created New User');

                     }

                     



                    }
                    catch(e)
                    {

                      print(e);

                    }



                    
                    
                     print(email);
                     print(password);
                   },
                   color: Colors.green[100],
                   child: Text('Submit'),
                   )



                ],
                
                
                ),
            ),
          )
            
            )

        
      
  
        
        ),
    );
    
  }
}
