// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fundlinker/screens/MainScreen/MainScreen.dart';
import 'package:fundlinker/utils/utils.dart';
import '../../utils/firebase.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';

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
  late File _imgFile; // img file state
  bool condition = true; // Replace with your actual condition


  Future takeSnapshot() async {
        final ImagePicker picker = ImagePicker();
        final XFile? img = await picker.pickImage(
          source: ImageSource.gallery, // alternatively, use ImageSource.gallery
          maxWidth: 400,
        );
        if (img == null) return; // convert it to a Dart:io file
        setState(() {
          _imgFile = File(img.path);
        });
  }

  Future _pickImageFromGallery() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery); // fetches image from local gallery

    if (returnedImage == null) return; // convert it to a Dart:io file

    setState(() {
      _imgFile = File(returnedImage.path); // sets file object 
    });

    await uploadFile(_imgFile); // uploading file to storage bucket
  }

   Future uploadFile(File? imgFile) async {
    if (imgFile == null) return;
    // final fileName = basename(_imgFile.path);
    final extensionName = extension(imgFile.path); // file name extension name

    print(extensionName==".jpg");

    if(extensionName==".jpg" || extensionName==".png"||extensionName==".jpeg"){
      final destination = 'fundlinker/profile/images/${Authentication.uid}$extensionName'; // reference to the file path on the storage bucket

      final ref = FirebaseStorage.instance
          .ref(destination); // creates reference to file path

      return await ref.putFile(imgFile); // uploads file to reference file path on storage bucket
    }

    throw "Could not file type";

  }

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
        
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 100,
                    maxHeight: 100
                  ),
                  child: SvgPicture.asset("assets/images/splash_logo.svg",fit: BoxFit.contain,) ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //   ],
                // ),
        
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

              // Container(
              // // height: 40,
              // decoration: BoxDecoration(border: DottedBor),
              // child: Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     Image.asset("assets/images/upload.png",height: 30,width: 30,),
              //     const SizedBox(height: 10,),
              //     const Text("Upload profie photo"),
              //   ],) ,),

              DottedBorder(
                color: Colors.black,
                strokeWidth: 1,
                child: GestureDetector(
                  onTap: () async {
                    try {
                      await _pickImageFromGallery();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Succesfully uploaded profile photo.")));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Could not upload profile photo.")));
                    }
                  },
                  child: SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/upload.png",height: 30,width: 30,),
                      const SizedBox(height: 10,),
                      const Text("Upload profie photo",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16.0)),
                      _imgFile!=null ? const Text("SUCCESFULL"): const Text("data"),
                    ],),
                  ),
                ),
              ),

              const SizedBox(height: 10,),
        
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