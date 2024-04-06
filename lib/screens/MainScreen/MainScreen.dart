import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fundlinker/components/LoadingCard/LoadingCard.dart';
import 'package:fundlinker/components/LoadingStats/LoadingStats.dart';
import 'package:fundlinker/utils/utils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:fundlinker/utils/firebase.dart';
import '../../components/BottomNavigationBar/BottomNavigationBar.dart';
import '../../components/PostCard/PostCard.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  late List<Post> _posts;
  late bool _loading;
  late bool _error;
  late int _pageNumber;
  late bool _isLastPage;
  int _numberOfPostsPerRequest = 5;
  late ScrollController _scrollController;
  String? lastDocumentId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _posts = [];
    _loading = true;
    _error = false;
    _pageNumber = 1;
    _isLastPage = false;
    fetchPage();
  }

  void fetchPage() async {
    try{

      final postList = await Firestore.getUserFeedPosts(lastDocumentId, Authentication.uid!, _numberOfPostsPerRequest);

      setState(() {
        _isLastPage = postList.length < _numberOfPostsPerRequest; // if posts returned is less than number of posts per page, this signifies that it is last page
        _loading = false;
        lastDocumentId = postList.isEmpty?null:postList[postList.length-1].postId; // gets last document id for previous query
        _posts.addAll(postList);
      });

    }catch(error){
      print(error);
      setState(() {
        _loading=false;
        _error=true;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      // nextPageTrigger will have a value equivalent to 80% of the list size.
        var nextPageTrigger =  _scrollController.position.maxScrollExtent; // returns 80% of max scroll

      // _scrollController fetches the next paginated data when the current postion of the user on the screen has surpassed 
        if (_scrollController.position.pixels == nextPageTrigger) {
            fetchPage();

        }
      });


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
              FutureBuilder(
                future: Future.wait([Firestore.getNumberOfPosts(Authentication.uid!),Firestore.getUserFollowersCount(Authentication.uid!)]),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    return SizedBox(
                      height: 115,
                      child: ListView(
                        
                      
                        scrollDirection: Axis.horizontal,
                        children: [
                          SizedBox(
                            width: 220,
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                const ListTile(title: Text("Total Fundraisers"),leading: Icon(Icons.star),),
                                Align(alignment: Alignment.center,child: Text("${snapshot.data![0]}",style: const TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,)))
                              ],),),
                          ),
                    
                          const SizedBox(
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
                                const ListTile(title: Text("Followers"),leading: Icon(Icons.person),),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("${snapshot.data![1]}",style: const TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,))
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
                        ]) ,);
                  }

                  return SizedBox(
                    height: 115 ,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        LoadingState(),
                        LoadingState(),
                        LoadingState()
                      ],
                    ),
                  );
                }, 
              ),

                  const SizedBox(height: 20,),

                  // Expanded(
                  //   child: FutureBuilder(
                  //     future: Firestore.getPosts(),
                  //     builder: (context, snapshot) {
                  //       if (snapshot.hasError) {
                  //       return const Center(child: Text('Something went wrong'));
                  //       }
                  
                  //       if(snapshot.hasData){
                  //         if(snapshot.data!.isEmpty){
                  //           return const Center(child: Text("No posts",style: TextStyle(fontSize: 18.0),),);
                  //         }

                  //         return ListView.builder(
                  //           scrollDirection: Axis.vertical,
                  //           itemCount: snapshot.data!.length ,
                  //           itemBuilder: (context, index) {
                  //             // Map<String, dynamic> data = snapshot.data!.docs[index].data() as Map<String,dynamic>;
                  //             final post = snapshot.data![index];

                  //             // return Card(
                  //             //   key:  Key(snapshot.data!.docs[index].id),
                  //             //   child: ListTile(
                  //             //         title:   Text(data['heading'],style: const TextStyle(fontSize: 18.0) ,overflow: TextOverflow.ellipsis,),
                  //             //         leading: const Icon(Icons.verified_user_sharp),
                  //             //         subtitle: Text(data['body']
                  //             //         ,softWrap: true,
                  //             //          maxLines: 6,overflow: TextOverflow.ellipsis,),
                  //             //       ),
                  //             // );

                  //             return PostCard(heading: post.heading ,body: post.body,postId: post.postId ,link: post.link,profilePath: post.imgPath,key: Key(post.postId),datetime: post.timeCreated,likes: post.like,);

                  //             //   return Shimmer.fromColors(
                  //             //     baseColor: Colors.grey, 
                  //             //     highlightColor: Colors.white,
                  //             //     child: LoadingCard());

                  //             //  },);

                  //           //  return SizedBox(
                  //           //   height: 200,
                  //           //   child: Card(
                  //           //     key: const Key("document.id"),
                  //           //     child: Padding(
                  //           //       padding: const EdgeInsets.all(8.0),
                  //           //       child: Column(
                  //           //       crossAxisAlignment: CrossAxisAlignment.start,
                  //           //       children: [
                  //           //         Text(data['heading'],style: const TextStyle(fontSize: 18.0) ,overflow: TextOverflow.ellipsis,),

                  //           //         const SizedBox(height: 5,),

                  //           //         Text(data['body']
                  //           //         ,softWrap: true,
                  //           //          maxLines: 6,overflow: TextOverflow.ellipsis,), 
                  //           //       ],),
                  //           //     )),
                  //           //   );
                              
                  //           },
                  
                  //         );
                  //       }
                  
                  //       // return const Center(child: CircularProgressIndicator(),);
                  //       // if(snapshot.connectionState==ConnectionState.waiting){
                  //       //   return const Center(child: CircularProgressIndicator(),);
                  //       // }

                  //       // return const Center(child: CircularProgressIndicator(),);
                  //       return Column(
                  //         children: [
                  //           LoadingCard(),
                  //           LoadingCard(),
                  //           LoadingCard(),
                  //           LoadingCard(),
                  //           LoadingCard(),
                  //         ],);
                  
                  //       // return ListView(
                  //       //   children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  //       //   Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                  //       //     return ListTile(
                  //       //       title: Text(data['full_name']),
                  //       //       subtitle: Text(data['company']),
                  //       //     );
                  //       //   }).toList()
                  //       // );
                        
                  //     },),
                  // )

                  Expanded(child: userFeed())
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

  Widget userFeed(){
    // if(_posts.isEmpty){
    //   if(!_loading && !_error){
    //     return const Center(child: Text("You have no posts in your feed") ,);
    //   }

    //   if(_loading){
    //     return const Center(child: CircularProgressIndicator(),);
    //   }else if(_error){
    //     return const Center(child: Text("Error fetching"));
    //   }

    //   return Column(
    //     children: [
    //       LoadingCard(),
    //       LoadingCard(),
    //       LoadingCard(),
    //       LoadingCard(),
    //       LoadingCard(),
    //     ],);
    // }

      if(_loading){
        return const Center(child: CircularProgressIndicator(),);
      }

      if(_error){
        return const Center(child: Text("Error fetching"));
      }

      if(_posts.isEmpty){
        return const Center(child: Text("Your feed is empty."));
      }

      return ListView.builder(
        controller: _scrollController,
        itemCount: _posts.length,
        itemBuilder: (context, index) {

          // if (_error) {
          //   return const Center(
          //       child: Text("Error")
          //   );
          // }

            final Post post = _posts[index];
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child:PostCard(heading: post.heading, body: post.body, postId: post.postId, link: post.link, hero: post.hero ,profilePath: post.imgPath, datetime: post.timeCreated, likes: post.like,isLiked: post.isLiked,)
            );
          // if(!_loading && !_error){
          //   final Post post = _posts[index];
          //   return Padding(
          //     padding: const EdgeInsets.all(15.0),
          //     child:PostCard(heading: post.heading, body: post.body, postId: post.postId, link: post.link, hero: post.hero ,profilePath: post.imgPath, datetime: post.timeCreated, likes: post.like,isLiked: post.isLiked,)
          //   );

          // }

          // return const Center(
          //     child: Padding(
          //       padding: EdgeInsets.all(8),
          //       child: CircularProgressIndicator(),
          //     ));
        });

      // if(!_loading && !_error){
      //   if(_posts.isEmpty){
      //     return const Center(child: Text("You have no posts in your feed") ,);
      //   }else{

      //   }
      // }

      return Column(
        children: [
          LoadingCard(),
          LoadingCard(),
          LoadingCard(),
          LoadingCard(),
          LoadingCard(),
        ],);



  }
}