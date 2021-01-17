import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

 

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
    final _formKey = GlobalKey<FormState>();

var currentLocation;
bool showpos=false;

  

@override
  void initState() {

      

    // TODO: implement initStat
    super.initState();

      GetLocation();

  }


void GetLocation() async 
{
  Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  setState(() {
     showpos=true;
  currentLocation=position;
 
    
  });
//   currentLocation=position;
  print(position.latitude);
  print(position.longitude);

}


  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(home: 
   Scaffold(
      appBar: AppBar(title: Text('Add Locat')),
      body:SafeArea(
        child: Form(
      key: _formKey,
      child: Padding(
        
        padding: const EdgeInsets.all(20.0),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[


TextFormField(
             decoration: InputDecoration(
    border:  OutlineInputBorder(),
    hintText: 'Enter a search term'
  ),
  // The validator receives the text that the user has entered.
  validator: (value) {
    if (value.isEmpty) {
        return 'Please enter some text';
    }
    return null;
  },
 
),

SizedBox(height: 12,),

TextFormField(
   decoration: InputDecoration(
    border: OutlineInputBorder(),
    hintText: 'Enter  Location Description'
  ),
  // The validator receives the text that the user has entered.
  validator: (value) {
    if (value.isEmpty) {
        return 'Please enter some text';
    }
    return null;
  },
),



SizedBox(height: 12,),

TextFormField(
style: TextStyle(color: Colors.grey),

  enabled: false,
  initialValue: '${showpos?currentLocation.latitude:'loading'}',
   decoration: InputDecoration(
    border: OutlineInputBorder(),
  ),
  // The validator receives the text that the user has entered.
  validator: (value) {
    if (value.isEmpty) {
        return 'Please enter some text';
    }
    return null;
  },
),




SizedBox(height: 12,),


TextFormField(
    enabled: false,
    initialValue:'${showpos?currentLocation.longitude:'loading'}',
   
style: TextStyle(color: Colors.grey),
  //controller: controller,
   decoration: InputDecoration(
    
    border: OutlineInputBorder(),
  ),
  // The validator receives the text that the user has entered.
  validator: (value) {
    if (value.isEmpty) {
        return 'Please enter some text';
    }
    return null;
  },
),



RaisedButton(
  onPressed: () {
    // Validate returns true if the form is valid, otherwise false.
    if (_formKey.currentState.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.

      Scaffold
          .of(context)
          .showSnackBar(SnackBar(content: Text('Processing Data')));
    }
  },
  child: Text('Submit'),
),

          ]
     ),
      )
    )
      ) ,
    ) 
    
    
    );
    
    
    
    
  
    
  }
}