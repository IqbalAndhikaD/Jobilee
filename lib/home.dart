import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:tubes/rsc/colors.dart';

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
      // appBar: AppBar(actions: [

      // ],),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    textDirection: TextDirection.ltr,
                    children: [
                      ProfilePicture(
                        name: 'Jane Doe',
                        radius: 28,
                        fontsize: 20,
                        img: 'https://media.licdn.com/dms/image/C4D03AQFw3pddUPgL3Q/profile-displayphoto-shrink_100_100/0/1653903805288?e=1717027200&v=beta&t=Sx1Bk5eJaRvflRBZjS7bOe6J5Yc8MF-exLpa6NfDlhc',
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: SizedBox(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: bblue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                            onPressed: () => _showNotifications(context),
                            child: Icon(
                              Icons.notifications_none_outlined,
                              color: lblue,
                              size: 24,
                            )
                          )
                        )
                      )
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Text('Hello, Jane',
                    style: TextStyle(
                      fontSize: 18,
                      color: base,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'GreycliffCF'
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: lblue,
                    ),
                    child: const Text('Fresh Graduate',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GreycliffCF'
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 24),

              Row(children: <Widget>[
                Flexible(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                        child: TextField(
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[800],
                            fontFamily: 'GreycliffCF'
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: InputBorder.none,
                            hintText: 'Search job, company, post and others...', 
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 11,
                              fontFamily: 'GreycliffCF'
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: lblue,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],)
            ],
          )
        )
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

  Future<void> _showNotifications(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notifications'),
          content: const Text('You have no new notifications.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}