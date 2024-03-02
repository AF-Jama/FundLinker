import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';


class PulsatingLoader extends StatelessWidget {
  const PulsatingLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80
      ,width: 80
      ,child: AvatarGlow(
          curve: Curves.bounceInOut, 
          child: Material(     // Replace this child with your own
            elevation: 8.0,
            shape: const CircleBorder(),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Image.asset(
                'assets/images/logo.png',
              ),
              radius: 120.0,
            ),
          ),
          glowColor: Colors.blue,
        ),);
  }
}