import 'package:flutter/material.dart';
import 'package:tubes/applyjob.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

import 'package:tubes/authentication/authen_service.dart';
import 'package:tubes/notification.dart';
import 'package:tubes/rsc/colors.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Apply extends StatefulWidget {
  const Apply({super.key});

  @override
  State<Apply> createState() => _ApplyState();
}

class _ApplyState extends State<Apply> {
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
    // where user_id == user.uid
    Query<Map<String, dynamic>> jobApplications = FirebaseFirestore.instance
        .collection("job_applications")
        .where('user_id', isEqualTo: user!.uid);

    return jobApplications.get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getJobVacationData(
      String jobVacationId) async {
    DocumentReference<Map<String, dynamic>> jobVacations = FirebaseFirestore
        .instance
        .collection("job_vacations")
        .doc(jobVacationId);

    return jobVacations.get();
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.blueAccent;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusBGColor(String status) {
    switch (status) {
      case 'pending':
        return const Color(0xFFC0D5FF);
      case 'accepted':
        return const Color(0xFFC0FFD5);
      case 'rejected':
        return const Color(0xFFFFC0C0);
      default:
        return const Color(0xFFC3C3C3);
    }
  }

  Widget _jobApplicationsList() {
    return FutureBuilder(
      future: getData(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView(
            children: snapshot.data!.docs
                .map((doc) => FutureBuilder(
                    future: getJobVacationData(doc.get('job_vacation_id')),
                    builder: (context, AsyncSnapshot<DocumentSnapshot> res) {
                      if (res.connectionState == ConnectionState.done) {
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
                                    child: Image(
                                      image: NetworkImage(
                                        res.data!.get('company_img'),
                                      ),
                                      height: 35,
                                      width: 35,
                                    ),
                                  ),
                                  Flexible(
                                    child: ListTile(
                                        title: Text(
                                          res.data!.get('position'),
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
                                              res.data!.get('company_name'),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: base,
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily: 'GreycliffCF'),
                                            ),
                                            const SizedBox(height: 6),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: _getStatusBGColor(
                                                    doc.get('status')),
                                              ),
                                              child: Text(
                                                doc.get('status'),
                                                style: TextStyle(
                                                    color: _getStatusTextColor(
                                                        doc.get('status')),
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'GreycliffCF'),
                                              ),
                                            )
                                          ],
                                        ),
                                        trailing: Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          alignment: WrapAlignment.spaceBetween,
                                          direction: Axis.horizontal,
                                          children: [
                                            Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8),
                                                  child: TextButton(
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: lblue,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      minimumSize: const Size(60, 0),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    ApplyJob(job_id: doc.get(
                                                                        'job_vacation_id')),
                                                          ));
                                                    },
                                                    child: const Text(
                                                      'See Details',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'GreycliffCF',
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        )),
                                  )
                                ],
                              ),
                            ));
                      } else if (snapshot.connectionState ==
                          ConnectionState.none) {
                        return const Text("No data");
                      }
                      return const CircularProgressIndicator();
                    }))
                .toList(),
          );
        } else if (snapshot.connectionState == ConnectionState.none) {
          return const Text("No data");
        }
        return const CircularProgressIndicator();
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
      body: SafeArea(
          child: Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // PP-Nama-Notif
                  SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        //PP/ava
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          textDirection: TextDirection.ltr,
                          children: [
                            const SizedBox(height: 90),
                            ProfilePicture(
                              name: userInfo?['username'] ?? '',
                              radius: 36,
                              fontsize: 20,
                              img: userInfo?['profile_pic'] ?? '',
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
                                              'Hello, ${userInfo?['username'] ?? ''}')
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
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => const Notif(),
                                                ));
                                          },
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
                  Flexible(child: _jobApplicationsList())
                ],
              ))),
    );
  }

}