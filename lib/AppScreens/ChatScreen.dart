
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:mysocialapp/Constants/Constants.dart';
import 'package:mysocialapp/services/database.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';



class Chat extends StatefulWidget {
  final String chatRoomId;
  final String username;
  final String uid;
  Chat({this.chatRoomId, this.username, this.uid});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

//to check if the message is read or not
  Future msgread(String myuid, String otheruid, String chatid) async {

   final QuerySnapshot chatListResult = await FirebaseFirestore.instance.collection('users').doc(myuid).collection('chatRoom').
             doc(chatid).collection('chats').where('sendBy' ,isEqualTo: otheruid ).get();
  
  final QuerySnapshot otherchatListResult = await FirebaseFirestore.instance.collection('users').doc(otheruid).collection('chatRoom').
             doc(chatid).collection('chats').where('sendBy' ,isEqualTo: otheruid ).get();


   final List<DocumentSnapshot> chatListDocuments = chatListResult.docs;
   final List<DocumentSnapshot> otherchatListDocuments = otherchatListResult.docs;


   for(var data in chatListDocuments) {
        await FirebaseFirestore.instance.collection('users').doc(myuid).collection('chatRoom').
             doc(chatid).collection('chats').doc(data.id).update(
               {'isread' : true}
             );
        }

        for(var data in otherchatListDocuments) {
        await FirebaseFirestore.instance.collection('users').doc(otheruid).collection('chatRoom').
             doc(chatid).collection('chats').doc(data.id).update(
               {'isread' : true}
             );
        }
        print("abhi");

  }

  

  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();
  ScrollController scrollController = ScrollController();
  Widget chatMessages(){
    return VisibilityDetector(
        key: Key("1"),
        onVisibilityChanged: ((visibility) {
          print('ChatList Visibility code is '+'${visibility.visibleFraction}');
          if (visibility.visibleFraction == 1.0) {
          msgread(Constants.myuid, widget.uid, widget.chatRoomId);
          }
        }),
        child:StreamBuilder(
     
      stream: chats,
      builder: (context, snapshot){
        
        return snapshot.hasData ? ListView.builder(
          reverse: true,
          controller: ScrollController(),
          shrinkWrap: true,
          itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
             
                return MessageTile(
                message: snapshot.data.docs[index].data()["message"],
                sendByMe: Constants.myuid == snapshot.data.docs[index].data()["sendBy"],
              
                );

              
             
            }) : Container();
      },
        )
    );
  }

  addMsg() {

    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myuid,
        "message": messageEditingController.text,
        "isread" : false,
        "receiver" : widget.uid,
        "type" : 'text',
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseServices().addMessage(widget.chatRoomId, chatMessageMap, Constants.myuid);
       DatabaseServices().addMessage(widget.chatRoomId, chatMessageMap, widget.uid);
      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  _messageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25.0,
            color: Colors.black,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: messageEditingController ,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {},
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Colors.black,
            onPressed: () {
              addMsg();
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    DatabaseServices().getChat(widget.chatRoomId, Constants.myuid).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return   SafeArea(
                child: Scaffold(
              appBar: GradientAppBar(
               gradient: LinearGradient(colors: [Colors.purple, Colors.red]),
               elevation: 0,
                title: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: CircleAvatar(
                  radius: 20,
                  
                  backgroundImage: AssetImage('assets/profileimg.png')
                ),
                    ),
                SizedBox(
                  width: 15,
                ),
                    Text(widget.username),
                  ],
                ),
                actions: [
                  IconButton(icon: Icon(Icons.more_vert, color: Colors.black,), onPressed: () {})
                ],
              ),
              body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Column(
                
                children: <Widget>[
                  Expanded(
                    child: Container(
                      
                      
                        child: chatMessages(),
                      
                    ),
                  ),
                  _messageComposer(),
                ],
              ),
            ),
            ),
          
            );
        } 
     
    
  }



class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendByMe});


  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sendByMe ? 0 : 24,
          right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(
            top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            BorderRadius.only(
        topLeft: Radius.circular(23),
          topRight: Radius.circular(23),
          bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe ? [
                const Color(0xff007EF4),
                const Color(0xff2A75BC)
              ]
                  : [
                const Color(0x1AFFFFFF),
                const Color(0x1AFFFFFF)
              ],
            )
        ),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'OverpassRegular',
            fontWeight: FontWeight.w300)),
      ),
    );
  }
}



