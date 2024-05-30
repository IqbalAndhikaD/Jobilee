import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:tubes/rsc/colors.dart';

class Apply extends StatefulWidget {
  const Apply({super.key});

  @override
  State<Apply> createState() => _ApplyState();
}

class _ApplyState extends State<Apply> {
  int myIndex = 0;
  List<Widget> widgetList = const [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // PP-Nama-Notif
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        //PP/ava
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
                                      const TextSpan(text: "Hello, Ashel"),
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

                  const SizedBox(height: 24),

                  // Browse Jobs
                  Row(
                    children: [
                      Text(
                        'My Applications',
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
                  Flexible(
                    child: ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Card(
                            color: Colors.white,
                            elevation: 0,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey[200],
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: const Image(
                                      image:
                                          AssetImage('assets/images/tesla.png'),
                                      height: 35,
                                      width: 35,
                                    ),
                                  ),
                                  Flexible(
                                    child: ListTile(
                                        title: Text(
                                          'Product Manager',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: base,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'GreycliffCF'),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Tesla',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: base,
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
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8,
                                                          vertical: 4),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                        color: pblue,
                                                      ),
                                                      child: const Text(
                                                        'Pending',
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 9,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'GreycliffCF'),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        trailing: TextButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor: lblue,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                            onPressed: () {},
                                            child: Text(
                                              'See Details',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'GreycliffCF',
                                                  fontSize: 8.5,
                                                  fontWeight: FontWeight.w600),
                                            ))),
                                  )
                                ],
                              ),
                            ));
                      },
                    ),
                  )
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
