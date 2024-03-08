import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import './utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final CollectionReference users = FirebaseFirestore.instance.collection("users");
final CollectionReference posts = FirebaseFirestore.instance.collection("posts");
final Stream<QuerySnapshot> userStream = FirebaseFirestore.instance.collection("posts").snapshots();

class Firestore{

  static Future<bool> doesUserExist(String uid) async {
    DocumentSnapshot<Object?> df = await users.doc(uid).get();

    return df.exists; // returns bool

  }


  static Future<void> createAccount(String uid,String firstName,String lastName,String username,String? profilePath) async {
    
    return await users.doc(uid).set(<String, dynamic>{
      'firstName':firstName,
      'lastName':lastName,
      'profilePath':(profilePath==null)?"":profilePath,
      'username':username,
      'accountCreatedOn':DateTime.now()
    });
  }

  static Future<DocumentReference<Object?>> addPost(String heading, String body,String uid,String link) async {
    return await posts.add(<String,dynamic>{
      'heading':heading,
      'body':body,
      'uid':uid,
      'likes':1, // by default likes is set to 1
      // 'dislikes':0,
      'time_created':DateTime.now(),
      'link':link,
    });
  }

  static Future<void> likePost(String uid,String postId) async {
    final DocumentReference<Object?> user = users.doc(uid); // reference to user document

    await user.update({"likes": FieldValue.arrayUnion([postId])}); // updates likes field with postId
    
  }

  // static Future<DocumentReference<Object?>> getAllPosts(String uid) async {
  //   return await posts.get()
    
  // }

  static Future<bool> isPostLiked(String postId,String uid) async {
    final DocumentReference<Object?> userDocumentReference = users.doc(uid); // returns reference to user document

    final DocumentSnapshot<Object?> user = await userDocumentReference.get();

    final Map<String,dynamic> data = user.data() as Map<String,dynamic>;

    final List<dynamic>? likedList = data["likes"]; // returns liked list or null

    if(likedList==null) return false;

    return likedList.contains(postId);

  } 

  static Future<void> removeLikePost(String uid,String postId) async {
    final DocumentReference<Object?> user = users.doc(uid); // returns reference to user document

    await user.update({"likes":FieldValue.arrayRemove([postId])}); // updates likes field with removing postId 
  }

  static Future<List<Post>> getPosts() async { // returns promise, list of posts or null
    final CollectionReference posts = FirebaseFirestore.instance.collection("posts"); // returns reference to post collection

    final QuerySnapshot<Object?> allPosts = await posts.orderBy("time_created",descending: true).get();
    

    print(allPosts.docs.length);

    return Future.wait(allPosts.docs.map((post) async {
      final postData = post.data() as Map<String,dynamic>;

      final userUid = postData['uid']; // user id

      final userData = await Firestore.getUser(userUid); // returns user object

      final isPostLiked = await Firestore.isPostLiked(post.id, userUid); // returns bool if post is liked

      return Post(imgPath: userData.profilePath, heading: postData['heading'], body: postData['body'], postId: post.id, link: postData['link'],timeCreated: postData['time_created'],like: postData['likes'],isLiked: isPostLiked);

    },).toList());

  }

  static Future<List<Post>> getUserFeedPosts(String? lastDocumentId,String uid,int queryLimit) async {
    final CollectionReference posts = FirebaseFirestore.instance.collection("posts"); // returns reference to post collection
    late Query<Object?> userPosts;

    final userData = await Firestore.getUser(uid); // returns user

    final followingList = userData.following; // returns user following

    if(lastDocumentId==null){
      userPosts = posts
      .where("uid",whereIn: followingList)
      .limit(queryLimit)
      .orderBy("time_created",descending: true);
    }else{
      
      final finalDocSnapshot = await posts.doc(lastDocumentId).get(); // returns final post document

      userPosts = posts
      .where("uid",whereIn: followingList)
      .limit(queryLimit)
      .orderBy("time_created",descending: true)
      .startAfterDocument(finalDocSnapshot);
    }

    final userPostss = await userPosts.get();

    return Future.wait(userPostss.docs.map((post) async {
      final Map<String,dynamic> postData = post.data() as Map<String,dynamic>;

      final userUid = postData['uid']; // user id of post document

      final userData = await Firestore.getUser(userUid); // returns user object

      final isPostLiked = await Firestore.isPostLiked(post.id, uid); // returns bool if post is liked

      return Post(imgPath: userData.profilePath, heading: postData['heading'], body: postData['body'], postId: post.id, link: postData['link'],timeCreated: postData['time_created'],like: postData['likes'],isLiked: isPostLiked);

    },).toList());

  }

  static Future<AppUser> getUser(String uid) async {
    final userData = await users.doc(uid).get();

    final data = userData.data() as Map<String,dynamic>;

    return AppUser(firstName: data['firstName'], lastName: data['lastName'], username: data['username'], profilePath: data['profilePath'], uid: userData.id,followers: data['followers'],following: data['following']);

  }

  static Future<List<Post>> getUserPosts(String uid) async {
    final CollectionReference posts = FirebaseFirestore.instance.collection("posts");

    final userPosts = await posts
        .where('uid', isEqualTo: uid)
        .orderBy('time_created', descending: true)
        .get(); // returns user postss
    
    if(userPosts.docs.isEmpty) return [];

    return userPosts.docs.map((post) {
      final Map<String,dynamic> data = post.data() as Map<String,dynamic>;

      return Post(imgPath: data['link'], heading: data['heading'], body: data['body'], postId: post.id, link: data['link'],timeCreated: data['time_created'],like: data['likes'],isLiked: true);
    },).toList();

    
  }

  static Future<List<AppUser>> getSearchedUsers(String query) async {
    final usersQueryResult = await users.orderBy("username").where('username',isGreaterThanOrEqualTo: query ).where('username',isLessThanOrEqualTo: '$query\uf8ff').limit(5).get();
    // final usersQueryResult = await users.orderBy("username").where('username',isEqualTo: query ).limit(5).get();

    // if(usersQueryResult.docs.isEmpty){
    //   return [];
    // }

    print(usersQueryResult.docs.length);

    return usersQueryResult.docs.map((e) {
      final Map<String,dynamic> data = e.data() as Map<String,dynamic>;

      print(data['followers'] is List<dynamic>);

      return AppUser(firstName: data['firstName'], lastName: data['lastName'], username: data['username'],profilePath: data['profilePath'],uid: e.id,);

    },).toList();
  }

  static Future<bool> isUsernameValid(String username) async {
    final queryResults =  await users.orderBy('username').where('username',isEqualTo: username).get();

    return queryResults.docs.isEmpty;
  }

  static Future<void> followUser(String uid,String followeeId) async {
    // logic to follow user, following a user  

    await users.doc(uid).update({
      'following':FieldValue.arrayUnion([followeeId])
    }); // user following, where uid follows followeeid

    await users.doc(followeeId).update({
      'followers':FieldValue.arrayUnion([uid])
    }); // inverse relationship where uid is a follower of followee

  }

  static Future<void> removeUser(String uid,String followeeId) async {
    // logic to unfollow(remove) user, following a user  

    await users.doc(uid).update({
      'following':FieldValue.arrayRemove([followeeId])
    }); // users remove followee from following list<String>

    await users.doc(followeeId).update({
      'followers':FieldValue.arrayRemove([uid])
    }); // inverse relationship, follower removed from followee follower list<String>

  }

  static Future<bool> isFollowing(String uid,String followeeId) async {
    // returns boolean if user is following followee
    final user = await users.doc(uid).get();

    if(!user.exists){
      return false;
    }

    final Map<String,dynamic> data  = user.data() as Map<String,dynamic>;

    final List followingList = (data['following']==null)?[]:data['following'] as List<dynamic>; // returns following array within user document data, contains all uid of following users

    return followingList.contains(followeeId); // returns bool promise value

  }

  static Future<bool> isFollower(String uid,String followerId) async {
    // returns boolean if follower(followerId) is following user
      final user = await users.doc(uid).get();

      if(!user.exists){
        return false;
      }

    final Map<String,dynamic> data  = user.data() as Map<String,dynamic>;

    final List followerList = (data['followers']==null)?[]: data['followers'] as List<dynamic>; // returns followers array within user document data, contains all uids of followers --> List<dynamic>???, refactor to List<string>?

    return followerList.contains(followerId); // returns bool promise value
  }

  static Future<int> getUserFollowersCount(String uid) async {
    final user = await users.doc(uid).get();

    if(!user.exists) return 0; // triggered if user does not exist

    final Map<String,dynamic> data = user.data() as Map<String,dynamic>; // user data within document

    final List<dynamic>? followersList = data['followers'];

    return (followersList==null)?0:followersList.length; // returns 0 if follower list is null (signifying user has no followers) or returns follower list length
    
  }

 static Future<int> getUserFollowingCount(String uid) async {
    final user = await users.doc(uid).get();

    if(!user.exists) return 0; // triggered if user does not exist

    final Map<String,dynamic> data = user.data() as Map<String,dynamic>; // user data within document

    final List<dynamic>? followingList = data['following'];

    return (followingList==null)?0:followingList.length; // returns 0 if following list is null (signifying user is following no one) or returns following list length
    
  }

  // static Future<void> addProfileImage(File file,String uid) async {
  //   final fileName = basename(file.path);
  //   final destination = 'files/$fileName';

  //   final ref = FirebaseStorage.instance
  //   .ref(destination)
  //   .child('file/');
  //   await ref.putFile(file);


  //   // await ref.putFile(file);
  // }
}


class FireStorage{



  static Future<String?> getUserProfileImage(String uid) async {
      final ref = FirebaseStorage.instance.ref("fundlinker/profile/images/$uid.jpg");

      try{
        return await ref.getDownloadURL();

      }catch(error){
        return null;
      }
  }

}