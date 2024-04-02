import 'package:flutter/material.dart';
import 'package:tubes/apply.dart';
import 'package:tubes/home.dart';
import 'package:tubes/profile.dart';
import 'package:tubes/rsc/colors.dart';
import 'package:tubes/saved.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => new _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int index = 0;
  final screens = [
    Home(title: '',),
    Apply(),
    Saved(),
    Profile()
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    body: screens[index],
    bottomNavigationBar: NavigationBarTheme(
      data: NavigationBarThemeData(
        indicatorColor: lblue,
        labelTextStyle: MaterialStateProperty.all(
          TextStyle(
            fontSize: 0
          )
        )
      ),
      child: NavigationBar(
        height: 60,
        backgroundColor: Colors.white,
        selectedIndex: index,
        onDestinationSelected: (index) => 
          setState(() => this.index = index),
        destinations: [
        NavigationDestination(
          icon: Icon(
            Icons.home_outlined, 
            color: Colors.grey,
          ), 
          selectedIcon: Icon(
            Icons.home, 
            color: Colors.white,
          ),
          label: ''
        ),
        NavigationDestination(
          icon: Icon(
            Icons.near_me_outlined,
            color: Colors.grey,
          ),
          selectedIcon: Icon(
            Icons.near_me,
            color: Colors.white,
          ), 
          label: ''
        ),
        NavigationDestination(
          icon: Icon(
            Icons.bookmark_border_rounded,
            color: Colors.grey,
          ), 
          selectedIcon: Icon(
            Icons.bookmark,
            color: Colors.white,
          ),
          label: ''
        ),
        NavigationDestination(
          icon: Icon(
            Icons.person_2_outlined,
            color: Colors.grey,
          ), 
          selectedIcon: Icon(
            Icons.person_2,
            color: Colors.white,
          ),
          label: ''
        ),
      ],
      ),
    ),
   );
  }
}