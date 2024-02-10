// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fundlinker/utils/utils.dart';
import '../../utils/firebase.dart';
import 'dart:math';

class PostCard extends StatefulWidget {
  const PostCard({super.key, required this.heading, required this.body, required this.postId, required this.link, required this.profilePath, required this.datetime, required this.likes});

  final String heading;
  final String body;
  final String postId;
  final String link;
  final String profilePath;
  final Timestamp datetime;
  final int likes;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  // int likes=0;
  // int dislikes =0;

  @override
  Widget build(BuildContext context) {
    // bool isPostLiked = true;
    // int currentLikes = widget.likes;
    
    return Container(
      padding: const EdgeInsets.all(3.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(backgroundImage: (widget.profilePath!=null)?NetworkImage(widget.profilePath!):const AssetImage("assets/images/person.jpg") as ImageProvider ,),
    
              const SizedBox(width: 20,),
    
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.heading,style: const TextStyle(fontSize: 18.0) ,overflow: TextOverflow.ellipsis), // heading
    
                    Text(widget.link,style: const TextStyle(fontWeight: FontWeight.bold)),
              
                    const SizedBox(height: 4,),
              
                  Text(widget.body
                  ,softWrap: true,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,), //body
                  ],
                ),
              )
            ],
          ),
    
          // const SizedBox(height: 6,),
    
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(onTap: () async {
                try {
                  final isPostLiked = await Firestore.isPostLiked(widget.postId, Authentication.uid!);

                  if(!isPostLiked){
                    await Firestore.likePost(Authentication.uid!,widget.postId);
                    setState(() {
                      // likes = likes +1;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Liked Post")));
                    return;
                  } 

                  await Firestore.removeLikePost(Authentication.uid!, widget.postId);
                  setState(() {
                      // likes = likes +1;
                    });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Unliked Post")));
                  return;
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Could not like post with id ${widget.postId}")));
                }
              },child: Image.asset("assets/images/heart.png",height: 20,width: 20,)),
              const SizedBox(width: 6,),
              Text("${widget.likes}",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14.0),)
            ],),
    
          const SizedBox(height: 6),
    
          const Divider(color: Colors.black,height: 2.0,),
    
          const SizedBox(height: 20,)
        ],) ,);
  }
}