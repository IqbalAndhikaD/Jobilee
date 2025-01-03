// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:jobilee/getmap.dart';
import 'package:jobilee/navbar.dart';

import 'package:jobilee/rsc/colors.dart';
import 'package:jobilee/authentication/authen_service.dart';
import 'package:jobilee/authentication/notification_service.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobilee/rsc/log.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ApplyJob extends StatefulWidget {
  final String job_id;
  const ApplyJob({super.key, required this.job_id});

  @override
  State<ApplyJob> createState() => _ApplyJobState();
}

class _ApplyJobState extends State<ApplyJob> {
  final user = AuthenService().currentUser;
  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.defaultImportance,
  );
  final _localNotifications = NotificationService().localNotifications;
  dynamic userInfo;
  dynamic job;

  Future<dynamic> getUserInfo() async {
    var result = await AuthenService().getUserInfo();
    if (result != null) {
      setState(() {
        userInfo = result;
      });
    }
  }

  Future<QuerySnapshot> _getJobTotalApplicant(
    String job_id,
  ) async {
    Query<Map<String, dynamic>> appliedJobs = FirebaseFirestore.instance
        .collection("job_applications")
        .where('job_vacation_id', isEqualTo: job_id);

    return await appliedJobs.get();
  }

  Future<void> getData() async {
    DocumentReference<Map<String, dynamic>> jobVacation = FirebaseFirestore
        .instance
        .collection("job_vacations")
        .doc(widget.job_id);

    var result = await jobVacation.get();
    AppLog.info(result);

    setState(() {
      job = result;
    });
  }

  Future<QuerySnapshot> _isJobApplied(
    String job_id,
  ) async {
    Query<Map<String, dynamic>> appliedJobs = FirebaseFirestore.instance
        .collection("job_applications")
        .where('user_id', isEqualTo: user!.uid)
        .where('job_vacation_id', isEqualTo: job_id);

    return await appliedJobs.get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getJobVacationData(
      String jobVacationId) async {
    DocumentReference<Map<String, dynamic>> jobVacations = FirebaseFirestore
        .instance
        .collection("job_vacations")
        .doc(jobVacationId);

    return jobVacations.get();
  }

  Future<void> _applyJob(
    String job_id,
    BuildContext context,
  ) async {
    CollectionReference<Map<String, dynamic>> jobApplications =
        FirebaseFirestore.instance.collection("job_applications");
    DocumentSnapshot job = await getJobVacationData(job_id);

    try {
      await jobApplications.add({
        'user_id': user!.uid,
        'job_vacation_id': job_id,
        'status': 'pending',
        'applied_at': FieldValue.serverTimestamp(),
      });
      await AuthenService().pushNotification('Job applied',
          'Job "${job.get('position')} - ${job.get('company_name')}" has been applied');
      Fluttertoast.showToast(msg: "Job Applied");
      showNotification('Job Successfully Applied', 'Job "${job.get('position')} - ${job.get('company_name')}" has been applied');
      _applyNotifications(context);
    } catch (e) {
      final errorMsg = e.toString();
      Fluttertoast.showToast(msg: errorMsg);
    }
  }

  void showNotification (String title, String body) {
    _localNotifications.show(
      0,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          icon: '@drawable/notification_icon',
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Cover Gambar Perusahaan
            buildCoverImage(job != null ? job.data()['cover_img'] : ''),

            Container(
              margin: EdgeInsets.only(top: height * 0.25),
              child: Container(
                child: SizedBox(
                  width: width,
                  child: Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 65.0),
                        child: Wrap(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    job != null
                                        ? job.data()['company_name']
                                        : '',
                                    style: const TextStyle(
                                        fontSize: 19,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'GreycliffCF'),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    job != null ? job.data()['position'] : '',
                                    style: const TextStyle(
                                        fontSize: 19,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'GreycliffCF'),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: dpurple,
                                            ),
                                            child: Text(
                                              job != null
                                                  ? job.data()['contract']
                                                  : '',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
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
                                            job != null
                                                ? job.data()['work_type']
                                                : '',
                                            style: TextStyle(
                                                color: base,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'GreycliffCF'),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      //Applicants
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.4)),
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(6),
                                                  color: ppblue,
                                                  child: Icon(
                                                    Icons.people_alt_rounded,
                                                    color: lblue,
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  FutureBuilder(
                                                      future:
                                                          _getJobTotalApplicant(
                                                              widget.job_id),
                                                      builder: (context,
                                                          AsyncSnapshot<
                                                                  QuerySnapshot>
                                                              snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .done) {
                                                          return Text(
                                                            snapshot.data!.docs
                                                                .length
                                                                .toString(),
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'GreycliffCF',
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          );
                                                        } else if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .none) {
                                                          return const Text(
                                                              "No data");
                                                        }
                                                        return const CircularProgressIndicator();
                                                      }),
                                                  const Text(
                                                    '  Applicants  ',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'GreycliffCF',
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),

                                      //Salary
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.4)),
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(6),
                                                  color: pgreen,
                                                  child: Icon(
                                                    Icons.attach_money_rounded,
                                                    color: lgreen,
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    '\$${job != null ? job.data()['salary'] : ''}',
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'GreycliffCF',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  const Text(
                                                    '  per year  ',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'GreycliffCF',
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),

                                      //Position
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.4)),
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(6),
                                                  color: pred,
                                                  child: Icon(
                                                    Icons.work_outline_rounded,
                                                    color: lred,
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    ' ${job != null ? job.data()['level'] : ''} ',
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'GreycliffCF',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  const Text(
                                                    '  Position  ',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'GreycliffCF',
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            
                            FutureBuilder(
                                future: _isJobApplied(widget.job_id),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> res) {
                                  if (res.connectionState ==
                                      ConnectionState.done) {
                                    return SizedBox(
                                      height: res.data!.docs.isEmpty
                                          ? height * 0.3
                                          : height * 0.35,
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 16, left: 44, right: 44),
                                          child: Wrap(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0),
                                                child: Wrap(children: [
                                                  Text(
                                                    'Job Description',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily:
                                                            'GreycliffCF'),
                                                  ),
                                                  SizedBox(
                                                    width: 320,
                                                    child: Text(
                                                      job != null
                                                          ? job.data()[
                                                              'description']
                                                          : '',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: base,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily:
                                                              'GreycliffCF'),
                                                      textAlign:
                                                          TextAlign.justify,
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 16),
                                                child: Wrap(children: [
                                                  Text(
                                                    'Job Responsibilities',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily:
                                                            'GreycliffCF'),
                                                  ),
                                                  SizedBox(
                                                    width: 320,
                                                    child: Text(
                                                      job != null
                                                          ? job.data()[
                                                              'responsibilities']
                                                          : '',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: base,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily:
                                                              'GreycliffCF'),
                                                      textAlign:
                                                          TextAlign.justify,
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 16),
                                                child: Wrap(children: [
                                                  Text(
                                                    'Job Responsibilities',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily:
                                                            'GreycliffCF'),
                                                  ),
                                                  SizedBox(
                                                    width: 320,
                                                    child: Text(
                                                      job != null
                                                          ? job.data()[
                                                              'responsibilities']
                                                          : '',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: base,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily:
                                                              'GreycliffCF'),
                                                      textAlign:
                                                          TextAlign.justify,
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  } else if (res.connectionState ==
                                      ConnectionState.none) {
                                    return const Text("No data");
                                  }
                                  return const CircularProgressIndicator();
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(26),
                      topRight: Radius.circular(26),
                    ),
                    color: Colors.white),
              ),
            ),

            //PP Perusahaan
            Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Positioned(
                      top: 140,
                      child: buildProfileImage(
                        job != null ? job.data()['company_img'] : '',
                      )),
                ]),

            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomLeft,
              children: [
                Positioned(
                  top: 90,
                  child: Container(
                    //color: Colors.red.withOpacity(0.2),
                    margin: const EdgeInsets.only(
                        right: 0, left: 20, top: 5, bottom: 0),
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(0),
                            child: SizedBox(
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                      minimumSize: const Size.square(13),
                                      backgroundColor: bblue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(99),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const NavBar(
                                              index: 0,
                                            ),
                                          ));
                                    },
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: lblue,
                                      size: 24,
                                    ))))
                      ],
                    ),
                  ),
                )
              ],
            ),

            // Button Apply Job
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Positioned(
                    bottom: 64,
                    child: FutureBuilder(
                        future: _isJobApplied(widget.job_id),
                        builder: (context, AsyncSnapshot<QuerySnapshot> res) {
                          if (res.connectionState == ConnectionState.done) {
                            return res.data!.docs.isEmpty
                                ? TextButton(
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.all(10),
                                      fixedSize: const Size(340, 0),
                                      backgroundColor: res.data!.docs.isEmpty
                                          ? lblue
                                          : Colors.grey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () => {
                                          if (res.data!.docs.isEmpty)
                                            {
                                              _applyJob(widget.job_id, context),
                                            }
                                        },
                                    child: const Text(
                                      'Apply Job',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'GreycliffCF',
                                          fontWeight: FontWeight.w600),
                                    ))
                                : const Text('');
                          } else if (res.connectionState ==
                              ConnectionState.none) {
                            return const Text("No data");
                          }
                          return const CircularProgressIndicator();
                        })),
              ],
            ),
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Positioned(
                  bottom: 10,
                  child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        fixedSize: const Size(340, 0),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GetMap(
                                    job_id: widget.job_id,
                                  ),
                                ))
                          },
                      child: Text(
                        'See Job Location',
                        style: TextStyle(
                            color: lblue,
                            fontFamily: 'GreycliffCF',
                            fontWeight: FontWeight.w600),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCoverImage(String img) => Container(
        color: greyb,
        child: Image.network(
          img,
          width: double.infinity,
          height: 220,
          fit: BoxFit.cover,
        ),
      );

  Widget buildProfileImage(String img) => CircleAvatar(
        radius: 60,
        backgroundColor: Colors.white,
        backgroundImage: NetworkImage(img),
      );

  Future<void> _applyNotifications(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          icon: Icon(
            Icons.task_alt_rounded,
            size: 150,
            color: lblue,
          ),
          title: const Text(
            'Job Applied Successfully',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'GreycliffCF',
                fontWeight: FontWeight.w600),
          ),
          content: const Text(
            'You can now see your application progress in application page.',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                  fixedSize: const Size(340, 0),
                  backgroundColor: lblue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NavBar(
                          index: 1,
                        ),
                      ));
                },
                child: const Text(
                  'See My Applications',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'GreycliffCF',
                      fontWeight: FontWeight.w600),
                )),
          ],
        );
      },
    );
  }
}
