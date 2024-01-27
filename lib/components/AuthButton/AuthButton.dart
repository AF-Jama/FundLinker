// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fundlinker/screens/SplashScreen/SplashScreen.dart';
import 'package:fundlinker/utils/utils.dart';
import '../SnackBar/SnackBar.dart';
import '../../screens/MainScreen/MainScreen.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({super.key, required this.title, required this.photoUrl, required this.onSignIn});

  final String photoUrl;
  final String title;
  final Future<UserCredential> Function() onSignIn;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          final user = await onSignIn();

          if(user.user!=null){
            // ignore: use_build_context_synchronously
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SplashScreen(),));
          }


        } on FirebaseAuthException catch(e){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
        }
        catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      },
      child: Container(
            decoration: const BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(12.0))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(height: 30,width: 30,child: Image.asset(photoUrl),),
                  const SizedBox(width: 5,),
                  Text(title)
                ],),
            ) ,) ,);
  }
}