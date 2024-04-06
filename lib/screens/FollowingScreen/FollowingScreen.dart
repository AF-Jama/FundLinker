import 'package:flutter/material.dart';
import 'package:fundlinker/components/UserCard/UserCard.dart';
import 'package:fundlinker/screens/UserScreen/UserScreen.dart';
import 'package:fundlinker/utils/firebase.dart';
import 'package:fundlinker/utils/utils.dart';

class FollowingScreen extends StatefulWidget {
  FollowingScreen({super.key});

  int queryLimit = 10;

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {

    ScrollController _scrollController = ScrollController();

  int numberOfFollowers = 0; // initial number of followers state
  bool isLoading = true; // loading state
  bool isError = false; // error state
  bool isLastPage = false; // is last page state
  String? lastDocumentId; // last document id 
  List<AppUser> users = []; // user state

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchData();

  }

  void fetchData() async {
    try{
      final List<AppUser> userFollowers = await Firestore.getUserFollowingAccount(lastDocumentId, Authentication.uid!, widget.queryLimit);

      setState(() {
        lastDocumentId = userFollowers.isEmpty?null:userFollowers[userFollowers.length-1].uid;
        users.addAll(userFollowers);
        isLoading = false;
        isError = false;
        isLastPage = userFollowers.length<widget.queryLimit; // triggered if returned page has data less than query limit
      });
      
    }catch(error){
      print(error);
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
            // nextPageTrigger will have a value equivalent to 80% of the list size.
        var nextPageTrigger =  _scrollController.position.maxScrollExtent; // returns 80% of max scroll

      // _scrollController fetches the next paginated data when the current postion of the user on the screen has surpassed 
        if (_scrollController.position.pixels == nextPageTrigger) {
          fetchData();
        }
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Following "),),

      body: Padding(
       padding: const EdgeInsets.all(8.0)
      ,child: userFollowingView() ,),
    );
  }

  Widget userFollowingView(){
    if(isLoading){
      return const Center(child: CircularProgressIndicator(),);
    }

    if(isError){
      return const Center(child: Text("Failed to load following users"),);
    }

    if(users.isEmpty){
      return const Center(child: Text("You are following no users"),);
    }

    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: users.length,
      itemBuilder: (context, index) {
        final AppUser user = users[index];

        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UserScreen(user: user),))
          ,child: UserCard(firstName: user.firstName, lastName: user.lastName, username: user.username, uid: user.uid));
      },);
  }
}