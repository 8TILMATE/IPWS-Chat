import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
 
class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  @override
  Widget build(BuildContext context) {
    return  Row(
        children: [
          SizedBox(width: 10),
          IconButton(icon: Icon(Icons.message_rounded),iconSize: 35, onPressed: () {  },),
          SizedBox(width: 60),
          IconButton(onPressed: (){}, icon: Icon(Icons.call_rounded),iconSize: 35),
          SizedBox(width: 60),
          IconButton(onPressed: (){}, icon: Icon(Icons.settings),iconSize: 35),
          SizedBox(width: 60),
          IconButton(onPressed: (){}, icon: Icon(Icons.account_circle_rounded),iconSize: 35)
        ],
      );
  }

}