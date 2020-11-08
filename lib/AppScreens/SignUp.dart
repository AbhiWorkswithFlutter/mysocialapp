
import 'package:flutter/material.dart';
import 'package:mysocialapp/services/auth.dart';
import 'package:mysocialapp/AppScreens/loading.dart';
 


class SignUp extends StatefulWidget {

   final Function toggleView;
  SignUp({ this.toggleView });
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
 
  final AuthServices _auth = AuthServices();
  final _formKey = GlobalKey<FormState>();
  
  String displayName = '';
  String email = '';
  String password = '';
  String error = '';
  String photourl= '';
  bool loading = false;
  
  
  
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            color: Colors.black,
            height: size.height/2.5,
            child: Center(child: Text('#LOGO', style: TextStyle(color: Colors.white, fontSize: 30),)),
            
          ),
          SizedBox(
            height: 20,
          ),




          Form(
            key: _formKey,
              child: Column(
              children: [

                Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  IconButton(icon: Icon(Icons.person), onPressed: null),
                  Expanded(
                      child: Container(
                          margin: EdgeInsets.only(right: 20, left: 10),
                          child: TextFormField(
                            validator: (val) => val.isEmpty ? 'Enter a Username' : null,
                            onChanged: (val) {
                              setState(() => displayName = val);
                            },
                            decoration: InputDecoration(hintText: 'Username'),
                          )))
                ],
              ),
            ),


                Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  IconButton(icon: Icon(Icons.mail), onPressed: null),
                  Expanded(
                      child: Container(
                          margin: EdgeInsets.only(right: 20, left: 10),
                          child: TextFormField(
                            validator: (val) => val.isEmpty ? 'Enter valid Email' : null,
                            onChanged: (val) {
                              setState(() => email = val);
                            },
                            decoration: InputDecoration(hintText: 'Email'),
                          )))
                ],
              ),
            ),



            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  IconButton(icon: Icon(Icons.lock), onPressed: null),
                  Expanded(
                      child: Container(
                          margin: EdgeInsets.only(right: 20, left: 10),
                          child: TextFormField(
                            obscureText: true,
                            validator: (val) => val.length < 6 ? 'Enter a Password of at least 6 chars' : null,
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                            decoration: InputDecoration(hintText: 'Password'),
                          ))),
                ],
              ),
            ),



            SizedBox(
              height: 10
            ),



            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  height: 50,
                  
                  child: RaisedButton(
                   onPressed: () async {
                  if(_formKey.currentState.validate()){
                    setState(() => loading = true);
                    dynamic result = await _auth.
                    registerWithEmailAndPassword(email, password, displayName);
                    if(result == null) {
                      setState(() {
                        loading = false;
                        error = 'Please supply a valid email';
                      });
                    }
                  }
                },
                    color: Colors.teal,
                    child: Text(
                      'SIGN UP',
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
            
            


            InkWell(
              onTap: () => widget.toggleView(),
                        child: Center(
                child: RichText(
                  text: TextSpan(
                      text: 'Already have an Account?\t\t\t',
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'Sign In',
                          style: TextStyle(
                              color: Colors.teal, fontWeight: FontWeight.bold),
                        )
                      ]),
                ),
              ),
            ),

            SizedBox(
              height: 30
            ),
            
             ],
            ),
          ),
        ],
      ),
    );
  }
}



