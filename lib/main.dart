import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mysocialapp/AppScreens/SignUp.dart';
import 'package:mysocialapp/services/auth.dart';
import 'package:provider/provider.dart';
import 'AppScreens/LogIn.dart';
import 'AppScreens/Start.dart';
import 'models/MyUsers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser>.value(
          value: AuthServices().user,
     child: MaterialApp(
            
            home: Check()
      
    )
    );
  }
}

//Checks whether the user is LogIned or not.
class Check extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<MyUser>(context);
    
    
    if (user == null){
      return Register();
    } else {
      return Start();
    }
    
  }
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  bool showSignIn = true;
  void toggleView(){
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return LogIn(toggleView:  toggleView);
    } else {
      return SignUp(toggleView:  toggleView);
    }
  }
}