import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:satelite_chatting_app/models/message.dart';

class ChatService extends ChangeNotifier{
  // get instance of auth and frst
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final storageRef = FirebaseStorage.instance.ref();


  //SEND MESSAGE
  Future<void> sendMessage(String receiverId,String message,String currentUsername) async {

    final String currentUserId = _firebaseAuth.currentUser!.uid;
    //final String currentUsername = _firebaseAuth.currentUser!.displayName.toString();
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderID: currentUserId, 
      senderEmail: currentUserEmail,
      senderUsername: currentUsername,
      receiverId: receiverId, 
      message: message, 
      timestamp: timestamp, 
      seen: false
    );
    List<String> ids = [currentUserId,receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");
    await _firestore.collection('chat_rooms').doc(chatRoomId).collection('messages').add(newMessage.toMap());
  }

  //GET MESSAGES
  Stream<QuerySnapshot> getMessages(String userId,String otherUserId){
    List<String> ids = [userId,otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firestore.collection('chat_rooms').doc(chatRoomId).collection('messages').orderBy('timestamp',descending: false).snapshots();
  }
  //UPLOAD PICTURES TO FIREBASE STORAGE
  Future<String> uploadImage(File? image,String chat_rooms)async{
    Random random = Random();
    
    final reference = _storage.ref().child("chatrooms").child(chat_rooms).child(random.nextInt(4294967296).toString());
    try
    {
      await reference.putFile(image as File);
      return reference.getDownloadURL();
    }
    on FirebaseException catch(e){
      print(e.message);
      uploadImage(image, chat_rooms);
     return reference.getDownloadURL();
    }
  }

}