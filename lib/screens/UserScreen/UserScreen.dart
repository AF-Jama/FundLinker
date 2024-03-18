import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../PulsatingSplashScreen/PulsatingSplashScreen.dart';
import 'package:fundlinker/screens/SplashScreen/SplashScreen.dart';
import 'package:fundlinker/utils/firebase.dart';
import '../../utils/firebase.dart';
import '../../utils/utils.dart';
import 'package:fundlinker/components/PostCard/PostCard.dart';
import 'package:http/http.dart' as http;


class UserScreen extends StatefulWidget {
  // const UserScreen({super.key, required this.imgPath, required this.firstName, required this.lastName});
  const UserScreen({super.key, required this.user});
  final AppUser user; // user

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  // final String? imgPath; // img profile path or null
  bool isFollowing=false;
  int numberOfFollowers = 0;
  int numberOfFollowing = 0;
  int numberOfPosts = 0;
  int pass = 1;

  late bool _isLastPage; // boolean is last page
  late bool _error; // boolean error
  late bool _loading; // // loading error
  final int _numberOfPostsPerRequest = 5; // number of posts per page
  late List<Post> _posts; // posts 
  final int _nextPageTrigger = 3; // posts left until fetching next page
  late ScrollController _scrollController;
  String? lastDocumentId; // last document id, initially is null

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchFollowerCount();
    fetchFollowingCount();
    getFollowingStatus();
    getNumberOfPosts();
    _posts = [];
    _loading = true;
    _error=false;
    _isLastPage=false;
    fetchPage();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void fetchFollowerCount() async {
    // Fetch follower count from Firestore
    final followerCount = await Firestore.getUserFollowersCount(widget.user.uid);
    setState(() {
      numberOfFollowers = followerCount;
    });
  }

  void fetchFollowingCount() async {
    // Fetch follower count from Firestore
    final followingCount = await Firestore.getUserFollowingCount(widget.user.uid);
    setState(() {
      numberOfFollowing = followingCount;
    });
  }

  void getFollowingStatus() async {
    final bool isFollowingUser = await Firestore.isFollowing(Authentication.uid!, widget.user.uid);

    setState(() {
      isFollowing = isFollowingUser;
    });
  }

  void getNumberOfPosts() async {
    final numberOfUserPosts = await posts.where("uid",isEqualTo: widget.user.uid).get();

    setState(() {
      numberOfPosts = numberOfUserPosts.docs.length;
    });
  }

  void fetchPage() async {
    late Query<Object?> userPosts;
    try{
      final CollectionReference posts = FirebaseFirestore.instance.collection("posts"); // returns reference to post collection

      if(lastDocumentId==null){
        // triggered if last document
        userPosts =  posts
        .where("uid",isEqualTo: widget.user.uid)
        .limit(_numberOfPostsPerRequest)
        .orderBy("time_created",descending: true);
      }else{
        final finalDocSnapshot = await posts.doc(lastDocumentId).get();
        
        userPosts = posts
        .where("uid",isEqualTo: widget.user.uid)
        .limit(_numberOfPostsPerRequest)
        .orderBy("time_created",descending: true)
        .startAfterDocument(finalDocSnapshot);

      }

      final userPostss =  await userPosts.get(); // returns user posts document

      final List<Post> postList = await Future.wait(userPostss.docs.map((post) async {
      final Map<String,dynamic> data = post.data() as Map<String,dynamic>;
      
      final isPostLiked = await Firestore.isPostLiked(post.id, widget.user.uid);

      return Post(imgPath: data['link'], heading: data['heading'], body: data['body'], postId: post.id, link: data['link'],timeCreated: data['time_created'],like: data['likes'],isLiked: isPostLiked);
    },).toList());

      setState(() {
        _isLastPage = postList.length < _numberOfPostsPerRequest; // if posts returned is less than number of posts per page, this signifies that it is last page
        _loading = false;
        lastDocumentId = postList.isEmpty?null:postList[postList.length-1].postId; // gets last document id for previous query
        _posts.addAll(postList);
      });

    }catch(error){
      setState(() {
        _loading=false;
        _error=true;
      });
    }
  }
  

  // Future<void> getData() async {
  //   print("SUCCESFULL");
  //   print("Current page is $_pageNumber");
  //   try{
  //     final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts?_page=200&_limit=$_numberOfPostsPerRequest"));

  //     // print(response.body);

  //     final data = jsonDecode(response.body) as List<dynamic>; // decodes json to object

  //     final List<JsonUser> dataList = data.map((post) => JsonUser(userId: post['userId'], postId: post['id'], title: post['title'], body: post['body']) ).toList();

  //     // print(dataList);

  //     setState(() {
  //       _isLastPage = dataList.length < _numberOfPostsPerRequest; // triggered if page returns results less than number of posts per request
  //       _loading = false;
  //       _error = false;
  //       _pageNumber = _pageNumber+1;
  //       _posts.addAll(dataList);
  //     });
  //   }catch(error){
  //     print("Error is $error");
  //     setState(() {
  //       _error = true;
  //       _loading = false;
  //     });
  //   }
  // }

  // Future<List<Post>> getDocuments() async {
  //   final finalDocSnapshot = await posts.doc("WMboJ3T6qT92OPuO6sJ9").get();

  //   final userPosts = await posts
  //   .where("uid",isEqualTo: widget.user.uid)
  //   .limit(_numberOfPostsPerRequest)
  //   .orderBy("time_created",descending: true)
  //   .startAfterDocument(finalDocSnapshot)
  //   .get();    


  //   final postList = userPosts.docs.map((post) {
  //     final Map<String,dynamic> data = post.data() as Map<String,dynamic>;

  //     return Post(imgPath: data['link'], heading: data['heading'], body: data['body'], postId: post.id, link: data['link'],timeCreated: data['time_created'],like: data['likes'],isLiked: true);
  //   },).toList();

  //   return postList;



  // }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top; // status bar height
    double appBarHeight = AppBar().preferredSize.height;

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
      // appBar: AppBar(title: const Text("User"),centerTitle: true, ),

      body: Column(
          children: [
            Container(
             // color: const Color.fromRGBO(0,154,68, 1),
             padding: EdgeInsets.only(top: statusBarHeight+appBarHeight,bottom: 30.0),
             // decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12.0),bottomRight: Radius.circular(12.0))),
            //  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25.0),bottomRight: Radius.circular(25.0))
             decoration: const BoxDecoration(color: Color.fromRGBO(0,154,68, 1), borderRadius: BorderRadius.all(Radius.circular(16.0))  ),
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
                   SizedBox(height: 90,width: 90,child: CircleAvatar(backgroundImage: (widget.user.profilePath!=null)?NetworkImage(widget.user.profilePath!):const AssetImage("assets/images/default-user.jpg") as ImageProvider ,),),
                
                   const SizedBox(width: 20,),
                
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                     Text("${widget.user.firstName} ${widget.user.lastName}",style: const TextStyle(fontSize: 18.0,color: Colors.white),),
                     Text("@${widget.user.username}",style: const TextStyle(fontSize: 18.0,color: Colors.white),),
                    //  const Text("Hey Now, from the howard stern show",style: TextStyle(color: Colors.white)),
                     const SizedBox(height: 6,),
                     
                     if(Authentication.uid!=widget.user.uid)
                     // triggered if current id != user profile id
                      (isFollowing // is following boolean
                      ?
                      ElevatedButton(onPressed: () async {
                      // unfollow logic
                      await Firestore.removeUser(Authentication.uid!, widget.user.uid);
                      setState(() {
                        numberOfFollowers = numberOfFollowers-1;
                      });    
                      setState(() {
                        isFollowing=false;
                      });
                      }, style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.white),shape: MaterialStatePropertyAll(RoundedRectangleBorder(side: BorderSide(width: 2.0,color: Colors.transparent),borderRadius: BorderRadius.all(Radius.circular(6.0)) ),),),child: const Text("Following",style: TextStyle(color: Colors.green,fontWeight: FontWeight.w600),),)
                      :ElevatedButton(onPressed: () async {
                        // follow logic
                        
                        await Firestore.followUser(Authentication.uid!, widget.user.uid);
                        setState(() {
                        numberOfFollowers = numberOfFollowers+1;
                      });    
                        setState(() {
                          isFollowing=true;
                        });
                      }, style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.white),shape: MaterialStatePropertyAll(RoundedRectangleBorder(side: BorderSide(width: 2.0,color: Colors.transparent),borderRadius: BorderRadius.all(Radius.circular(6.0)) ),),),child: const Text("Follow",style: TextStyle(color: Colors.green,fontWeight: FontWeight.w600),),)
                    )
                      else
                        const ElevatedButton(onPressed: null, style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.white),shape: MaterialStatePropertyAll(RoundedRectangleBorder(side: BorderSide(width: 2.0,color: Colors.transparent),borderRadius: BorderRadius.all(Radius.circular(6.0)))) ),child: const Text("Settings",style: TextStyle(color: Colors.green,fontWeight: FontWeight.w600),),)
                   ],)
                 ],),
        
                 const SizedBox(height: 30,),
        
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                   Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text("$numberOfFollowers",style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.bold)),
                       const Text("Follower",style: TextStyle(color: Colors.white),),
                   ],),
        
                   Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text("$numberOfFollowing",style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.bold)),
                       const Text("Following",style: TextStyle(color: Colors.white),),
                   ],),
        
                   Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text("$numberOfPosts",style: const TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.bold)),
                       const Text("Posts",style: TextStyle(color: Colors.white),),
                   ],)
                 ],)  
             ],) ,),

            //  Expanded(
            //   child: FutureBuilder(
            //     future: Firestore.getUserPosts(widget.user.uid),
            //     builder: (context, snapshot) {
            //       if(snapshot.hasData){
            //         if(snapshot.data!.isEmpty){
            //           print(snapshot.data);
            //           return Center(child: Text("${widget.user.firstName} ${widget.user.lastName} has no posts"));
            //         }

            //         return ListView.builder(
            //           controller: _scrollController,
            //           scrollDirection: Axis.vertical,
            //           itemCount: snapshot.data!.length,
            //           itemBuilder: (context, index) {
            //             final post = snapshot.data![index];

            //             return PostCard(heading: post.heading, body: post.body, postId: post.postId, link: post.link, profilePath: widget.user.profilePath, datetime: post.timeCreated, likes: post.like);
            //           },);

            //         // return Text("User has ${snapshot.data!.docs.length} posts");
            //       }

            //       if(snapshot.hasError){
            //         print(snapshot.error);
            //         return const Center(child: Text("Error while fetching posts"),);
            //       }

            //       return const Center(child: CircularProgressIndicator(),);
            //     },))

            Expanded(child: buildPostsView())
          ],)
      );
  }

  Widget buildPostsView(){
    // if(_posts.isEmpty){
    //   if(_loading){
    //     return const Center(child: CircularProgressIndicator(),);
    //   }else if(_error){
    //     return const Center(child: Text("Error fetching"));
    //   }

    //   return const Center(child: Text("Could not find posts"),);
    // }

    if(_loading){
        return const Center(child: CircularProgressIndicator(),);
    }

    if(_error){
        return const Center(child: Text("Error fetching"));
    }

    if (_posts.isEmpty) {
      return const Center(child: Text("Could not find posts"),);
    }

    return ListView.builder(
          controller: _scrollController,
          itemCount: _posts.length,
          itemBuilder: (context, index) {

            if (_error) {
              return const Center(
                  child: Text("Error")
              );
            }

            if(!_loading && !_error){
              final Post post = _posts[index];
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child:PostCard(heading: post.heading, body: post.body, postId: post.postId, link: post.link, profilePath: widget.user.profilePath, datetime: post.timeCreated, likes: post.like,isLiked: post.isLiked,)
              );

            }

            return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: CircularProgressIndicator(),
                ));
          });


  }
}

class JsonUser{
  const JsonUser({required this.userId, required this.postId, required this.title, required this.body});

  final int userId;
  final int postId;
  final String title;
  final String body;
}