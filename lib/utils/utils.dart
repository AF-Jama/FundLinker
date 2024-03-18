import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:redis/redis.dart';
import 'package:redis_dart/redis_dart.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';


class Authentication{
  // Authentication class that handles authentication across application

  static User? user = FirebaseAuth.instance.currentUser;

  static String? displayName = FirebaseAuth.instance.currentUser?.displayName; // returns display name if current user is logged in

  static String? email = FirebaseAuth.instance.currentUser?.email; // returns email if current user is logged in

  static String? uid = FirebaseAuth.instance.currentUser?.uid; // returns uid if current user is logged in

  static Future<String?> idToken = FirebaseAuth.instance.currentUser!.getIdToken(true); // returns uid if current user is logged in

  static Future<UserCredential> googleSignIn() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);

  }


  static Future<void> googleSignOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

}


late RedisClient client; // redis client

class Redis{

  static Future<RedisClient> getRedisClient() async {
    // final conn = RedisConnection();

    client =  await RedisClient.connect('192.168.0.100', 6379);

    return client;
  }

}

// Future<void> getLostData() async {
//   final ImagePicker picker = ImagePicker();
//   final LostDataResponse response = await picker.retrieveLostData();
//   if (response.isEmpty) {
//     return;
//   }
//   final List<XFile>? files = response.files;
//   if (files != null) {
//     _handleLostFiles(files);
//   } else {
//     _handleError(response.exception);
//   }
// }


class Post{
  Post({ this.imgPath, required this.heading, required this.body, required this.postId, required this.link, required this.like ,required this.timeCreated, required this.isLiked });

  String? imgPath; // img path can be actual path or null
  final String heading;
  final String body;
  final String postId;
  final String link;
  final int like;
  final Timestamp timeCreated;
  final bool isLiked;
}


class AppUser{
  AppUser({ required this.firstName, required this.lastName, required this.username, this.profilePath, required this.uid, this.followers, this.following });

  final String firstName;
  final String lastName;
  final String username;
  String? profilePath;
  final String uid;
  List<dynamic>? followers; // followers id list, List<String>? ???
  List<dynamic>? following; // following id list, List<String>? ???


}

class Scrape{
  Scrape({ required this.currentTotal, required this.donaters, required this.goal, required this.title  });

  final String currentTotal;
  final String donaters;
  final String goal;
  final String title;
  
}

Future<Scrape?> getFundraiserData(String url) async {
  try{
    final response = await http.get(Uri.parse("http://10.0.2.2:5000/data?url=https://$url"));

    if(response.statusCode==200){
      final Map<String,dynamic> data = jsonDecode(response.body) as Map<String,dynamic>;

      if(data['status']==400){
        throw Exception("Unable to fetch data");
      }

      return Scrape(currentTotal: data['data']['current_total'], donaters: data['data']['donaters'], goal: data['data']['goal'], title: data['data']['title']);
    }else{
      throw Exception("Could not fetch fundraiser data");
    }


  }catch(error){
    return null;
  }
}


// Future connectToFirebaseEmulator() async {
//   final localHostString = 'localhost';

//   FirebaseFirestore.instance.settings = Settings(
//     host: '$localHostString:8081',
//     sslEnabled: false,
//     persistenceEnabled: false,
//   );

//   await FirebaseAuth.instance.useAuthEmulator('localhost', 9098);
// }

// Future connectToFirestoreEmulator() async {
//   final localHostString = 'localhost';

//   FirebaseFirestore.instance.settings = Settings(
//     host: '$localHostString:8081',
//     sslEnabled: false,
//     persistenceEnabled: false,
//   );

//   FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
// }

Future connectToFirebaseEmulator() async {

  FirebaseFirestore.instance.settings = const Settings(
    host: 'localhost:8080',
    sslEnabled: false,
    persistenceEnabled: false,
  );

  await FirebaseStorage.instance.useStorageEmulator('localhost', 9199); // storage emulator

  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099); // auth emulator

  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080); // firestore emulator
}