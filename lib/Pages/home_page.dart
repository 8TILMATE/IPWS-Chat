import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satelite_chatting_app/models/bottom_bar.dart';
import 'package:satelite_chatting_app/Pages/chat_page.dart';
import 'package:satelite_chatting_app/components/custom_list.dart';
import 'package:satelite_chatting_app/services/auth/auth_service.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
} 
class _HomePageState extends State<HomePage>{
  late String UserId;
  late String username;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void signOut(){
    final authService = Provider.of<AuthService>(context,listen: false);
    authService.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomBar(),
      appBar: AppBar(
        title: Center(
          child: Row(
            children: [
              SizedBox(width: 5),
              Icon(Icons.account_circle_rounded,color: Colors.grey,),
              SizedBox(width: 95),
              Text("IPWS-Chat",style: TextStyle(color: Colors.grey),),
              SizedBox(width: 96),
              IconButton(onPressed: signOut, icon: const Icon(Icons.logout),color: Colors.grey,),
            ],
          ),
        ),
        backgroundColor: Colors.black87,
        actions: [
        ],
        toolbarHeight: 100,
        
        ),
        body: _buildUserList(),
        
    );
  }
  Widget _buildUserList(){
     return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder:(context, snapshot){
          if(snapshot.hasError){
            return const Text('error');
          }
          if(snapshot.connectionState== ConnectionState.waiting){
            return const Text("Loading..");
          }
          for (var element in snapshot.data!.docs) {
            getCurrentUserusername(element);
          }
          return ListView(
            children:
            snapshot.data!.docs
              .map<Widget>((doc)=> _buildUserListItem(doc))
              .toList(),
            
          );
        },
      );
  }
  void getCurrentUserusername(DocumentSnapshot document){
    Map<String,dynamic> data = document.data()! as Map<String,dynamic>;
    if(_auth.currentUser!.email==data['email']){
          username=data['username'];
          UserId=data["uid"];
    } 
  }
  Widget _buildUserListItem(DocumentSnapshot document){
    Map<String,dynamic> data = document.data()! as Map<String,dynamic>;
    List<String> ids = [data["uid"],UserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    if(_auth.currentUser!.email!=data['email']){
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 3),
        child: ListTile(
            tileColor: Colors.white,
            leading: Icon(Icons.contact_phone_outlined),
            title: Text(data['username']),
            //style: ListTileStyle.list,
            
            onTap: (){
              // go to chat
              Navigator.push(
                context,
                
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    receiverEmail: data['email'],
                    receiverUID: data['uid'],
                    senderUsername: username,
                    chatRoomId: chatRoomId,
                  ),
                  )
                );
            },
        ),
      );
    } else {

    return Container();
    }
  }
}