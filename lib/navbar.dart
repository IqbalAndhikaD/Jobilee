// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:tubes/apply.dart';
import 'package:tubes/find.dart';
import 'package:tubes/home.dart';
import 'package:tubes/profile.dart';
import 'package:tubes/rsc/colors.dart';
import 'package:tubes/saved.dart';

class NavBar extends StatefulWidget {
  final int index;

  const NavBar({super.key, required this.index});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final screens = [
    const Home(title: ''),
    const Apply(),
    const Find(),
    const Saved(),
    const Profile(),
  ];

  @override
  void initState() {
    super.initState();
    _index = widget.index;
  }

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: lblue,
          labelTextStyle: MaterialStateProperty.all(const TextStyle(fontSize: 0)),
        ),
        child: NavigationBar(
          height: 60,
          backgroundColor: Colors.white,
          selectedIndex: _index,
          onDestinationSelected: (index) => setState(() => _index = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(
                Icons.home_outlined,
                color: Colors.grey,
              ),
              selectedIcon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              label: '',
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
              label: '',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.business_center_outlined,
                color: Colors.grey,
              ),
              selectedIcon: Icon(
                Icons.business_center,
                color: Colors.white,
              ),
              label: '',
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
              label: '',
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
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}