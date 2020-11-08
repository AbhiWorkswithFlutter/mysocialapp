import 'package:flutter/material.dart';
import 'package:mysocialapp/AppScreens/ChatScreen.dart';
import 'package:mysocialapp/AppScreens/Search.dart';
import 'package:mysocialapp/Constants/Constants.dart';
import 'package:mysocialapp/models/MyUsers.dart';
import 'package:mysocialapp/services/database.dart';
import 'package:provider/provider.dart';

class ContactList extends StatefulWidget {
  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    return StreamBuilder<List<Userprofile>>(
        stream: DatabaseServices(uid: user.uid).contactsnap,
        builder: (context, AsyncSnapshot<List<Userprofile>> snapshot) {
          if (snapshot.hasData) {
            DatabaseServices databaseMethods = new DatabaseServices();
            getChatRoomId(String a, String b) {
              if (a.substring(0, 1).codeUnitAt(0) >
                  b.substring(0, 1).codeUnitAt(0)) {
                return "$b\_$a";
              } else {
                return "$a\_$b";
              }
            }

            sendMessage(String userName, String id) {
              List<String> users = [Constants.myuid, id];

              String chatRoomId = getChatRoomId(Constants.myuid, id);

              Map<String, dynamic> chatRoom = {
                "users": users,
                "chatRoomId": chatRoomId,
              };

              databaseMethods.addChat(chatRoom, chatRoomId, Constants.myuid);
              databaseMethods.addChat(chatRoom, chatRoomId, id);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Chat(
                            chatRoomId: chatRoomId,
                            username: userName,
                            uid: id,
                          )));
            }

            final a = snapshot.data;

            return Scaffold(
              body: ListView.builder(
                itemBuilder: (context, index) => ListTile(
                  onTap: () {
                    sendMessage(a[index].displayName, a[index].id);
                  },
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/profileimg.png'),
                  ),
                  title: Text(a[index].displayName),
                ),
                itemCount: a.length,
              ),
              floatingActionButton: FloatingActionButton.extended(
                backgroundColor: Colors.purpleAccent[700],
                  onPressed: () {
                    showSearch(context: context, delegate: Search());
                  },
                  icon: Icon(Icons.search),
                  label: Text('Search')),
            );
          } else {
            return Container();
          }
        });
  }
}

Widget follow(String profileId) {
  return StreamBuilder<UserData>(
      stream: DatabaseServices(uid: profileId).userData,
      builder: (context, AsyncSnapshot<UserData> snapshot) {
        if (snapshot.hasData) {
          DatabaseServices databaseMethods = new DatabaseServices();
          getChatRoomId(String a, String b) {
            if (a.substring(0, 1).codeUnitAt(0) >
                b.substring(0, 1).codeUnitAt(0)) {
              return "$b\_$a";
            } else {
              return "$a\_$b";
            }
          }

          sendMessage(String userName, String id) {
            List<String> users = [Constants.myuid, id];

            String chatRoomId = getChatRoomId(Constants.myuid, id);

            Map<String, dynamic> chatRoom = {
              "users": users,
              "chatRoomId": chatRoomId,
            };

            databaseMethods.addChat(chatRoom, chatRoomId, Constants.myuid);
            databaseMethods.addChat(chatRoom, chatRoomId, id);

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Chat(
                          chatRoomId: chatRoomId,
                          username: userName,
                          uid: id,
                        )));
          }

          UserData userData = snapshot.data;
          return ListTile(
            onTap: () {
              sendMessage(userData.displayName, userData.uid);
            },
            leading: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/profileimg.png'),
            ),
            title: Text(userData.displayName),
          );
        } else {
          return Container();
        }
      });
}
