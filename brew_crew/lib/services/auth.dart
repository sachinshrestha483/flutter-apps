import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  final FirebaseAuth _auth=FirebaseAuth.instance;

//Create user object on firebase user

User _userFromFirebaseUser(FirebaseUser user)
{
  return user!=null?User(uid: user.uid):null;
}

Stream<User>get user
{
  return _auth.onAuthStateChanged
  .map(_userFromFirebaseUser);
}

//siginin anon

Future signInAnon() async{
  try{
   AuthResult result= await _auth.signInAnonymously();
   FirebaseUser user=result.user;
   return _userFromFirebaseUser(user);

  }
  catch(e)
  {
    print(e.toString());
    return null;

  }
 
}



//siginin email and password



Future signInWithEmailAndPAssword(String email,String password)async{

try{

  AuthResult result=await _auth.signInWithEmailAndPassword(email: email, password: password);
  FirebaseUser user=result.user;
  return _userFromFirebaseUser(user);



}
catch(e)
{
  print(e.toString());
  return null;

}

}





// register with email and password

Future registerWithEmailAndPAssword(String email,String password)async{

try{

  AuthResult result=await _auth.createUserWithEmailAndPassword(email: email, password: password);
  FirebaseUser user=result.user;


//create a new document for the user with uid

await DatabaseService(uid: user.uid).updateUserData('0', 'new crew member', 100);



  return _userFromFirebaseUser(user);



}
catch(e)
{
  print(e.toString());
  return null;

}

}


//sign out

Future signOut() async{

try{
  return await _auth.signOut();
}
catch(e){
  print(e.toString());
  return null;

}

}



}