
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:mysocialapp/models/MyUsers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Edit extends StatefulWidget {
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();



  String username = '';
  String email = '';
  String newbio = '';
  String error = '';
  String photourl= '';
  bool loading = false;

  void showSnackBar() {
    final snackBar = SnackBar(
      content: Text('Details sucessfully Updated!'),
      duration: Duration(seconds: 3),);
    _scaffoldkey.currentState.showSnackBar(snackBar);
  }

 


   @override
  Widget build(BuildContext context) {
    String _currentname;
    
    
    final user = Provider.of<MyUser>(context);
    Size size = MediaQuery.of(context).size;
  return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        
        if(snapshot.hasData){
          
          _currentname  = snapshot.data['displayName'];
          
          String  bio  = snapshot.data['bio'];
           
            
          return  SafeArea(
      child: Scaffold(
        key: _scaffoldkey,
        appBar: GradientAppBar(
          gradient: LinearGradient(colors: [Colors.purple, Colors.red]),
          elevation: 0.0,
          title: Text(
                      "Edit Profile",
                          ),

                 
        ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[

             
            Padding(
              padding: const EdgeInsets.all(20.0),

              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),

                      
                      Center(
                        child:  CircleAvatar(
                          radius: size.height/10,
                                      backgroundImage: AssetImage('assets/profile.jpg'),
                                        
                                      
                                    ),
                                 
                                ),
                      

                     

                       SizedBox(
                        height: 20,
                      ),



                      SizedBox(
                        height: 10,
                      ),

                      Form(
                            key: _formKey,
                              child: Column(
                              children: [

                               
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                child: Row(
                                  children: <Widget>[
                                    Text('Name: ', style: TextStyle(fontSize: 15),),
                                    Expanded(
                                        child: Container(
                                            margin: EdgeInsets.only(right: 20, left: 10),
                                            child: TextFormField(
                                              initialValue: _currentname,
                                              validator: (val) => val.isEmpty ? 'Enter a Username' : null,
                                              onChanged: (val) => setState(() => username = val),
                                              decoration: InputDecoration(hintText: 'Username'),
                                            ),
                                            
                                            )
                                            )
                                  ],
                                ),
                              ),
                            

                           
                               Row(
                                children: <Widget>[
                                  Text('About: ', style: TextStyle(fontSize: 15),),
                                  Expanded(
                                      child: Container(
                                          margin: EdgeInsets.only(right: 20, left: 10),
                                          child: TextFormField(
                                            initialValue: bio,
                                            validator: (val) => val.isEmpty ? 'Enter a Something About You!' : null,
                                            onChanged: (val) => setState(() => newbio = val),
                                            decoration: InputDecoration(hintText: 'About'),
                                          ),
                                          
                                          )
                                          )
                                ],
                              ),
                            
                              ],
                              ),

                      ),

                    ],
                ),
              ),
            ),

            SizedBox(
              height: 30,
            ),

            Padding(
                padding: const EdgeInsets.all(20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 40,
                    
                    child: FlatButton(
                     color: Colors.purpleAccent[200], 
                     onPressed: () async {
                       if(_formKey.currentState.validate()){

                          {
                                await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
                             {
                               'displayName' : username.isEmpty ? _currentname:  username,
                                'bio' : newbio.isEmpty ? bio : newbio
                             }
                           );
                                
                                showSnackBar();
                         }

                    

                        
                        
                       }

                       
                      },
                     
                      child: Text(
                        'Save Changes',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 15),
              ),   

              SizedBox(
                height: 10,
              ),


        ],

              ),
            ),
          );
       
      }
         else {
         
          return Container();
        }
       
      }
    );
  
      }
}
