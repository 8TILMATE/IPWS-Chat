import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier{

  late String token;
  

  //instance of auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //instance of firestone
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;


  Future<UserCredential> signInWithEmailandPassword(String email, String password,String token) async{
    try{
      //sign in
      UserCredential userCredential = 
        await _firebaseAuth.signInWithEmailAndPassword(
          email: email, 
          password: password
        );
        _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid':userCredential.user!.uid,
        'email':email,
        'nToken': token,
      }, SetOptions(merge: true));
      return userCredential;
    }
    on FirebaseAuthException catch (e){
      throw Exception(e.code);
    }
  }

  //create a new user
  Future<UserCredential> signUpWithEmailandPassword(String email,password,token,username) async{
    try{
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      //create user doc
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid':userCredential.user!.uid,
        'email':email,
        'nToken': token,
        'username': username
      });

      return userCredential;
    }
    on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }


  //ResetPassword
  Future<void>ForgotPassword(String email) async {
    return await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
  //sign user out
  Future<void> signOut() async{
    return await FirebaseAuth.instance.signOut();
  }
}