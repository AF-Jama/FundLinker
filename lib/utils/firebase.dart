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
      'likes':0,
      'dislikes':0,
      'time_created':DateTime.now(),
      'link':link,
    });
  }

  static Future<void> likePost(String uid,String postId) async {
    final CollectionReference userLikes = users.doc(uid).collection('likes');

    await posts.doc(postId).update({"likes": FieldValue.increment(1)});

    return await userLikes.doc(postId).set({
      'number':1,
    });
    
  }

  // static Future<DocumentReference<Object?>> getAllPosts(String uid) async {
  //   return await posts.get()
    
  // }

  static Future<bool> isPostLiked(String postId,String uid) async {
    final CollectionReference userLikesCollectionReference = users.doc(uid).collection('likes');

    final userLikes = await userLikesCollectionReference.doc(postId).get();
    // final userLikes = await userLikesCollectionReference.where(FieldPath.documentId,isEqualTo: postId).get();

    return userLikes.exists;

  } 

  static Future<void> removeLikePost(String uid,String postId) async {
    final CollectionReference userLikes = users.doc(uid).collection('likes');

    await userLikes.doc(postId).delete();

    await posts.doc(postId).update({"likes": FieldValue.increment(-1)});
  }

  static Future<List<Post>> getPosts() async { // returns promise, list of posts or null
    final CollectionReference posts = FirebaseFirestore.instance.collection("posts");

    final QuerySnapshot<Object?> allPosts = await posts.get();
    

    print(allPosts.docs.length);

    return Future.wait(allPosts.docs.map((post) async {
      final postData = post.data() as Map<String,dynamic>;

      final userUid = postData['uid']; // user id

      final userData = await Firestore.getUser(userUid); // returns user object

      final isPostLiked = await Firestore.isPostLiked(post.id, userUid); // returns bool if post is liked

      return Post(imgPath: userData.profilePath, heading: postData['heading'], body: postData['body'], postId: post.id, link: postData['link'],timeCreated: postData['time_created'],like: postData['likes'],isLiked: isPostLiked);

    },).toList());

  }

  static Future<AppUser> getUser(String uid) async {
    final userData = await users.doc(uid).get();

    final data = userData.data() as Map<String,dynamic>;

    return AppUser(firstName: data['firstName'], lastName: data['lastName'], username: data['username'], profilePath: data['profilePath'], uid: userData.id);

  }

  static Future<List<Post>> getUserPosts(String uid) async {
    final CollectionReference posts = FirebaseFirestore.instance.collection("posts");

    final userPosts = await posts.where('uid',isEqualTo: uid).get(); // returns user posts
    
    if(userPosts.docs.isEmpty) return [];

    return userPosts.docs.map((post) {
      final data = post.data() as Map<String,dynamic>;

      return Post(imgPath: data['profilePath'], heading: data['heading'], body: data['body'], postId: post.id, link: data['link'],timeCreated: data['time_created'],like: data['likes'],isLiked: true);
    },).toList();

    
  }

  static Future<List<AppUser>> getSearchedUsers(String query) async {
    final usersQueryResult = await users.orderBy("username").where('username',isGreaterThanOrEqualTo: query ).where('username',isLessThanOrEqualTo: '$query\uf8ff').limit(5).get();
    // final usersQueryResult = await users.orderBy("username").where('username',isEqualTo: query ).limit(5).get();

    if(usersQueryResult.docs.isEmpty){
      return [];
    }

    print(usersQueryResult.docs.length);

    return usersQueryResult.docs.map((e) {
      final Map<String,dynamic> data = e.data() as Map<String,dynamic>;

      print(data);

      return AppUser(firstName: data['firstName'], lastName: data['lastName'], username: data['username'],profilePath: data['profilePath'],uid: e.id);

    },).toList();
  }

  static Future<bool> isUsernameValid(String username) async {
    final queryResults =  await users.orderBy('username').where('username',isEqualTo: username).get();

    return queryResults.docs.isEmpty;
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