import 'package:flutter/material.dart';
import 'package:fundlinker/components/AuthButton/AuthButton.dart';
import 'package:fundlinker/utils/utils.dart';
import '../AuthScreen/AuthScreen.dart';
import 'dart:math';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Welcome"),
      ),
      body: Stack( // stack takes constraints of scaffold which is the full size of the screen
        fit: StackFit.expand, // constraints passed to stack are tightened ie: full screen, or if loose contraints are loosened-> for non positioned elements 
        children: [
          Image.asset("assets/images/background.jpeg",fit: BoxFit.cover,height: 100,width: 100,),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Welcome to Fundlinker, a place to promote fundraisers that you care about.",style: TextStyle(color: Colors.white,fontSize: 24.0,fontWeight: FontWeight.w900,fontFamily: "WorkSans",),),

              const SizedBox(height: 100,),

              Center(child: SizedBox(height:100,width: 100,child: Image.asset("assets/images/logo.png",fit: BoxFit.cover,))),

              const SizedBox(height: 30,),

              const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AuthButton(title: "Sign Up using Google", photoUrl: 'assets/images/google.png',onSignIn: Authentication.googleSignIn ),
                    SizedBox(height: 8,),
                    // AuthButton(title:"Sign Up using Apple", photoUrl: "assets/images/apple.png")
                ],))
            ],),)
        ],
      ),
    );
  }
}