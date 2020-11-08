import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysocialapp/models/MyUsers.dart';
import 'package:mysocialapp/services/database.dart';
import 'package:random_string/random_string.dart';

class AuthServices {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase user
  MyUser _userFromFirebaseUser(User user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<MyUser> get user {
    return _auth.authStateChanges()
      .map(_userFromFirebaseUser);
  }



  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    } 
  }


  //register with email
  Future registerWithEmailAndPassword(String email, String password, String displayName) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      String id = '#My' + randomAlphaNumeric(5);
      // create a new document for the user with the uid
      await DatabaseServices(uid: user.uid).updateUserData(email, displayName, id, 'Hii there!');
      
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    } 
  }

   
  
  //signout or logout

  Future logout() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}