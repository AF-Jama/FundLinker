import 'package:flutter/material.dart';
import 'package:fundlinker/utils/utils.dart';


class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.imgPath, required this.firstName, required this.lastName, required this.username, required this.uid});

  final String imgPath;
  final String firstName;
  final String lastName;
  final String username;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(12.0)),color: Colors.grey[200]),
          child: Row(
            children: [
              SizedBox(height: 60,width: 60,child: CircleAvatar(backgroundImage: (imgPath!="")?NetworkImage(imgPath):const AssetImage("assets/images/default-user.jpg") as ImageProvider ,), ),

              const SizedBox(width: 12,),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text("$firstName $lastName ${Authentication.uid==uid?"(You)":""} "),
                // Text(imgPath,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                Text("@$username",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)
              ],)
          ],),
        ),

        const SizedBox(height: 7,),
      ],
    );
  }
}