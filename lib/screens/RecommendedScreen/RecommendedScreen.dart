import 'package:flutter/material.dart';
// import 'package:redis/redis.dart';
import '../../utils/utils.dart';

class RecommendedScreen extends StatefulWidget {
  const RecommendedScreen({super.key});

  @override
  State<RecommendedScreen> createState() => _RecommendedScreenState();
}

class _RecommendedScreenState extends State<RecommendedScreen> {

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recommended Screen"),
      ),

      body: const Column(
        children: [
          Text("Recommended Screen")
        ]),
    );
  }
}