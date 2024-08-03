import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satelite_chatting_app/components/my_button.dart';
import 'package:satelite_chatting_app/components/my_text_field.dart';
import 'package:satelite_chatting_app/services/auth/auth_service.dart';
class RegisterPage extends StatefulWidget {
  final void Function() onTap;
  const RegisterPage({super.key,required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  void signUp()async {
    if(passwordController.text!=confirmPasswordController.text){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Passwords dont match!")));
      return;
    }

    final authService = Provider.of<AuthService>(context,listen:false);
    try{
      await  authService.signUpWithEmailandPassword(emailController.text, passwordController.text);
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
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
                  const Text("Let's create an account for you!",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              const SizedBox(height: 25),
              MyTextField(controller: emailController, hintText: "Email", obscureText: false),
              const SizedBox(height: 10),
             MyTextField(controller: passwordController, hintText: "Password", obscureText: true),
             const SizedBox(height: 10),
             MyTextField(
              controller: confirmPasswordController, 
              hintText: "Confirm Password", 
              obscureText: true
              ),
              const SizedBox(height: 25),
              //sign in button
              MyButton(onTap: signUp, text: "Sign Up"),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already a member?'),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text('Log in now!',
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