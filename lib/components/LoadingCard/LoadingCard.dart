import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingCard extends StatelessWidget {
  int likes=0;
  int dislikes =0;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
       baseColor: Colors.grey,
       highlightColor: Colors.white,
       child: Container(
      padding: const EdgeInsets.all(3.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const CircleAvatar(backgroundImage: AssetImage('assets/images/person.jpg') ,),
            Container(
            height: 50,
            width: 50,
            color: Colors.white,
            ),

            const SizedBox(width: 20,),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text("widget.heading",style: const TextStyle(fontSize: 18.0) ,overflow: TextOverflow.ellipsis), // heading
              Container(
                height: 10,
                width: double.infinity,
                color: Colors.white,
                ),

                const SizedBox(height: 7,),

              Container(
                height: 6,
                width: 100,
                color: Colors.white,
              ),

              const SizedBox(height: 7,),

              Container(
                height: 6,
                width: 100,
                color: Colors.white,
              ),

              const SizedBox(height: 7,),

              Container(
                height: 6,
                width: 100,
                color: Colors.white,
              ),
            
                const SizedBox(height: 4,), //body
                ],
              ),
            )
            ],
          ),

          // const SizedBox(height: 6,),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(onTap: null,child: Image.asset("assets/images/heart.png",height: 20,width: 20,)),
              const SizedBox(width: 6,),
              Text("$likes",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14.0),)
            ],),

          const SizedBox(height: 6),

          const Divider(color: Colors.black,height: 2.0,),

          const SizedBox(height: 20,)
        ],) ,));
  }
}