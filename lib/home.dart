import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int myIndex = 0;
  List<Widget> widgetList = const [
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [

      ],),
      body: SafeArea(  
        child: Container(
          child: Text('text'),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        fixedColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
            
        currentIndex: myIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.house_outlined),
            label: ""
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.email),
            label: ""
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: ""
          ),
        ],
      ),
    );
  }
}