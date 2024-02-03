import 'dart:io';
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


  static Future<void> createAccount(String uid,String firstName,String lastName) async {
    
    return await users.doc(uid).set(<String, dynamic>{
      'firstName':firstName,
      'lastName':lastName,
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

    // if(userLikes.size==1){
    //   // triggered if postId exists within user likes collection
    //   return true;
    // }

    // return false;

  } 

  static Future<void> removeLikePost(String uid,String postId) async {
    final CollectionReference userLikes = users.doc(uid).collection('likes');

    await userLikes.doc(postId).delete();

    await posts.doc(postId).update({"likes": FieldValue.increment(-1)});
  }

  static Future<List<Post>> getPosts() async { // returns promise, list of posts or null
    final CollectionReference posts = FirebaseFirestore.instance.collection("posts");

    final QuerySnapshot<Object?> allPosts = await posts.get();

    return Future.wait(allPosts.docs.map((post) async {
      final postData = post.data() as Map<String,dynamic>;

      final userUid = postData['uid']; // user id

      final userProfileImage = await FireStorage.getUserProfileImage(userUid); // returns user profile image

      if(userProfileImage==null){
        return Post(imgPath: null, heading: postData['heading'], body: postData['body'], postId: post.id, link: postData['link'],timeCreated: postData['time_created'],like: postData['likes']);
      }

      return Post(imgPath: userProfileImage, heading: postData['heading'], body: postData['body'], postId: post.id, link: postData['link'],timeCreated: postData['time_created'],like: postData['likes']);

    },).toList());

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