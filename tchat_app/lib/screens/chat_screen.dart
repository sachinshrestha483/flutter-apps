import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tchat_app/constant.dart';
import 'package:tchat_app/models/user.dart';
import 'package:tchat_app/services/auth.dart';
import 'package:tchat_app/services/database.dart';


final  _firestore=Firestore.instance;

User loggedInUser;

final AuthService _auth=AuthService();

class ChatScreen extends StatefulWidget {

  
  static String id='chatScreen';


  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {



final messageTextController=TextEditingController();



String message;

final DataBaseService _dbService=DataBaseService(); 




void getCurrentUser() async{
  try{
    final user=await _auth.getCurrentUser();
    if(user!=null)
    {
      loggedInUser=user;
    }
  }
  catch(e)
  {
    print(e);
  }
}

@override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCurrentUser();

    
    
  }


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async{

                await _auth.signOut();

                Navigator.pop(context);
                

              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            StreamBuilder<QuerySnapshot>(
              stream:_firestore.collection('messages').snapshots() ,
              builder: (context,snapshot){
                if(!snapshot.hasData)
                {
                  return Center(child: CircularProgressIndicator(backgroundColor: Colors.white,
                  ),
                  );
                }

                final messages=snapshot.data.documents.reversed;
                List<MessageBubble> messageWidgets=[];
                for(var message in  messages )
                {
                  final messageText=message.data['text'];
                  final messageSender=message.data['sender'];






                  


                  final messageWidget=MessageBubble(sender: messageSender,text: messageText,isMe: messageSender==loggedInUser.email,);

                     messageWidgets.add(messageWidget);


                }

                return Expanded(child: ListView(
                  reverse: true,
                  children:messageWidgets,padding: EdgeInsets.all(15),));
                 
              }
               ),

            



 


            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      style: TextStyle(color: Colors.black),
                      onChanged: (value) {
                    message=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: ()async {
                      messageTextController.clear();

                      var user=await _auth.getCurrentUser();

                      await _dbService.addMessages(message, user.email);


                       _dbService.messageStream();






                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}





class MessageBubble extends StatelessWidget {
  
  MessageBubble({this.sender,this.text,this.isMe});
  final String sender;
  final String text;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
       padding:  EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: <Widget>[
          Text('$sender',style: TextStyle(color: Colors.black54,fontSize: 10),),
          Material(
            borderRadius:isMe? BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ):BorderRadius.only(
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            elevation: 5.0,
            
            color: isMe?Colors.lightBlueAccent:Colors.brown,
                child:Padding(
                  padding:  EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                  child: Text('$text',style: TextStyle(fontSize: 15 ,color: Colors.white),),
                )
          ),
        ],
      ),
    );
  }
}