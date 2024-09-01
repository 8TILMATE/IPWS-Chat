import 'package:flutter/material.dart';
class ChatBubble extends StatelessWidget {
  final String Message;
  final bool sender;
  const ChatBubble({
    super.key,
    required this.Message,
    required this.sender,
    });

  @override
  Widget build(BuildContext context) {
    if(Message.contains("ipws-chatting.appspot.com")){
    return  Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: sender? Colors.blue:Colors.green,
      ),
      child:  Image.network(Message),
      );
  }
  else{
      return  Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: sender? Colors.blue:Colors.green,
      ),
      child: Text(
        Message,
        style: const TextStyle(fontSize: 16,color: Colors.white),
      )
    );
  }
  }
}