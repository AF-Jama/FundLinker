import 'package:flutter/material.dart';
import 'package:fundlinker/screens/CreateScreen/CreateScreen.dart';
import 'package:fundlinker/screens/FollowerPostsScreen/FollowerPostsScreen.dart';
import 'package:fundlinker/screens/RecommendedScreen/RecommendedScreen.dart';

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
        icon: Icon(Icons.zoom_out_map,),
        tooltip: "Followers Post",
        label: 'Followers Post',
      ),
  
      BottomNavigationBarItem(
        icon: Icon(Icons.add),
        tooltip: "Create Post",
        label: 'Create Post',
      ),
  
      BottomNavigationBarItem(
        icon: Icon(Icons.recommend),
        tooltip: "Recommend",
        label: 'Recommendations',
      ),
    ],
    
    onTap: (value) {

      if(value==0){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FollowerPostScreen() ,));
      }

      if(value==1){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CreateScreen() ,));
      }

      if(value==2){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RecommendedScreen() ,));
      }
    },
    );
  }
}