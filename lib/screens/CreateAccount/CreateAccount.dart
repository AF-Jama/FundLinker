// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fundlinker/screens/MainScreen/MainScreen.dart';
import 'package:fundlinker/utils/utils.dart';
import '../../utils/firebase.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {

  final firstNameController = TextEditingController(); // first name controller
  final lastNameController = TextEditingController(); // last name controller

  String firstName = '';
  String lastName = '';
  String description = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
        centerTitle: true,
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
        
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 100,
                        maxHeight: 100
                      ),
                      child: SvgPicture.asset("assets/images/splash_logo.svg",fit: BoxFit.contain,) ),
                  ],
                ),
        
                const SizedBox(height: 8,),
        
                TextField(
                  controller: firstNameController,
                  maxLength: 50,
                  decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Your First name',
                ),),
        
                const SizedBox(height: 10,),
        
                TextField(
                  controller: lastNameController,
                  maxLength: 50,
                  decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Your last name',
                )),
        
        
        
              const SizedBox(height: 8,),
        
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(onPressed: () async {
                    try {
                      if(firstNameController.value.text.isEmpty || firstNameController.value.text.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Input fields must not be empty or greater than length 50")));
                        return;
                      }

                      await Firestore.createAccount(Authentication.uid!, firstNameController.value.text, lastNameController.value.text);

                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MainScreen(),));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  }, child: const Text("Create",style: TextStyle(color: Colors.black),),),
                ],
              )
              ],
            ),
          ),
        ),
    );
  }
}