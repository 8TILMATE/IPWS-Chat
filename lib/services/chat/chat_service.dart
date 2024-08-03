import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:satelite_chatting_app/models/message.dart';

class ChatService extends ChangeNotifier{
  // get instance of auth and frst
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //SEND MESSAGE
  Future<void> sendMessage(String receiverId,String message) async {

    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderID: currentUserId, 
      senderEmail: currentUserEmail,
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

}