
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:mysocialapp/AppScreens/Profile.dart';
import 'package:mysocialapp/models/MyUsers.dart';
import 'package:provider/provider.dart';

import 'ChatPage.dart';


class Start extends StatefulWidget {
  Start({Key key}) : super(key: key);

  @override

  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  int selectedIndex = 0;

  PageController _pageController = PageController();
 


void _onPageChanged(int index) {
  setState(() {
    selectedIndex = index;
  });
}


  @override
  Widget build(BuildContext context) {
      final user = Provider.of<MyUser>(context);
      
          List<Widget> _screens = [ ChatPage(uid: user.uid,), Decide(userId: user.uid,)];
         
          return SafeArea(
              child: Scaffold(
              
                backgroundColor: Colors.grey[900],

                
         

          body: PageView(
            
              controller: _pageController,
              children: _screens,
              onPageChanged: _onPageChanged,
          ),
          
          bottomNavigationBar: FFNavigationBar(
            
            theme: FFNavigationBarTheme(
              barBackgroundColor: Colors.grey[350],
              selectedItemBorderColor: Colors.transparent,
              selectedItemIconColor: Colors.white,
              selectedItemLabelColor: Colors.grey[900],
              showSelectedItemShadow: false,
              unselectedItemIconColor: Colors.grey[900],
              barHeight: 50,
            ),
            selectedIndex: selectedIndex,
            onSelectTab: (index) {
              setState(() {
                selectedIndex = index;
                _pageController.jumpToPage(selectedIndex);
              }
              );
            },
            items: [
              FFNavigationBarItem(
                iconData: Icons.chat,
                label: 'Chat',
                selectedBackgroundColor: Colors.grey[900],
              ),
              FFNavigationBarItem(
                
                iconData: Icons.account_circle,
                label: 'Profile',
                selectedBackgroundColor: Colors.grey[900],
              ),
              
            ],
          
          ),
              )
              
        
      );
        
  }
}