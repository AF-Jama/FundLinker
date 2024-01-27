import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  static Future<DocumentReference<Object?>> addPost(String heading, String body,String uid) async {
    return await posts.add(<String,dynamic>{
      'heading':heading,
      'body':body,
      'uid':uid,
      'likes':0,
      'dislikes':0,
      'accountCreatedOn':DateTime.now()
    });
  }

  // static Future<DocumentReference<Object?>> getAllPosts(String uid) async {
  //   return await posts.get()
    
  // }
}