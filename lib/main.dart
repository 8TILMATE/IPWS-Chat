import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satelite_chatting_app/Pages/login_page.dart';
import 'package:satelite_chatting_app/Pages/register_page.dart';
import 'package:satelite_chatting_app/services/auth/auth_gate.dart';
import 'package:satelite_chatting_app/services/auth/auth_service.dart';
import 'package:satelite_chatting_app/services/auth/login_or_register.dart';
import 'package:firebase_core/firebase_core.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseOptions(apiKey: "AIzaSyBkMKobKbOJQlvfdCUPAaPJ9bg2W5wxYzo", appId: "1:564518371769:android:b4a8f4d8518994b6c17668", messagingSenderId: "564518371769", projectId: "ipws-chatting"));
  runApp(
      ChangeNotifierProvider(create: (context)=>AuthService(),
        child: const MyApp(),
       )
  );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate()
    );
  }
}

