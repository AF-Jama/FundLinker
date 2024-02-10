import 'package:flutter/material.dart';
import 'package:fundlinker/screens/CreateScreen/CreateScreen.dart';
import 'package:fundlinker/screens/FollowerPostsScreen/FollowerPostsScreen.dart';
import 'package:fundlinker/screens/SearchScreen/SearchScreen.dart';
// import 'package:fundlinker/screens/ProfileScreen/ProfileScreen.dart';
// import 'package:fundlinker/screens/RecommendedScreen/RecommendedScreen.dart';
import 'package:fundlinker/screens/UserScreen/UserScreen.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key, required this.activePage});

  final int activePage; // active page index

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
    showSelectedLabels: false,
    showUnselectedLabels: false,
    currentIndex: activePage-1,
    items: const [
        BottomNavigationBarItem(
        icon: Icon(Icons.search,),
        tooltip: "Search",
        label: 'Search',
      ),
  
      BottomNavigationBarItem(
        icon: Icon(Icons.add),
        tooltip: "Create Post",
        label: 'Create Post',
      ),
  
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        tooltip: "Recommend",
        label: 'Recommendations',
      ),
    ],
    
    onTap: (value) {

      if(value==0){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SearchScreen() ,));
      }

      if(value==1){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CreateScreen() ,));
      }

      if(value==2){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CreateScreen() ,));
      }
    },
    );
  }
}