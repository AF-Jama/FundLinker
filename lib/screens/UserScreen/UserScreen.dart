import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fundlinker/utils/firebase.dart';
import '../../utils/utils.dart';
import 'package:fundlinker/components/PostCard/PostCard.dart';


class UserScreen extends StatefulWidget {
  // const UserScreen({super.key, required this.imgPath, required this.firstName, required this.lastName});
  const UserScreen({super.key, required this.user});
  final AppUser user; // user

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  // final String? imgPath; // img profile path or null
  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top; // status bar height
    double appBarHeight = AppBar().preferredSize.height;
    return Scaffold(
      // appBar: AppBar(title: const Text("User"),centerTitle: true, ),

      body: Stack(
        children: [
          Container(
           // color: const Color.fromRGBO(0,154,68, 1),
           padding: EdgeInsets.only(top: statusBarHeight+appBarHeight,bottom: 30.0),
           // decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12.0),bottomRight: Radius.circular(12.0))),
          //  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25.0),bottomRight: Radius.circular(25.0))
           decoration: const BoxDecoration(color: Color.fromRGBO(0,154,68, 1)  ),
           child: Column(
            mainAxisSize: MainAxisSize.min,
           children: [
             Padding(
               padding: const EdgeInsets.only(left: 12.0,right: 12.0),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                 // Icon(Icons.arrow_back,color: Colors.black,),
                 GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back,color: Colors.white,)),
                 const Icon(Icons.more_vert,color: Colors.white,)
               ],),
             ),
              
             // const SizedBox(height: 20,),
              
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 SizedBox(height: 90,width: 90,child: CircleAvatar(backgroundImage: (widget.user.profilePath!='')?NetworkImage(widget.user.profilePath):const AssetImage("assets/images/default-user.jpg") as ImageProvider ,),),
              
                 const SizedBox(width: 20,),
              
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                   Text("${widget.user.firstName} ${widget.user.lastName}",style: const TextStyle(fontSize: 18.0,color: Colors.white),),
                   Text("@${widget.user.username}",style: const TextStyle(fontSize: 18.0,color: Colors.white),),
                   const Text("Hey Now, from the howard stern show",style: TextStyle(color: Colors.white)),
                   const SizedBox(height: 6,),
                   const ElevatedButton(onPressed: null, style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.white)),child: Text("+ Follow",style: TextStyle(color: Colors.green,fontWeight: FontWeight.w600),),)
                 ],)
               ],),

               const SizedBox(height: 30,),

               const Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                 Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text("80",style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.bold)),
                     Text("Follower",style: TextStyle(color: Colors.white),),
                 ],),

                 Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text("80",style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.bold)),
                     Text("Following",style: TextStyle(color: Colors.white),),
                 ],),

                 Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text("80",style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.bold)),
                     Text("Posts",style: TextStyle(color: Colors.white),),
                 ],)
               ],)  
           ],) ,),

           FutureBuilder(
            future: Firestore.getUserPosts(widget.user.uid),
            builder: (context, snapshot) {

              if(snapshot.hasData){
                if(snapshot.data!.isEmpty){
                  return Center(child: Text("${widget.user.firstName} ${widget.user.lastName} has no posts"));
              }

              return DraggableScrollableSheet(
                initialChildSize: 0.62,
                minChildSize: 0.62,
                maxChildSize: 0.95,
                
                builder: (context, scrollController) {
                  return Container(
                    // color: Colors.blue[100],
                    decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0)),color: Colors.white),
                    child: ListView.builder(
                      controller: scrollController,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        final post = snapshot.data![index];
                        return PostCard(heading: post.heading, body: post.body, postId: post.postId, link: post.link, profilePath: post.imgPath, datetime: post.timeCreated, likes: post.like);
                      },
                    ),
                  );
              },);

              }

              return const Center(child:  CircularProgressIndicator(),);
            },
          ),
      
        // Expanded(child: Container(color: Colors.white,),),
        // DraggableScrollableSheet(
        //   initialChildSize: 0.62,
        //   minChildSize: 0.62,
        //   maxChildSize: 0.95,
          
        //   builder: (context, scrollController) {
        //   return FutureBuilder(
        //     future: Firestore.getUserPosts(widget.user.uid),
        //     builder: (context, snapshot) {

        //       if(snapshot.hasData){
        //         if(snapshot.data!.isEmpty){
        //           return Text("${widget.user.firstName} ${widget.user.lastName} has no posts");
        //         }

        //         return Container(
        //           // color: Colors.blue[100],
        //           decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0)),color: Colors.white),
        //           child: ListView.builder(
        //             controller: scrollController,
        //             scrollDirection: Axis.vertical,
        //             itemCount: snapshot.data!.length,
        //             itemBuilder: (BuildContext context, int index) {
        //               final post = snapshot.data![index];
        //               return PostCard(heading: post.heading, body: post.body, postId: post.postId, link: post.link, profilePath: post.imgPath, datetime: post.timeCreated, likes: post.like);
        //             },
        //           ),
        //         );

        //       }

        //       return const Center(child:  CircularProgressIndicator(),);
        //     },
        //   );
        // },)
        ],),
      );
  }
}