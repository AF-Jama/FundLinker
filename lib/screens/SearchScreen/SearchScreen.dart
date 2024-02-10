import 'package:flutter/material.dart';
import 'package:fundlinker/components/UserCard/UserCard.dart';
import 'package:fundlinker/screens/UserScreen/UserScreen.dart';
import 'package:fundlinker/utils/firebase.dart';
import 'package:fundlinker/utils/utils.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Future<List<AppUser>> appUsers;
    String _searchQuery=''; // search query
    // Future<List<AppUser>> getUsers;

  //  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   // appUsers = Firestore.getSearchedUsers("jamesmanning");
  // }


  @override
  Widget build(BuildContext context) {


    double statusBarHeight = MediaQuery.of(context).padding.top; // status bar height
    double appBarHeight = AppBar().preferredSize.height;

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: statusBarHeight+appBarHeight,bottom: 30.0,left: 12.0,right: 12.0), 
            child: TextField(
              onChanged: (value) {
                print("Text changed: $value");
                setState(() {
                  _searchQuery=value;
                });
              },
              decoration: const InputDecoration(
              prefixIcon: Icon(Icons.alternate_email_outlined,color: Colors.black,),
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
              hintText: 'Search Tech Talk',
            ),
        ), ),

        Expanded(child: FutureBuilder(
          future: Firestore.getSearchedUsers(_searchQuery),
          builder:(context, snapshot) {
            if(_searchQuery.isEmpty){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ConstrainedBox(constraints: const BoxConstraints(minWidth: 100,minHeight: 100,maxHeight: 150,maxWidth: 150),child: Image.asset("assets/images/search.png") ,),
                    const Text("Search for user")
                  ],
                ),
              );
            }

            if(snapshot.hasData){
              if(snapshot.data!.isEmpty){
                return Center(child: const Text("No user found"));
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    // return SizedBox(height: 200,child: Card(child: Text(snapshot.data![index].firstName)),);
                    final data = snapshot.data![index];
                    return GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UserScreen(user: data,),)),
                      child: UserCard(imgPath: data.profilePath,firstName: data.firstName,lastName: data.lastName,username: data.username,uid: data.uid,));
                  },),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ))

        ],
      ),
    );
  }
}