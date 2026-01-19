import 'package:flutter/material.dart';
class Textfieldforlog extends StatefulWidget {
  final String hinttext;
  final bool obscureText;
  const Textfieldforlog({super.key,required this.obscureText,required this.hinttext
  });
  @override
  State<Textfieldforlog> createState() => _TextfieldforlogState();
}

class _TextfieldforlogState extends State<Textfieldforlog> {
final TextEditingController email=TextEditingController();
void togletextfield(){
setState(() {
widget.obscureText!=widget.obscureText;
});


}
  @override
  Widget build(BuildContext context) {
    return TextField(
controller: email,
obscureText:widget.obscureText ,
decoration: InputDecoration(
              
             
  suffix: IconButton(onPressed: togletextfield, icon: widget.obscureText==true?Icon(Icons.remove_red_eye_rounded):Icon(Icons.remove_red_eye   )
,iconSize:20,color: const Color.fromRGBO(0, 0, 0, 1),
),
hintText: widget.hinttext,
hintStyle: TextStyle(color: Colors.blueAccent,fontWeight:FontWeight.bold )
,
border:OutlineInputBorder() ),

    );
  }
}