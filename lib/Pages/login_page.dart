import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satelite_chatting_app/components/my_button.dart';
import 'package:satelite_chatting_app/components/my_text_field.dart';
import 'package:satelite_chatting_app/services/auth/auth_service.dart';
//import 'package:satelite_chatting_app/services/notifications/notifications.dart';

class LoginPage extends StatefulWidget {
  final void Function() onTap;
  const LoginPage({super.key,required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  //final noti = Notifications();

   
   void signIn ()async {
      final authService = Provider.of<AuthService>(context,listen: false);
      //await noti.initNotifications();
      try{
        UserCredential userCredential= await authService.signInWithEmailandPassword(
          emailController.text,
          passwordController.text,
          //noti.token
          "A"
          );
          
      }
      catch(e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),),);
      }
   }
   void ForgotPassword() async {
      if(emailController.text!="")
      {
        final authService = Provider.of<AuthService>(context,listen: false);
              try
              {
                await authService.ForgotPassword(
                emailController.text
                );
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Trimis,verifica emailul"),),);
              }         
              catch(e)
              {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),),);
              }
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Baga si tu un email unde sa iti resetez parola boss"),),);
      }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.message,
                    size: 80,
                  ),
                  const Text("Welcome back you\'ve been missed!",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              const SizedBox(height: 25),
              MyTextField(controller: emailController, hintText: "Email", obscureText: false),
              const SizedBox(height: 10),
             MyTextField(controller: passwordController, hintText: "Password", obscureText: true),
              const SizedBox(height: 25),
              //sign in button
              MyButton(onTap: signIn, text: "Sign In"),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Not a member?'),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text('Register now!',
                    style: TextStyle( 
                      fontWeight:  FontWeight.bold)
                    ),
                  )
                  
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Forgot your password?'),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: ForgotPassword,
                    child: Text('Tap Here',
                    style: TextStyle( 
                      fontWeight:  FontWeight.bold)
                    ),
                  )
                  
                ],
              )
              //namr button
            ],
            ),
        )
        )
      ),
    );
  }
}