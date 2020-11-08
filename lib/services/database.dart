

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mysocialapp/models/MyUsers.dart';


class DatabaseServices {

  final String uid;
  DatabaseServices({this.uid});


  final CollectionReference userinformation = FirebaseFirestore.instance.collection('users');

  Future updateUserData(String email, String displayName,String mychatId, String bio) async {

    return await userinformation.doc(uid).set({

      'email': email,
      'displayName' : displayName,
      'mychatId' : mychatId,
      'bio' : bio,
      
    });
  }



  Future updateUserContactList(
  String displayName, String id) async {

    return await userinformation.doc(uid).collection('contactList').doc(id).set({
       'displayName' : displayName,
      'id' : id,

    });
  }


  


  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: snapshot.id ?? '',
      displayName: snapshot.data()['displayName'] ?? '',
      contactList: snapshot.data()['contactList'],
      bio: snapshot.data()['bio'],
     
    );
  }

   List<Userprofile> _userprofile(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
     
      return Userprofile(
        displayName: doc.data()['displayName'] ?? '',
        id : doc.id,
        chatId: doc.data()['mychatId'] ?? '',
      );
    }).toList();
  }

  // // get user doc stream
  Stream<UserData> get userData {
    return userinformation.doc(uid).snapshots()
    .map(_userDataFromSnapshot);
  }

     Stream<List<Userprofile>> get profilesnap {
    return userinformation.snapshots()
      .map(_userprofile);
  }


     Stream<List<Userprofile>> get contactsnap {
    return userinformation.doc(uid).collection('contactList').snapshots()
      .map(_userprofile);
  }

  Future addChat(chatRoom, chatRoomId, uid) async {
    FirebaseFirestore.instance.collection('users').doc(uid)
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  getChat(String chatRoomId, String uid) async{
    return FirebaseFirestore.instance.collection('users').doc(uid)
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time', descending: true)
        .snapshots();
  }



  // ignore: missing_return
  Future<void> addMessage(String chatRoomId, messageData, uid){

    FirebaseFirestore.instance.collection('users').doc(uid).collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageData).catchError((e){
          print(e.toString());
    });
  }

  getUserChat(String myName) async {

    return  FirebaseFirestore.instance.collection('users').doc(myName)
        .collection("chatRoom").snapshots();
  }


}
