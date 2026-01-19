
import 'package:echat/User%20Credential/firebaseauthservice.dart';
import 'package:echat/User%20Credential/log_in_or_register.dart';
import 'package:flutter/material.dart';

class Mydrawer extends StatefulWidget {
  const Mydrawer({super.key});

  @override
  State<Mydrawer> createState() => _MydrawerState();
}
class _MydrawerState extends State<Mydrawer> {
  final FirebaseAuthService fire=FirebaseAuthService();
  @override
  Widget build(BuildContext context) {
   return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
        DrawerHeader(child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(60)),
          child: Center(
            child: Text("Wellcome"),
          ),
        )),
      GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Row(   
              children: [
                Icon(Icons.home), SizedBox(width: 50,), Text('Home',style: TextStyle(color: Colors.black,fontSize: 20),),
                    ],
        ),
      ), SizedBox(height: 30,) ,
       Row(   
            children: [
              Icon(Icons.settings), SizedBox(width: 50,), Text('Setting',style: TextStyle(color: Colors.black,fontSize: 20),),
                  ],
      ),
   SizedBox(height: 30,),      
        GestureDetector(
  onTap: () async {
    await fire.signOut(); // properly sign out the user
    // after logout, navigate to login screen (or replace current route)
    Navigator.push(context, MaterialPageRoute(builder: (context)=>LogInOrRegister()));
  },
  child: Row(
    children: [
      Icon(Icons.logout),
      SizedBox(width: 50),
      Text(
        'LogOut',
        style: TextStyle(color: Colors.black, fontSize: 20),
      ),
        // IconButton(
        //     icon: const Icon(Icons.group_add),
        //     onPressed: _showCreateGroupDialog,
        //   )
    ],
  ),
),

        ])
    );
  }
}