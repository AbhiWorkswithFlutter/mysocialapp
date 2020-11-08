import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:mysocialapp/AppScreens/ChatScreen.dart';
import 'package:mysocialapp/AppScreens/ContactList.dart';
import 'package:mysocialapp/Constants/Constants.dart';
import 'package:mysocialapp/models/MyUsers.dart';
import 'package:mysocialapp/services/database.dart';



class ChatPage extends StatefulWidget {
 final String uid;
  const ChatPage({this.uid});

  
  @override
  _ChatPageState createState() => _ChatPageState(this.uid);
}

class _ChatPageState extends State<ChatPage> {
  String uid;
  _ChatPageState(this.uid);
  Stream chatRooms;
  
   
  Widget chatsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomTile(
                    userName: snapshot.data.docs[index].data()['chatRoomId']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myuid, ""),
                    chatRoomId: snapshot.data.docs[index].data()["chatRoomId"],
                  );
                }
                )
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfoandgetChats();
    super.initState();
  }

  getUserInfoandgetChats() async {
    Constants.myuid = uid;
    DatabaseServices().getUserChat(Constants.myuid).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        
      });
    });
  }

  @override
  Widget build(BuildContext context) {


    return DefaultTabController(
          length: 2,
          child: SafeArea(
            child: Scaffold(
          appBar: GradientAppBar(
                  gradient: LinearGradient(colors: [Colors.purple, Colors.red]),
                  title: Text('Chats', style: TextStyle(fontSize: 20),),
                  
                  elevation: 0.0,
                  centerTitle: true,


                  bottom: TabBar(
              tabs: [
                Tab(child: FittedBox(child: Text('Messages', style: TextStyle(fontSize: 20),)),),
                Tab(child: FittedBox(child: Text('Contacts', style: TextStyle(fontSize: 20),)),),
              ],
            ),
                  
                ),
              body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {

              if(snapshot.hasData) {
                return Scaffold(
                
                body: TabBarView(
                    children: [
                      Container(
                      child: chatsList(),
                    ),
                     ContactList()
                    ],
                  ),
                );
              } else {
                return Container();
              }
              
            }
          ),
        ),
      ),
    );
  }
}

class ChatRoomTile extends StatefulWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomTile({this.userName,@required this.chatRoomId});

  @override
  _ChatRoomsTileState createState() => _ChatRoomsTileState();
}

class _ChatRoomsTileState extends State<ChatRoomTile> {

  deletechat(BuildContext context) {
    FirebaseFirestore.instance.collection('users')
                  .doc(Constants.myuid).collection('chatRoom')
                  .doc(widget.chatRoomId).collection('chats').get().then((snapshot) {
                            for (DocumentSnapshot doc in snapshot.docs) {
                              doc.reference.delete();
                            }
                          });
                  FirebaseFirestore.instance.collection('users')
                  .doc(Constants.myuid).collection('chatRoom')
                  .doc(widget.chatRoomId).delete();
                  Navigator.of(context).pop();
  }
  

  Future<void> _showChoiceDialog (BuildContext context) {
    return showDialog (context: context, builder: (BuildContext context) {
    return AlertDialog(
      
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget> [
            GestureDetector(
              child: Text(
                          'Delete Chat',
                         
                        ),

              onTap: () async {
                 await deletechat(context);
              },
            ),


            ],
        ),

      ),
    );
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
      stream: DatabaseServices(uid: widget.userName).userData,
      builder: (context, AsyncSnapshot<UserData> snapshot) {
        
        if(snapshot.hasData){
          UserData userData = snapshot.data;

        return Column(
          children: [
            ListTile(
               
                  onLongPress: () {
                    _showChoiceDialog(context);
                  },
                  onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Chat(
                      chatRoomId: widget.chatRoomId,
                      username: userData.displayName,
                      uid: widget.userName,
                    )
                  ));
                },
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/profileimg.png'),
                    backgroundColor: Colors.grey,
                  ),
                      title: Container(
                  color: Colors.transparent,
                 
                  child: 
                      Text(userData.displayName,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              
                              fontFamily: 'OverpassRegular',
                              fontWeight: FontWeight.w700))
                    
                ),
                
               
              ),
            
            Divider(
              thickness: 0.5,
            )
          ],
        );
      }  else {
        return Container();
      } }
    );
  }
}










