// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:jobilee/applyjob.dart';
import 'package:jobilee/find.dart';
import 'package:jobilee/navbar.dart';
import 'package:jobilee/notification.dart';
import 'package:jobilee/rsc/colors.dart';

import 'package:jobilee/authentication/authen_service.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/foundation.dart';
import 'package:jobilee/rsc/log.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int myIndex = 0;
  List<Widget> widgetList = const [];
  String searchVal = "";

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

  Future<DocumentSnapshot<Map<String, dynamic>>> getJobVacationData(
      String jobVacationId) async {
    DocumentReference<Map<String, dynamic>> jobVacations = FirebaseFirestore
        .instance
        .collection("job_vacations")
        .doc(jobVacationId);

    return jobVacations.get();
  }

  Future<QuerySnapshot> _getJobTotalApplicant(
    String jobId,
  ) async {
    Query<Map<String, dynamic>> appliedJobs = FirebaseFirestore.instance
        .collection("job_applications")
        .where('job_vacation_id', isEqualTo: jobId);

    return await appliedJobs.get();
  }

  Future<QuerySnapshot> _isJobApplied(
    String jobId,
  ) async {
    Query<Map<String, dynamic>> appliedJobs = FirebaseFirestore.instance
        .collection("job_applications")
        .where('user_id', isEqualTo: user!.uid)
        .where('job_vacation_id', isEqualTo: jobId);

    return await appliedJobs.get();
  }

  Future<QuerySnapshot> _isJobSaved(
    String jobId,
  ) async {
    Query<Map<String, dynamic>> savedJobs = FirebaseFirestore.instance
        .collection("job_saved")
        .where('user_id', isEqualTo: user!.uid)
        .where('job_vacation_id', isEqualTo: jobId);

    return await savedJobs.get();
  }

  Future<void> _saveJob(
    String jobId,
  ) async {
    CollectionReference savedJobs =
        FirebaseFirestore.instance.collection("job_saved");
    QuerySnapshot res = await _isJobSaved(jobId);
    DocumentSnapshot job = await getJobVacationData(jobId);

    try {
      if (res.docs.isNotEmpty) {
        await savedJobs.doc(res.docs[0].id).delete();
        await AuthenService().pushNotification('Job successfully unsaved',
            'Job "${job.get('position')} - ${job.get('company_name')}" has been unsaved');
        Fluttertoast.showToast(msg: "Job Unsaved");
      } else {
        await savedJobs.add({
          'user_id': user!.uid,
          'job_vacation_id': jobId,
        });
        await AuthenService().pushNotification('Job successfully saved',
            'Job "${job.get('position')} - ${job.get('company_name')}" has been saved');
        Fluttertoast.showToast(msg: "Job Saved");
      }
    } catch (e) {
      final errorMsg = e.toString();
      Fluttertoast.showToast(msg: errorMsg);
    }
  }

  bool searchJob(QueryDocumentSnapshot<Object?> job, String? search) {
    if (search != null) {
      return job!.get('company_name').toLowerCase().contains(search) ||
          job!.get('position').toLowerCase().contains(search) ||
          job!.get('contract').toLowerCase().contains(search);
    }

    return false;
  }

  Widget _jobVacanciesList(String? search) {
    return FutureBuilder(
      future: getData(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView(
            children: snapshot.data!.docs
                .map((doc) => searchJob(doc, search) || search == ''
                    ? Card(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          doc.get('company_name'),
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: base,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: 'GreycliffCF'),
                                        ),
                                        FutureBuilder(
                                            future:
                                                _getJobTotalApplicant(doc.id),
                                            builder: (context,
                                                AsyncSnapshot<QuerySnapshot>
                                                    res) {
                                              if (res.connectionState ==
                                                  ConnectionState.done) {
                                                return Text(
                                                  '${res.data!.docs.length} Applicants',
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontFamily:
                                                          'GreycliffCF'),
                                                );
                                              } else if (res.connectionState ==
                                                  ConnectionState.none) {
                                                return const Text("No data");
                                              }
                                              return const CircularProgressIndicator();
                                            }),
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
                                                        BorderRadius.circular(
                                                            4),
                                                    color: dpurple,
                                                  ),
                                                  child: Text(
                                                    doc.get('contract'),
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 9,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'GreycliffCF'),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          'GreycliffCF'),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
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
                                              padding: const EdgeInsets.only(
                                                  right: 8),
                                              child: FutureBuilder(
                                                  future: _isJobApplied(doc.id),
                                                  builder: (context,
                                                      AsyncSnapshot<
                                                              QuerySnapshot>
                                                          res) {
                                                    if (res.connectionState ==
                                                        ConnectionState.done) {
                                                      return TextButton(
                                                        style: TextButton
                                                            .styleFrom(
                                                          backgroundColor: res
                                                                  .data!
                                                                  .docs
                                                                  .isEmpty
                                                              ? lblue
                                                              : Colors.grey,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          minimumSize:
                                                              const Size(60, 0),
                                                        ),
                                                        onPressed: () {
                                                          if (res.data!.docs
                                                              .isEmpty) {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ApplyJob(
                                                                    job_id:
                                                                        doc.id,
                                                                  ),
                                                                ));
                                                          }
                                                        },
                                                        child: Text(
                                                          res.data!.docs.isEmpty
                                                              ? 'Apply'
                                                              : 'Applied',
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'GreycliffCF',
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      );
                                                    } else if (snapshot
                                                            .connectionState ==
                                                        ConnectionState.none) {
                                                      return const Text(
                                                          "No data");
                                                    }
                                                    return const CircularProgressIndicator();
                                                  }),
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
                                                child: FutureBuilder(
                                                    future: _isJobSaved(doc.id),
                                                    builder: (context,
                                                        AsyncSnapshot<
                                                                QuerySnapshot>
                                                            res) {
                                                      if (res.connectionState ==
                                                          ConnectionState
                                                              .done) {
                                                        return IconButton(
                                                            icon: Icon(res
                                                                    .data!
                                                                    .docs
                                                                    .isNotEmpty
                                                                ? Icons.bookmark
                                                                : Icons
                                                                    .bookmark_border_outlined),
                                                            color: lblue,
                                                            iconSize: 20,
                                                            onPressed:
                                                                () async {
                                                              await _saveJob(
                                                                  doc.id);
                                                              setState(() {});
                                                            });
                                                      } else if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .none) {
                                                        return const Text(
                                                            "No data");
                                                      }
                                                      return const CircularProgressIndicator();
                                                    })),
                                          ],
                                        ),
                                      ],
                                    )),
                              )
                            ],
                          ),
                        ))
                    : Text(''))
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
    final TextEditingController _search = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    @override
    void initState() {
      super.initState();
    }

    return Scaffold(
      // appBar: AppBar(actions: [

      // ],),
      body: SafeArea(
          child: Form(
              key: _formKey,
              child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      // PP-Nama-Notif
                      SizedBox(
                        //color: Colors.black.withOpacity(0.2),
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: [
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
                                                  'Hello, ${userInfo?['username'] ?? ''}'),
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
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const Notif(),
                                                    ));
                                              },
                                              child: Icon(
                                                Icons
                                                    .notifications_none_outlined,
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
                                child: TextFormField(
                                  controller: _search,
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
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 24),
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
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    searchVal = _search.text;
                                  });
                                },
                                child: Icon(
                                  Icons.search,
                                  color: bblue,
                                ),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.all(9),
                                  backgroundColor: lblue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(999),
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
                        decoration: const BoxDecoration(
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
                                              text:
                                                  "Looks Like \nYou're Open to"),
                                          TextSpan(
                                              text: ' Opportunity!',
                                              style: TextStyle(color: lblue))
                                        ]),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextButton(
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.all(11),
                                        fixedSize: const Size(170, 0),
                                        backgroundColor: lblue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const Find(),
                                            ));
                                      },
                                      child: const Text(
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
                            "Browse Jobs",
                            style: TextStyle(
                                fontSize: 18,
                                color: base,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'GreycliffCF'),
                          ),
                        ],
                      ),

                      Padding(
                          padding:
                              EdgeInsets.only(top: searchVal != '' ? 7 : 0),
                          child: searchVal != ''
                              ? Row(children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 4),
                                        child: Text(
                                          'Search Result:',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: base,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'GreycliffCF'),
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: bblue,
                                        ),
                                        child: Text(
                                          searchVal,
                                          style: TextStyle(
                                              color: lblue,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'GreycliffCF'),
                                        ),
                                      )
                                    ],
                                  ),
                                ])
                              : null),

                      const SizedBox(height: 12),

                      // list
                      Flexible(child: _jobVacanciesList(searchVal))
                    ],
                  )))),
    );
  }
}
