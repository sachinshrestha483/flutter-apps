
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
  var sampleImage;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  

  Future getImage() async 
  {
    var tempimage=await ImagePicker.pickImage(source: 
    ImageSource.gallery);
    setState(() {
      sampleImage=tempimage;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          home: Scaffold(
        appBar: AppBar(title: Text('Image Uploader'),
        centerTitle: true,
        ),
        body: Center(
          child: sampleImage==null?Text('Select an image '):enableUpload(),
        ),
        floatingActionButton: FloatingActionButton(
          
          onPressed: getImage,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}


Widget enableUpload()
{
 return Container(child: Column(
children: <Widget>[
  Image.file(sampleImage,height:300,width:300),
  RaisedButton(child: Text('Upload'),
  textColor: Colors.white,
  color: Colors.blue,
  onPressed: ()async{

    final StorageReference firebaseStorageRef=
      FirebaseStorage.instance.ref().child('myimage.jpg');

       var url= await firebaseStorageRef.getDownloadURL();

       print(url);



      final StorageUploadTask task=firebaseStorageRef.putFile(sampleImage);



  },
  )

],
 ),);
}