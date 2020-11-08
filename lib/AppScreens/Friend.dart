import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:mysocialapp/AppScreens/loading.dart';
import 'package:mysocialapp/models/MyUsers.dart';
import 'package:mysocialapp/services/database.dart';

class Friend extends StatefulWidget {
  const Friend({this.userId});

  final String userId;
  @override
  _FriendState createState() => _FriendState(this.userId);
}

class _FriendState extends State<Friend> with 
SingleTickerProviderStateMixin {
  final String profileId;
  _FriendState(this.profileId);


  
  
  bool private = false;
  @override


  @override
  Widget build(BuildContext context) {
    
    Size size = MediaQuery.of(context).size;
    
    return StreamBuilder<UserData>(
        stream: DatabaseServices(uid: profileId).userData,
        builder: (context, AsyncSnapshot<UserData> snapshot) {
        
        if(snapshot.hasData){
          UserData userData = snapshot.data;
          return SafeArea(
            child: Scaffold(
            
            appBar: GradientAppBar(
              gradient: LinearGradient(colors: [Colors.purple, Colors.red]),
              title: Text('Profile'),
              centerTitle: true,
              elevation: 0.0,
              
            ),
                    
                              
            
           body: Container(
             child: Stack(
               children: <Widget>[
                 Container(
                     height: size.height,
                     width: size.width,
                    color: Colors.white,
                    ),
                    Container(
                     height: size.height/3,
                     width: size.width,
                    color: Colors.grey,
                    ),
                    Positioned(
                      top: size.height/20,
                      left: size.height/30,
                        child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: size.height/10,
                          backgroundImage: AssetImage('assets/profileimg.png'),
                        ),
                      ),
                    ),

                    Positioned(
                       top: size.height/10,
                      right: size.height/30,

                     
                        child:  Container(
                            height: size.height/10,
                            
                            color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FittedBox(child: Text(userData.displayName, 
                              style: TextStyle(fontSize: 25, fontStyle: FontStyle.italic),)),
                            ),
                          ),

                        
                      ),
                    

                      Positioned(
                       top: size.height/3,
                      child: Container(
                     
                     width: size.width,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.account_circle),
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text('About:  ', style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.italic
                                ),),
                              ),
                            ),
                            Expanded(
                          child: Container(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(userData.bio, style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.italic
                                    ),
                                    ),
                          )
                                  ),
                            ),
                            
                          ],
                        ),
                        
                      ],
                    ),
                    ),
                      ),
               ],
             ),
           )
          
        ),
      );
        } else {
          return Loading();
        } }
    );
  }
}