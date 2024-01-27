import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:redis/redis.dart';


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


class Redis{


  static Future<Command> getRedisClient() async {
    final conn = RedisConnection();

    Command client = await conn.connect('192.168.0.100', '6379'); // connecting to redis server on host 192.168.0.100 and port 6379

    return client;
  }
}