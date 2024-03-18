// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fundlinker/components/LoadingCard/LoadingCard.dart';
import 'package:fundlinker/screens/MainScreen/MainScreen.dart';
import 'package:fundlinker/utils/firebase.dart';
import 'package:fundlinker/utils/utils.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {

  final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20),backgroundColor:Colors.red);

  bool isSubmitting = false; // submitted state of type bool
  final _formKey = GlobalKey<FormState>();
  final headingController = TextEditingController(); // title controller
  final bodyController = TextEditingController(); // body controller
  final URLcontroller = TextEditingController(); // url controller

  String urlString = '';


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Promote Fundraiser"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // const Text("Create Post"),
          
                  ElevatedButton(
                    onPressed: () async {
                      if(_formKey.currentState!.validate()){
                        // triggered if descendants of form widget return true
                        try{
                          // throw "Error";
                          setState(() {
                            isSubmitting = true;
                          });

                          
                          await Firestore.addPost(headingController.value.text, bodyController.value.text, Authentication.uid!,URLcontroller.value.text);

                          setState(() {
                            isSubmitting = false;
                          });
                          
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const MainScreen(),), (route) => false);

                        }catch(error){
                          setState(() {
                            isSubmitting = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error posting, please try again later")));
                        }
                      }

                      
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:Colors.blue[700],
                      foregroundColor: Colors.black,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                      ),
                      
                      ),
                     child: isSubmitting? const CircularProgressIndicator(strokeWidth: 2.0,) : const Text("Create Post"),)
                ],
              ),
          
              const SizedBox(height: 8,),
          
              const Divider(thickness: 1,),

              Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    controller: headingController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter title body',
                  ),
                  maxLength: 100,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter title body';
                    }

                    if(value.length<5) return "Title should be greater than length 5";
                    return null;
                  },
                ),
                const SizedBox(height: 20,),
          
                TextFormField(
                  controller: bodyController,
                  maxLength: 500,
                  buildCounter: (context, {required currentLength, required isFocused, maxLength}) =>  Text("${currentLength.toString()}/${maxLength.toString()}"),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Describe your fundraiser you want to promote',
                    counterStyle: TextStyle(color: Colors.black)
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter text here';
                    }
                    return null;
                  },
                ),


                TextFormField(
                    controller: URLcontroller,
                    onChanged: (value) => setState(() {
                      urlString = value;
                    }),
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'Enter URL of fundraiser(www.gofund.com/....)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter text here';
                    }

                    if(!RegExp(r'^www.gofundme.com\/[a-zA-Z]\/[\w-]+$').hasMatch(value)){
                      return "Use valid go fund me link";
                    }
                  },
                ),
                ],)),
          


                // Expanded(
                // child: Column(children: [
                //   TextFormField(
                //   decoration: const InputDecoration(
                //     border: OutlineInputBorder(),
                //     hintText: 'Enter title body',
                //   ),
                //   validator: (String? value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Enter title body';
                //     }
                //     return null;
                //   },
                // ),
          
                // const SizedBox(height: 20,),
          
                // TextFormField(
                //   maxLength: 500,
                //   buildCounter: (context, {required currentLength, required isFocused, maxLength}) =>  Text("${currentLength.toString()}/${maxLength.toString()}"),
                //   keyboardType: TextInputType.multiline,
                //   maxLines: null,
                //   decoration: const InputDecoration(
                //     border: InputBorder.none,
                //     hintText: 'Describe your fundraiser you want to promote',
                //     counterStyle: TextStyle(color: Colors.black)
                //   ),
                //   validator: (String? value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Enter text here';
                //     }
                //     return null;
                //   },
                // ),
          
                // ],))

                // const Center(child: Text("SUCCESFULL"),)

                const SizedBox(height: 10,),

                FutureBuilder(
                  future: getFundraiserData(urlString), 
                  builder: (context, snapshot) {
                    if(urlString.isEmpty){
                      return const Center(child: Text("Enter Go Fund Me address to fetch data",style: TextStyle(fontSize: 18.0),));
                    }

                    if(snapshot.data==null){
                      return const Center(child: Text("No data found, at this moment",style: TextStyle(fontSize: 17.0),));
                    }
                      
                    if(snapshot.hasData){

                      return SizedBox(
                        height: 115,
                        child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          SizedBox(
                            width: 220,
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                const ListTile(title: Text("Current Total"),leading: Icon(Icons.star),),
                                Align(alignment: Alignment.center,child: Text(snapshot.data!.currentTotal,style: const TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,)))
                              ],),),
                          ),

                          SizedBox(
                            width: 220,
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                const ListTile(title: Text("Total Raised"),leading: Icon(Icons.monetization_on),),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(snapshot.data!.goal,style: const TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,))
                                  ],)
                              ],),),
                          ),

                        SizedBox(
                          width: 220,
                          child: Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              const ListTile(title: Text("Donaters"),leading: Icon(Icons.person),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(snapshot.data!.donaters,style: const TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,))
                                ],)
                            ],),),
                        ),
                          ]));
                    }


                  return Column(
                  children: [
                    LoadingCard(),
                    LoadingCard(),
                    LoadingCard(),
                    LoadingCard(),
                    LoadingCard(),
                  ],);
                  },)
          
              
            ]),
        ),
      ),
    );
  }
}