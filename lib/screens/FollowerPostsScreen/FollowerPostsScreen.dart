import 'package:flutter/material.dart';

class FollowerPostScreen extends StatefulWidget {
  const FollowerPostScreen({super.key});

  @override
  State<FollowerPostScreen> createState() => _FollowerPostScreenState();
}

class _FollowerPostScreenState extends State<FollowerPostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Posts by your followers"),
      ),

      body: const Column(
        children: [
          Text("Follower Post Screen")
        ],
      ),
    );
  }
}