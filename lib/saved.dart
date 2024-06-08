import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

import 'package:tubes/authentication/authen_service.dart';
import 'package:tubes/notification.dart';
import 'package:tubes/rsc/colors.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Saved extends StatefulWidget {
  const Saved({super.key});

  @override
  State<Saved> createState() => _SavedState();
}

class _SavedState extends State<Saved> {
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
    Query<Map<String, dynamic>> jobSaved = FirebaseFirestore.instance
        .collection("job_saved")
        .where('user_id', isEqualTo: user!.uid);

    return jobSaved.get();
  }


  Future<DocumentSnapshot<Map<String, dynamic>>> getJobVacationData(
      String jobVacationId) async {
    DocumentReference<Map<String, dynamic>> jobVacations = FirebaseFirestore
        .instance
        .collection("job_vacations")
        .doc(jobVacationId);

    return jobVacations.get();
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
        await AuthenService().pushNotification('Job successfully unsaved', 'Job "${job.get('position')} - ${job.get('company_name')}" has been unsaved');
        Fluttertoast.showToast(msg: "Job Unsaved");
      } else {
        await savedJobs.add({
          'user_id': user!.uid,
          'job_vacation_id': jobId,
        });
        await AuthenService().pushNotification('Job successfully saved', 'Job "${job.get('position')} - ${job.get('company_name')}" has been saved');
        Fluttertoast.showToast(msg: "Job Saved");
      }
    } catch (e) {
      final errorMsg = e.toString();
      Fluttertoast.showToast(msg: errorMsg);
    }
  }

  Widget _savedJobsList() {
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
                                          res.data!.get('company_img')),
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
                                                        color: dpurple,
                                                      ),
                                                      child: Text(
                                                        res.data!
                                                            .get('contract'),
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
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 4),
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      color: yellow,
                                                    ),
                                                    child: Text(
                                                      res.data!
                                                          .get('work_type'),
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
                                                Ink(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: bblue,
                                                  ),
                                                  child: IconButton(
                                                      icon: FutureBuilder(
                                                          future: _isJobSaved(
                                                              doc.get(
                                                                  'job_vacation_id')),
                                                          builder: (context,
                                                              AsyncSnapshot<
                                                                      QuerySnapshot>
                                                                  res) {
                                                            if (res.connectionState ==
                                                                ConnectionState
                                                                    .done) {
                                                              return Icon(res
                                                                      .data!
                                                                      .docs
                                                                      .isNotEmpty
                                                                  ? Icons
                                                                      .bookmark
                                                                  : Icons
                                                                      .bookmark_border_outlined);
                                                            } else if (snapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .none) {
                                                              return const Text(
                                                                  "No data");
                                                            }
                                                            return const CircularProgressIndicator();
                                                          }),
                                                      color: lblue,
                                                      iconSize: 20,
                                                      onPressed: () async {
                                                        await _saveJob(doc.get(
                                                            'job_vacation_id'));
                                                        setState(() {});
                                                      }),
                                                ),
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
                        //profile
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
                        'Saved Jobs',
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
                  Flexible(child: _savedJobsList())
                ],
              ))),
    );
  }
}
