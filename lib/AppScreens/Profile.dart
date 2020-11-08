
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:mysocialapp/AppScreens/Edit.dart';
import 'package:mysocialapp/AppScreens/Friend.dart';
import 'package:mysocialapp/AppScreens/loading.dart';
import 'package:mysocialapp/models/MyUsers.dart';
import 'package:mysocialapp/services/auth.dart';
import 'package:mysocialapp/services/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';


class Decide extends StatefulWidget {
  const Decide({this.userId});

  final String userId;
  @override
  _DecideState createState() => _DecideState(this.userId);
}

class _DecideState extends State<Decide> {
  final String profileId;
  _DecideState(this.profileId);

  @override
  Widget build(BuildContext context) {
     final user = Provider.of<MyUser>(context);
     bool result;
     if(user.uid == profileId) {setState(() {
       result = true;
     });} else {setState(() {
       result = false;
     });}
    return result ? Profile(userId: profileId) : Friend(userId: profileId);  }
}



class Profile extends StatefulWidget {
  const Profile({this.userId});

  final String userId;
  @override
  _ProfileState createState() => _ProfileState(this.userId);
}

class _ProfileState extends State<Profile> with 
SingleTickerProviderStateMixin {
  final String profileId;
  _ProfileState(this.profileId);


  
  final AuthServices _auth = AuthServices();
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
              actions: [
                IconButton(icon: Icon(Icons.logout),
                 onPressed: () async {
                                await _auth.logout();
                              },)
              ],
            ),
                    
                              
            
           body: Container(
             child: Column(
               children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: size.height/12,
                          backgroundImage: AssetImage('assets/profile.jpg'),
                        ),
                      ),
                    

                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: size.height/10,
                            width: size.width/3.2,
                            color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FittedBox(child: Text(userData.displayName, 
                              style: TextStyle(fontSize: 25, fontStyle: FontStyle.italic),)),
                            ),
                          ),
                          Container(
                              child: IconButton(
                                icon: Icon(Icons.edit), 
                                onPressed: () { 
                                  Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => Edit()));
                                 },
                                
                              ),
                            )
                        ],
                      ),
                      

                       Container(
                     
                     width: size.width,
                    color: Colors.transparent,
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





void openProfile(BuildContext context, String useid) {
  Navigator.of(context)
      .push(MaterialPageRoute<bool>(builder: (BuildContext context) {
    return Decide(userId: useid,);
  }));
}


