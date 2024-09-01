import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:satelite_chatting_app/components/chat_bubble.dart';
import 'package:satelite_chatting_app/components/my_text_field.dart';
import 'package:satelite_chatting_app/services/chat/chat_service.dart';
import 'package:satelite_chatting_app/services/chat/gallery_selector.dart';


class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverUID;
  final String senderUsername;
  final String chatRoomId;
  final int constMaxSizeX=200;
  const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverUID,
    required this.senderUsername,
    required this.chatRoomId
    });
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final GallerySelector _gallerySelector = GallerySelector();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final     ScrollController _scrollController = ScrollController();
  late File image;
  late String previousSender="";bool addName=true;
  
  

  void sendMessage() async{
    if(_messageController.text.isNotEmpty){
      await _chatService.sendMessage(widget.receiverUID, _messageController.text,widget.senderUsername);
      _messageController.clear();
    }
    else{
      if(image.path.isNotEmpty){
       
        await _chatService.sendMessage(widget.receiverUID,  await _chatService.uploadImage(image,widget.chatRoomId), widget.senderUsername);
      }
    }
  }
  void scrollToBottom(){
    SchedulerBinding.instance?.addPostFrameCallback((_) {
                        if (_scrollController.hasClients){
                          _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn);
                        }
                        else{
                          print("error");
                        }
                    });
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
            const SizedBox(height: 25)
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
      scrollToBottom();
      return ListView(
        controller: _scrollController,
        children: snapshot.data!.docs.map((document)=>_buildMessagePictureItem(document)).toList(),
      );
    });
  }

  //build message item

  Widget _buildMessageItem(DocumentSnapshot document){
   
    Map<String,dynamic> data = document.data() as Map<String,dynamic>;
    if(previousSender!=data['senderUsername']){
        addName=true;
    }
    else{
      addName=false;
    }
    previousSender=data['senderUsername'].toString();
    var alignment = (data['senderId']==_firebaseAuth.currentUser!.uid) ? Alignment.centerRight:Alignment.centerLeft;
    if(addName){
    return Container(
      alignment: alignment,
      child: Padding(
        padding: EdgeInsets.fromLTRB((data['senderId']==_firebaseAuth.currentUser!.uid) ? 150: 8, 8, (data['senderId']==_firebaseAuth.currentUser!.uid) ? 8: 150, 8),
        child: Column(
          crossAxisAlignment:(data['senderId']==_firebaseAuth.currentUser!.uid) ? CrossAxisAlignment.end : CrossAxisAlignment.start ,
          children: [
            Text(data['senderUsername']),
            const SizedBox(height: 5),
            ChatBubble(Message:data['message'], sender: (data['senderId']==_firebaseAuth.currentUser!.uid)),
          ],
        ),
      ),
    );
    }
    else{
      return Container(
      alignment: alignment,
      child: Padding(
        padding:  EdgeInsets.fromLTRB((data['senderId']==_firebaseAuth.currentUser!.uid) ? 150: 8, 8, (data['senderId']==_firebaseAuth.currentUser!.uid) ? 8:150, 8),
        child: Column(
          crossAxisAlignment:(data['senderId']==_firebaseAuth.currentUser!.uid) ? CrossAxisAlignment.end : CrossAxisAlignment.start ,
          children: [
            const SizedBox(height: 5),
            ChatBubble(Message:data['message'], sender: (data['senderId']==_firebaseAuth.currentUser!.uid)),
          ],
        ),
      ),
    );
    }
  }
    Widget _buildMessagePictureItem(DocumentSnapshot document){
   
    Map<String,dynamic> data = document.data() as Map<String,dynamic>;
    if(previousSender!=data['senderUsername']){
        addName=true;
    }
    else{
      addName=false;
    }
    previousSender=data['senderUsername'].toString();
    var alignment = (data['senderId']==_firebaseAuth.currentUser!.uid) ? Alignment.centerRight:Alignment.centerLeft;
    if(addName){
    return Container(
      alignment: alignment,
      child: Padding(
        padding: EdgeInsets.fromLTRB((data['senderId']==_firebaseAuth.currentUser!.uid) ? 150: 8, 8, (data['senderId']==_firebaseAuth.currentUser!.uid) ? 8: 150, 8),
        child: Column(
          crossAxisAlignment:(data['senderId']==_firebaseAuth.currentUser!.uid) ? CrossAxisAlignment.end : CrossAxisAlignment.start ,
          children: [
            Text(data['senderUsername']),
            const SizedBox(height: 5),
            ChatBubble(Message:data['message'], sender: (data['senderId']==_firebaseAuth.currentUser!.uid)),
          ],
        ),
      ),
    );
    }
    else{
      return Container(
      alignment: alignment,
      child: Padding(
        padding:  EdgeInsets.fromLTRB((data['senderId']==_firebaseAuth.currentUser!.uid) ? 150: 8, 8, (data['senderId']==_firebaseAuth.currentUser!.uid) ? 8:150, 8),
        child: Column(
          crossAxisAlignment:(data['senderId']==_firebaseAuth.currentUser!.uid) ? CrossAxisAlignment.end : CrossAxisAlignment.start ,
          children: [
            const SizedBox(height: 5), //data["'message'"]
            ChatBubble(Message:data['message'], sender: (data['senderId']==_firebaseAuth.currentUser!.uid)),
          ],
        ),
      ),
    );
    }
  }

  //build message input

  Widget _buildMessageInput(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 0),
      child: Row(
        children: [
          IconButton(onPressed: pickImage, icon: Icon(Icons.image_rounded,size: 25)),
          const SizedBox(width: 10),
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: 'Enter message...',
              obscureText: false,
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: sendMessage,
            icon: Icon(
              Icons.send,
              size: 30,
              )
            )
        ],
      ),
    );
  }

  Future pickImage() async 
  {
    try 
    {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;
      final imageTemp = File(image.path);
      this.image = imageTemp;
      print(image.path);
    }
    
    on Exception catch(_){     
    }
  }

}