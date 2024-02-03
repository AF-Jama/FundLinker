import 'package:flutter/material.dart';
import 'package:fundlinker/screens/AuthScreen/AuthScreen.dart';
import 'package:fundlinker/utils/utils.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Your Profile") ,
        centerTitle: true,
      ),

      body: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 120,minWidth: 120,maxHeight: 150,maxWidth: 150),
              child: const CircleAvatar(backgroundImage: AssetImage('assets/images/person.jpg') ,),),

              const SizedBox(height: 6,),

              ElevatedButton(
                onPressed: () async {
                  try {
                    await Authentication.googleSignOut();

                    Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) {return const AuthScreen();}), (route) => false);
                  } catch (e) {
                    
                  }
                },
                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red),iconColor: MaterialStatePropertyAll(Colors.white)),
                child: const Text("Logout",style: TextStyle(color: Colors.white),)),
          ],),
      ),
    );
  }
}