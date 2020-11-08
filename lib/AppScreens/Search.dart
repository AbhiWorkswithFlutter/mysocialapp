
import 'package:flutter/material.dart';
import 'package:mysocialapp/AppScreens/Profile.dart';
import 'package:mysocialapp/models/MyUsers.dart';
import 'package:mysocialapp/services/database.dart';
import 'package:provider/provider.dart';

class Search extends SearchDelegate<String>{

  

  final recent = [];
  @override
  List<Widget> buildActions(BuildContext context) {
    
    return [IconButton(icon: Icon(Icons.clear), onPressed: () { query="";})];
  }

  @override
  Widget buildLeading(BuildContext context) {
   
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ), 
      onPressed: () {
        close(context, null);
      },
      );
  }

  @override
  Widget buildResults(BuildContext context) {
   
    return Center(
      child: Container(
       child: buildSuggestions(context),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    return StreamBuilder<List<Userprofile>>(
      stream: DatabaseServices().profilesnap,
      builder: (context, AsyncSnapshot<List<Userprofile>> snapshot) {
        
        if(!snapshot.hasData){
          return Container();
        } else {

            final searchresults = query.isEmpty ? recent 
             : snapshot.data.where((p) => p.displayName.toLowerCase().contains(query)).toList() ;
            

              
      return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {openProfile(context, searchresults[index].id);
          
        },

        leading: CircleAvatar(
          radius: 20,
          // backgroundImage: NetworkImage(searchresults[index].photourl),
        ),
        title: Text(searchresults[index].displayName),

        trailing: FlatButton(
          color: Colors.teal,
          onPressed: () { 
                         DatabaseServices(uid: user.uid).
              updateUserContactList(searchresults[index].displayName, searchresults[index].id);


             
           },
          child: Text('Add'),),
     
      ),
      itemCount: searchresults.length,
      );
  }

                 
  

        }
    
      
      

    );
    

}

}