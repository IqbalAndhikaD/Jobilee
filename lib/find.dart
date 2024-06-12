import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:tubes/applyjob.dart';

import 'package:tubes/authentication/authen_service.dart';
import 'package:tubes/notification.dart';
import 'package:tubes/rsc/colors.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Find extends StatefulWidget {
  const Find({super.key});

  @override
  State<Find> createState() => _FindState();
}

class _FindState extends State<Find> {
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
                .map((doc) => searchJob(doc, search) ||
                        search == ''
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
                                        FutureBuilder(
                                          future: _getJobTotalApplicant(doc.id),
                                          builder: (context,
                                              AsyncSnapshot<QuerySnapshot> res) {
                                            if (res.connectionState ==
                                                ConnectionState.done) {
                                              return Text(
                                                '${res.data!.docs.length} Applicants',
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.normal,
                                                    fontFamily: 'GreycliffCF'),
                                              );
                                            } else if (snapshot.connectionState ==
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
                                                    style: const TextStyle(
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
                                              child: FutureBuilder(
                                                  future: _isJobApplied(doc.id),
                                                  builder: (context,
                                                      AsyncSnapshot<QuerySnapshot>
                                                          res) {
                                                    if (res.connectionState ==
                                                        ConnectionState.done) {
                                                      return TextButton(
                                                        style: TextButton.styleFrom(
                                                          backgroundColor:
                                                              res.data!.docs.isEmpty
                                                                  ? lblue
                                                                  : Colors.grey,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(20),
                                                          ),
                                                          minimumSize: const Size(60, 0),
                                                        ),
                                                        onPressed: () {
                                                          if (res
                                                              .data!.docs.isEmpty) {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ApplyJob(job_id: doc.id),
                                                                ));
                                                          }
                                                        },
                                                        child: Text(
                                                          res.data!.docs.isEmpty
                                                              ? 'Apply'
                                                              : 'Applied',
                                                          style: const TextStyle(
                                                              color: Colors.white,
                                                              fontFamily:
                                                                  'GreycliffCF',
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight.w600),
                                                        ),
                                                      );
                                                    } else if (snapshot
                                                            .connectionState ==
                                                        ConnectionState.none) {
                                                      return const Text("No data");
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
                                              child: IconButton(
                                                icon: FutureBuilder(
                                                    future: _isJobSaved(doc.id),
                                                    builder: (context,
                                                        AsyncSnapshot<QuerySnapshot>
                                                            res) {
                                                      if (res.connectionState ==
                                                          ConnectionState.done) {
                                                        return Icon(res.data!.docs
                                                                .isNotEmpty
                                                            ? Icons.bookmark
                                                            : Icons
                                                                .bookmark_border_outlined);
                                                      } else if (snapshot
                                                              .connectionState ==
                                                          ConnectionState.none) {
                                                        return const Text("No data");
                                                      }
                                                      return const CircularProgressIndicator();
                                                    }),
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
                        )) : Text(''))
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

    return Scaffold(
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

                  const SizedBox(height: 24),

                  // Browse Jobs
                  Row(
                    children: [
                      Text(
                        'Find Jobs',
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
