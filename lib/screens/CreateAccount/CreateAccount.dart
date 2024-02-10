// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:path/path.dart';
import 'package:image/image.dart' as img;
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
  final usernameController = TextEditingController();

  String firstName = '';
  String lastName = '';
  String description = '';
  File? _imgFile; // img file state, can be late???
  bool condition = true; // Replace with your actual condition
  String? downloadPath; // download path
  bool isUsernameValid = false;
  bool isUploadingImage=false;

  final _formKey = GlobalKey<FormState>();


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

    final File file = File(returnedImage.path); // sets file object

    final isDimensionsValid = await _checkImageDimensions(file);

    if(!isDimensionsValid) return;

    print("HERE");

    setState(() {
      _imgFile = File(returnedImage.path); // sets file object 
    });

    await uploadFile(_imgFile); // uploading file to storage bucket
  }


  Future<bool> _checkImageDimensions(File imageFile) async {
    // Read image dimensions using the image package
    int minWidth=600; // img min width
    int minHeight=335; // img min height

    int sizeInBytes = imageFile.lengthSync(); // returns img file size
    double sizeInMb = sizeInBytes / (1024 * 1024); // returns img file in mb

    final imgFileInBytes = await imageFile.readAsBytes(); // returns img file in bytes

    final decodedImage = img.decodeImage(imgFileInBytes);

    return decodedImage != null && decodedImage.width >=minWidth && decodedImage.height >= minHeight && sizeInMb<=5; // returns boolean if conditions are triggered


  }

   Future<String?> uploadFile(File? imgFile) async {
    if (imgFile == null) return null;
    // final fileName = basename(_imgFile.path);
    final extensionName = extension(imgFile.path); // file name extension name

    print(extensionName);

    if(extensionName==".jpg"){
      final destination = 'fundlinker/profile/images/${Authentication.uid}$extensionName'; // reference to the file path on the storage bucket

      final ref = FirebaseStorage.instance
          .ref(destination); // creates reference to file path
      
      setState(() {
        isUploadingImage=true;
      });

      await ref.putFile(imgFile); // uploads file to reference file path on storage bucket

      try {        
        var dowurl = await ref.getDownloadURL();

        setState(() {
          downloadPath=dowurl;
        });

      } catch (e) {
        setState(() {
          downloadPath=null;
        });
      }

      setState(() {
        isUploadingImage=false;
      });



    }else{
      setState(() {
        isUploadingImage=false;
      });
      throw "Could not file type";
      
    }


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

                // Form(
                //   key: _formKey,
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       TextFormField(
                //         // The validator receives the text that the user has entered.
                        
                // ),

                Form(
                  key: _formKey ,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  TextFormField(
                    controller: firstNameController,
                    maxLength: 50,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                    },
                    decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Your First name',
                  ),),

                  const SizedBox(height: 10,),

                  TextFormField(
                    controller: lastNameController,
                    maxLength: 50,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                    },
                    decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Your last name',
                  )),

                  TextFormField(    
                    controller: usernameController,
                    validator: (value) {
                      final pattern = RegExp(r'^[a-zA-Z0-9_-]{3,15}$');
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }

                      if(!pattern.hasMatch(value)){
                        return "Username must be atleast 3 characters";
                      }

                      if(!isUsernameValid){
                        return "Username is not valid";
                      }
                    },
                    maxLength: 50,
                    onChanged: (value) async {
                      final isValid = await Firestore.isUsernameValid(value); // returns boolean true if username is valid

                      final isMatch = RegExp(r'^[a-zA-Z0-9_-]{3,15}$').hasMatch(value); // returns bool true if value matches pattern

                      if(isValid && isMatch){
                        // triggered if value is valid and matches regex pattern
                        setState(() {
                          isUsernameValid=isValid;
                        });
                        return;

                      }

                      setState(() {
                        isUsernameValid=false;
                      });
                      return;
                      

                      // RegExp(source)

                      // isUsernameValid = await Firestore.isUsernameValid(value); // returns boolean if username exists
                    },
                    decoration: InputDecoration(
                      hintText: 'Your username',
                      focusedBorder: OutlineInputBorder(
                        borderSide: (isUsernameValid)?const BorderSide(width: 3, color: Colors.greenAccent):const BorderSide(width: 3, color: Colors.redAccent), //<-- SEE HERE
                      ), 
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green,width: 3)
                      ),  
                    ),
                ),

                UploadImage(context),

                const SizedBox(height: 10,),
          
                CreateAccountBtn(context)
                  ],
                ) ,),
        
        
        

                // TextField(
                //   controller: usernameController,
                //   maxLength: 50,
                //   onChanged: (value) async {
                //     isUsernameValid = await Firestore.doesUsernameExist(value); // returns boolean if username exists

                //     setState(() {
                //       isUsernameValid=isUsernameValid;
                //     });
                //   },
                //   decoration: const InputDecoration(
                //   border: OutlineInputBorder(),
                //   hintText: 'Your First name',
                // ),),

        
        
        
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


              ],
            ),
          ),
        ),
    );
  }

  Row CreateAccountBtn(BuildContext context) {
    return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(onPressed: (isUploadingImage==true)? null : () async {
                  try {
                    if(_formKey.currentState!.validate()){
                      // if(firstNameController.value.text.isEmpty || firstNameController.value.text.isEmpty){
                      //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Input fields must not be empty or greater than length 50")));
                      //   return;
                      // }

                      await Firestore.createAccount(Authentication.uid!, firstNameController.value.text, lastNameController.value.text,usernameController.value.text,downloadPath);

                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MainScreen(),));
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                }, child: const Text("Create",style: TextStyle(color: Colors.black),),),
              ],
            );
  }

  DottedBorder UploadImage(BuildContext context) {
    return DottedBorder(
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
                      isUploadingImage?const CircularProgressIndicator():const Text("Upload profile photo",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16.0)),
                      // _imgFile!=null ? const Text("SUCCESFULL"): const Text("data"),
                    ],),
                  ),
                ),
              );
  }
}