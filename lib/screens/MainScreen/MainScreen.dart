import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fundlinker/components/LoadingCard/LoadingCard.dart';
import 'package:fundlinker/utils/utils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:fundlinker/utils/firebase.dart';
import '../../components/BottomNavigationBar/BottomNavigationBar.dart';
import '../../components/PostCard/PostCard.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home")),

      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 115,
                child: ListView(
                  
                
                  scrollDirection: Axis.horizontal,
                  children: const [
                    SizedBox(
                      width: 220,
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          ListTile(title: Text("Total Fundraisers"),leading: Icon(Icons.star),),
                          Align(alignment: Alignment.center,child: Text("4",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,)))
                        ],),),
                    ),

                    SizedBox(
                      width: 220,
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          ListTile(title: Text("Total Raised"),leading: Icon(Icons.monetization_on),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("£4000",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,))
                            ],)
                        ],),),
                    ),

                    SizedBox(
                      width: 220,
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          ListTile(title: Text("Followers"),leading: Icon(Icons.person),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("400",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,))
                            ],)
                        ],),),
                    ),

                    // SizedBox(
                    //   width: 200,
                    //   child: Card(
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //       ListTile(title: Text("Card 4"),leading: Icon(Icons.album),)
                    //     ],),),
                    // )
                  ]) ,),

                  const SizedBox(height: 20,),

                  Expanded(
                    child: FutureBuilder(
                      future: Firestore.getPosts(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                        return const Center(child: Text('Something went wrong'));
                        }
                  
                        if(snapshot.hasData){
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data!.length ,
                            itemBuilder: (context, index) {
                              // Map<String, dynamic> data = snapshot.data!.docs[index].data() as Map<String,dynamic>;
                              final post = snapshot.data![index];

                              // return Card(
                              //   key:  Key(snapshot.data!.docs[index].id),
                              //   child: ListTile(
                              //         title:   Text(data['heading'],style: const TextStyle(fontSize: 18.0) ,overflow: TextOverflow.ellipsis,),
                              //         leading: const Icon(Icons.verified_user_sharp),
                              //         subtitle: Text(data['body']
                              //         ,softWrap: true,
                              //          maxLines: 6,overflow: TextOverflow.ellipsis,),
                              //       ),
                              // );

                              return PostCard(heading: post.heading ,body: post.body,postId: post.postId ,link: post.link,profilePath: post.imgPath,key: Key(post.postId),datetime: post.timeCreated,likes: post.like,);

                              //   return Shimmer.fromColors(
                              //     baseColor: Colors.grey, 
                              //     highlightColor: Colors.white,
                              //     child: LoadingCard());

                              //  },);

                            //  return SizedBox(
                            //   height: 200,
                            //   child: Card(
                            //     key: const Key("document.id"),
                            //     child: Padding(
                            //       padding: const EdgeInsets.all(8.0),
                            //       child: Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         Text(data['heading'],style: const TextStyle(fontSize: 18.0) ,overflow: TextOverflow.ellipsis,),

                            //         const SizedBox(height: 5,),

                            //         Text(data['body']
                            //         ,softWrap: true,
                            //          maxLines: 6,overflow: TextOverflow.ellipsis,), 
                            //       ],),
                            //     )),
                            //   );
                              
                            },
                  
                          );
                        }
                  
                        // return const Center(child: CircularProgressIndicator(),);
                        // if(snapshot.connectionState==ConnectionState.waiting){
                        //   return const Center(child: CircularProgressIndicator(),);
                        // }

                        // return const Center(child: CircularProgressIndicator(),);
                        return Column(
                          children: [
                            LoadingCard(),
                            LoadingCard(),
                            LoadingCard(),
                            LoadingCard(),
                            LoadingCard(),
                          ],);
                  
                        // return ListView(
                        //   children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        //   Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                        //     return ListTile(
                        //       title: Text(data['full_name']),
                        //       subtitle: Text(data['company']),
                        //     );
                        //   }).toList()
                        // );
                        
                      },),
                  )
            ]),
        ) ,),

        bottomNavigationBar: Container(
          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0))),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: BottomNav(activePage: 2,)
          ),
        ),
    );
  }
}