import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:tubes/applyjob.dart';
import 'package:tubes/find.dart';
import 'package:tubes/navbar.dart';
import 'package:tubes/rsc/colors.dart';

import 'package:tubes/authentication/authen_service.dart';
import 'package:tubes/rsc/colors.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/foundation.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int myIndex = 0;
  List<Widget> widgetList = const [];

  final user = AuthenService().currentUser;
  dynamic userInfo;

  Future<dynamic> getUserInfo() async {
    var result = await AuthenService().getUserInfo();
    if (result != null) {
      setState(() {
        userInfo = result;
      });
    }
  }

  Future<QuerySnapshot> getData() async {
    CollectionReference jobVacancies =
        FirebaseFirestore.instance.collection("job_vacations");

    return await jobVacancies.get();
  }

  Widget _jobVacanciesList() {
    return FutureBuilder(
      future: getData(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView(
            children: snapshot.data!.docs
                .map((doc) => Card(
                    color: Colors.white,
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey[200],
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Image(
                              image: NetworkImage(doc.get('company_img')),
                              height: 35,
                              width: 35,
                            ),
                          ),
                          Flexible(
                            child: ListTile(
                                title: Text(
                                  doc.get('position'),
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: base,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'GreycliffCF'),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doc.get('company_name'),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: base,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'GreycliffCF'),
                                    ),
                                    const Text(
                                      '+300 Applicants',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'GreycliffCF'),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: dpurple,
                                              ),
                                              child: Text(
                                                doc.get('contract'),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'GreycliffCF'),
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: yellow,
                                            ),
                                            child: Text(
                                              doc.get('work_type'),
                                              style: TextStyle(
                                                  color: base,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'GreycliffCF'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  alignment: WrapAlignment.spaceBetween,
                                  direction: Axis.horizontal,
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor: lblue,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              minimumSize: Size(60, 0),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ApplyJob(),
                                                  ));
                                            },
                                            child: const Text(
                                              'Apply',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'GreycliffCF',
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Ink(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: bblue,
                                          ),
                                          child: IconButton(
                                            icon: Icon(
                                                Icons.bookmark_border_outlined),
                                            color: lblue,
                                            iconSize: 20,
                                            onPressed: () {},
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                          )
                        ],
                      ),
                    )))
                .toList(),
          );
        } else if (snapshot.connectionState == ConnectionState.none) {
          return Text("No data");
        }
        return CircularProgressIndicator();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

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
                  // PP-Nama-Notif
                  Container(
                    //color: Colors.black.withOpacity(0.2),
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          textDirection: TextDirection.ltr,
                          children: [
                            SizedBox(height: 90),
                            ProfilePicture(
                              name: 'Ashel',
                              radius: 36,
                              fontsize: 20,
                              img:
                                  'https://i.pinimg.com/736x/d8/ef/ce/d8efce4fface78988c6cba03bca0fb6a.jpg',
                            ),
                          ],
                        ),

                        //Nama & Graduate
                        Container(
                          //color: Colors.red.withOpacity(0.2),
                          margin: const EdgeInsets.only(
                              right: 65, left: 85, top: 3, bottom: 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: base,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'GreycliffCF',
                                    ),
                                    children: [
                                      TextSpan(
                                          text:
                                              'Hello, ${userInfo?['username']}'),
                                    ]),
                              ),

                              //Gradute
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(99),
                                  color: lblue,
                                ),
                                child: const Text(
                                  'Fresh Graduate',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'GreycliffCF'),
                                ),
                              ),
                            ],
                          ),
                        ),

                        //Notif
                        Container(
                          //color: Colors.red.withOpacity(0.2),
                          margin: const EdgeInsets.only(
                              right: 0, left: 323, top: 5, bottom: 0),
                          child: Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: SizedBox(
                                      child: TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: bblue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(99),
                                            ),
                                          ),
                                          onPressed: () =>
                                              _showNotifications(context),
                                          child: Icon(
                                            Icons.notifications_none_outlined,
                                            color: lblue,
                                            size: 24,
                                          ))))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Search Job
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
                                  fontFamily: 'GreycliffCF'),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: InputBorder.none,
                                hintText:
                                    'Search job, company, post and others...',
                                hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                    fontFamily: 'GreycliffCF'),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(25.7),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 8),
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
                  ]),
                  const SizedBox(height: 16),

                  // Box Find Jobs
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/box.png'))),
                    child: Stack(
                      children: [
                        Container(
                          //color: Colors.red.withOpacity(0.2),
                          margin: const EdgeInsets.only(
                              right: 175, left: 25, top: 40, bottom: 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: base,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'GreycliffCF',
                                    ),
                                    children: [
                                      const TextSpan(
                                          text: "Looks Like \nYou're Open to"),
                                      TextSpan(
                                          text: ' Opportunity!',
                                          style: TextStyle(color: lblue))
                                    ]),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.all(11),
                                    fixedSize: Size(170, 0),
                                    backgroundColor: lblue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Find(),
                                        ));
                                  },
                                  child: Text(
                                    'Find Jobs',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'GreycliffCF',
                                        fontWeight: FontWeight.w600),
                                  ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Browse Jobs
                  Row(
                    children: [
                      Text(
                        'Browse Jobs',
                        style: TextStyle(
                            fontSize: 18,
                            color: base,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'GreycliffCF'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // list
                  Flexible(child: _jobVacanciesList())
                ],
              ))),
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
