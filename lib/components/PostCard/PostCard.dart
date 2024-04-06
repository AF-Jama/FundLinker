// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fundlinker/screens/PostScreen/PostScreen.dart';
import 'package:fundlinker/utils/utils.dart';
import 'package:like_button/like_button.dart';
import '../../utils/firebase.dart';
import 'dart:math';

class PostCard extends StatefulWidget {
  PostCard({super.key, required this.heading, required this.body, required this.postId, required this.link, required this.hero ,this.profilePath, required this.datetime, required this.likes, required this.isLiked});

  final String heading;
  final String body;
  final String postId;
  final String link;
  final String hero;
  final String? profilePath;
  final Timestamp datetime;
  final int likes;
  final bool isLiked;

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

    print("Post is like status is ${widget.isLiked}");
    
    return Container(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(onTap: () => print("SUCCESFULL"),child: CircleAvatar(backgroundImage: (widget.profilePath!=null)?NetworkImage(widget.profilePath!):const AssetImage("assets/images/default-user.jpg") as ImageProvider ,)),
      
                const SizedBox(width: 20,),
      
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen(post: Post(heading: widget.heading, body: widget.body, postId: widget.postId, link: widget.link, like: widget.likes, hero: widget.hero ,timeCreated: widget.datetime, isLiked: widget.isLiked,imgPath: widget.profilePath)),)) ,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.heading,style: const TextStyle(fontSize: 18.0) ,overflow: TextOverflow.ellipsis), // heading
                          
                        Text(widget.link,style: const TextStyle(fontWeight: FontWeight.bold)),

                        // Text(widget.hero!),  
                                    
                        const SizedBox(height: 4,),
                                    
                      Text(widget.body
                      ,softWrap: true,
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,), //body
                      ],
                    ),
                  ),
                )
              ],
            ),
      
            // const SizedBox(height: 6,),
      
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                LikeButton(
                  animationDuration: const Duration(seconds: 1)
                  ,likeCount: widget.likes
                  ,isLiked: widget.isLiked,
                  onTap: (isLiked) async {
                    // triggered on tap to implement user post like and unliking
                    try {
                    // final isPostLiked = await Firestore.isPostLiked(widget.postId, Authentication.uid!);
                
                    if(isLiked){
                      // triggered on unlike
                      await Firestore.removeLikePost(Authentication.uid!, widget.postId);
      
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Unliked Post")));
                    } 
      
                    if(!isLiked){
                      // triggered on like
                      await Firestore.likePost(Authentication.uid!,widget.postId);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Liked Post")));
      
                    }
      
                    return !isLiked;
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Could not like or unlike post with id: try again ${widget.postId}")));
                    return null;
                  }
                  },),
              ],),
      
            const SizedBox(height: 6),
      
            const Divider(color: Colors.black,height: 2.0,),
      
            const SizedBox(height: 20,)
          ],));
  }
}