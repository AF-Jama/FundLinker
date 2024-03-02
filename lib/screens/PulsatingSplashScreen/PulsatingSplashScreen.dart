import 'package:flutter/material.dart';
import 'package:fundlinker/components/PulsatingLoader/PulsatingLoader.dart';

class PulsatingLoadingScreen extends StatelessWidget {
  const PulsatingLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {    
    double statusBarHeight = MediaQuery.of(context).padding.top; // status bar height
    double appBarHeight = AppBar().preferredSize.height;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: statusBarHeight+appBarHeight),
        width: double.infinity,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PulsatingLoader(),
            SizedBox(height: 20,),
          ],
        ),),
    );
  }
}