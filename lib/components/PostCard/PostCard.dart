import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  const PostCard({super.key, required this.heading, required this.body});

  final String heading;
  final String body;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int likes=0;
  int dislikes =0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(backgroundImage: AssetImage('assets/images/person.jpg') ,),

              const SizedBox(width: 20,),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.heading,style: const TextStyle(fontSize: 18.0) ,overflow: TextOverflow.ellipsis),
              
                    const SizedBox(height: 4,),
              
                  Text(widget.body
                  ,softWrap: true,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,),
                  ],
                ),
              )
            ],
          ),

          // const SizedBox(height: 6,),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(children: [
                GestureDetector(onTap: () {
                 setState(() {
                   likes = likes +1;
                 }); 
                },child: Image.asset("assets/images/heart.png",height: 20,width: 20,)),
                const SizedBox(width: 6,),
                Text("$likes",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14.0),)
              ],)
            ],),

          const SizedBox(height: 6),

          const Divider(color: Colors.black,height: 2.0,),

          const SizedBox(height: 20,)
        ],) ,);
  }
}