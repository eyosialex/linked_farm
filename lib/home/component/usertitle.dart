import 'dart:math';

import 'package:flutter/material.dart';

class Usertitle extends StatelessWidget {

  final String text;
  final void Function()? onTap;
  const Usertitle({super.key   ,required this.text,required this.onTap});



  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap,
    child: Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.blue),
      margin: EdgeInsets.symmetric(horizontal: 25,vertical: 20),
      padding: EdgeInsets.all(20),
child: Row(
  children: [
Icon(Icons.person),SizedBox(width: 30,),
Text(text,style: TextStyle(color: Colors.black),)

  ],
),


    ),
    
    
    );
  }
}