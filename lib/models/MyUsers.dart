class MyUser {

  final String uid;
  
  MyUser({ this.uid });

}




class UserData {

  String uid;
  String displayName;
  List contactList;
  String bio;
  UserData({  this.uid, 
   this.displayName, this.contactList, this.bio});


}

class Userprofile {

  final String displayName;
  
  final String id;

  final String chatId;

  Userprofile({ this.displayName, this.id , this.chatId});

}

