import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:satelite_chatting_app/components/chat_bubble.dart';
import 'package:satelite_chatting_app/components/my_text_field.dart';
import 'package:satelite_chatting_app/services/chat/chat_service.dart';
class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverUID;
  const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverUID
    });
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async{
    if(_messageController.text.isNotEmpty){
      await _chatService.sendMessage(widget.receiverUID, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.receiverEmail),
        ),
        body: Column(
          children: [
            //messages
            Expanded(
              child: _buildMessageList(),
            ),

            _buildMessageInput(),
            const SizedBox(height: 25,)
          ],
        )
    );
  }
  //build message list
  
  Widget _buildMessageList(){
    return StreamBuilder(stream: _chatService.getMessages(widget.receiverUID, _firebaseAuth.currentUser!.uid), builder: (context, snapshot){
      if(snapshot.hasError){
        return Text('Error '+snapshot.error.toString());
      }
      if(snapshot.connectionState == ConnectionState.waiting){
        return const Text('Loading...');
      }
      return ListView(
        children: snapshot.data!.docs.map((document)=>_buildMessageItem(document)).toList(),
      );
    });
  }

  //build message item

  Widget _buildMessageItem(DocumentSnapshot document){
    Map<String,dynamic> data = document.data() as Map<String,dynamic>;
    var alignment = (data['senderId']==_firebaseAuth.currentUser!.uid) ? Alignment.centerRight:Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:(data['senderId']==_firebaseAuth.currentUser!.uid) ? CrossAxisAlignment.end : CrossAxisAlignment.start ,
        children: [
          Text(data['senderEmail']),
          const SizedBox(height: 5),
          ChatBubble(Message:data['message'], sender: (data['senderId']==_firebaseAuth.currentUser!.uid)),
        ],
      ),
    );
  }

  //build message input

  Widget _buildMessageInput(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: 'Enter message...',
              obscureText: false,
            ),
          ),
      
          IconButton(
            onPressed: sendMessage,
            icon: Icon(
              Icons.airplanemode_active_rounded,
              size: 40,
              )
            )
        ],
      ),
    );
  }

}