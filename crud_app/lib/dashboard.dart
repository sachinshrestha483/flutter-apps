import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'curd.dart';
import 'package:crud_app/Models/VehicleModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';


var sampleImage;



class Dashboard extends StatefulWidget {

  static String id='Dashboard';
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {


//image picker

Future getImage() async 
  {
    var tempimage=await ImagePicker.pickImage(source: 
    ImageSource.gallery);
    setState(() {
      sampleImage=tempimage;
    });
  }
  



Stream<QuerySnapshot> resultDocuments;
Vehicle v=Vehicle();
crudMedthods crud=crudMedthods();
  String uid;


@override
  void initState() {
    // TODO: implement initState
    super.initState();
     crud.getData().then((result){
       setState(() {
         resultDocuments=result;
       });
     });
  } 
  @override
  
  Widget build(BuildContext context) {



//update Dialog Box
Future<void> _UpdateDialogBox(String userId) async {
  v.modelname='';
  v.color='';
  
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Update The Vehicle '),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[



                TextField(
              onChanged: (val){v.modelname=val;},
           decoration: InputDecoration(
             border: InputBorder.none,
              hintText: 'Enter Car Name'
            ),
          ),

            TextField(
              onChanged: (val){v.color=val;},
           decoration: InputDecoration(
             border: InputBorder.none,
              hintText: 'Enter Car Color'
            ),
          ),


            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Regret'),
            onPressed: ()   async{
              crud.updateData(userId,v);

              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}




//dialog box 1
Future<void> _neverSatisfied() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Rewind and remember'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
             
              TextField(
              onChanged: (val){v.modelname=val;},
           decoration: InputDecoration(
             border: InputBorder.none,
              hintText: 'Enter Car Name'
            ),
          ),
        
         TextField(
              onChanged: (val){v.color=val;},
           decoration: InputDecoration(
             border: InputBorder.none,
              hintText: 'Enter Car Colour'
            ),
            ),

            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Save Data'),
            onPressed: () async {

             await crud.addData(v);


              Navigator.of(context).pop();
              //_neverSatisfied1();
            },
          ),
        ],
      );
    },
  );
}







    return Scaffold(

      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          
          
          children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Material(child:
             Center(child: Container(
               margin: EdgeInsets.all(12),
               
               child: Text('Dashboard Page',style: TextStyle(fontSize: 23)
               ,
               
               ),
             ),
             ),
             color: Colors.blue,
             ),
          ),
          
          StreamBuilder<QuerySnapshot>(
            stream: resultDocuments,
            builder: (context,snapshot){
              if(!snapshot.hasData)
              {
                return Center(
                  child: CircularProgressIndicator(backgroundColor: Colors.black,),
                );
              }
              final messages=snapshot.data.documents;

              List<Container> containers=[];
              for(var message in messages)
              {
                final carModel=message.data['model'];
                final carColor=message.data['color'];

               
                


                  var con=Container(
                    margin: EdgeInsets.all(15),
                    child: Column(children: <Widget>[

                    Text('$carModel',style: TextStyle(fontSize: 30),),
                    Text('$carColor',style: TextStyle(fontSize: 20)),

                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          child:
                          Icon(Icons.delete),


                        onTap: (){
                         crud.deleData(message.documentID);
                         print(message.documentID);
                   }
                        ),

                        SizedBox(width: 30,),
                        GestureDetector(
                          child:
                          Icon(Icons.update),


                        onTap: (){
//                         crud.deleData(message.documentID);
                         print(message.documentID);
                         _UpdateDialogBox(message.documentID);

                   }
                        ),
                      ],
                    )
                     







                ],
                ),
                
                
                );





                containers.add(con);






              }

                return
               
                Expanded(
                                  child: SizedBox(
                    
                                    child: ListView(
                      padding:EdgeInsets.symmetric(horizontal:10,vertical:20),
                      children:containers,


                    ),
                  ),
                );




              
            }
            
            
            
            
            
            
            )
        
        ],),
      
      ),
      
      ),
        floatingActionButton:FloatingActionButton(onPressed: (){
          _neverSatisfied();
        },
          child: Icon(Icons.add),
      backgroundColor: Colors.green,
      )


    );
  }
}
