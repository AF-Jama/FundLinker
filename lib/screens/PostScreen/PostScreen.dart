import 'package:flutter/material.dart';
import 'package:fundlinker/components/LoadingCard/LoadingCard.dart';
import '../../utils/utils.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key, required this.post});
  final Post post;

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.post.body) ) ,
      
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.all(Radius.circular(8.0))),
                padding: const EdgeInsets.all(8.0),
            
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Heading",style: TextStyle(color: Colors.black,fontSize: 13.0),),
            
                    const SizedBox(height: 20,),
            
                    Text(widget.post.heading,style: const TextStyle(color: Colors.black,fontSize: 13.0,),softWrap: true,)
                  ],
                ),
                ),

                  const SizedBox(height: 20,),

                  Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Body",style: TextStyle(color: Colors.black,fontSize: 13.0),),

                      const SizedBox(height: 20,),

                      Text(widget.post.body,style: const TextStyle(color: Colors.black,fontSize: 16.0,),softWrap: true,)
                    ],),),

                    const SizedBox(height: 30,),

                    const Center(child: Text("Stats",style: TextStyle(fontSize: 20.0),)),

                  FutureBuilder(
                  future: getFundraiserData(widget.post.link), 
                  builder: (context, snapshot) {
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
          ],
        ),
      ),);
  }
}