// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fundlinker/screens/AuthScreen/AuthScreen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/utils.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
    body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 300,
                  maxHeight: 300
                ),
                child: SvgPicture.asset("assets/images/splash_logo.svg") ),

                const SizedBox(height: 20,),

                const CircularProgressIndicator(color: Colors.black,strokeWidth: 2.0,)
              // ElevatedButton(onPressed: () async {
              //   try {
              //     await Authentication.googleSignOut();
            
              //     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AuthScreen(),));
              //   } catch (e) {
              //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
              //   }
              // }, child: Text("Logout"))
            ]),
        ),
      ),
    ),
    );
  }
}