import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:jobilee/applyjob.dart';
import 'package:jobilee/authentication/authen_service.dart';
import 'package:jobilee/notification.dart';
import 'package:jobilee/rsc/colors.dart';
import 'package:jobilee/services/job_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  Future<List<Map<String, dynamic>>> getData() async {
    return JobService.getAllJobs();
  }

  Future<int> _getJobTotalApplicant(String jobId) async {
    return JobService.getJobApplicantCount(jobId);
  }

  Future<bool> _isJobApplied(String jobId) async {
    return JobService.isJobApplied(user!.uid, jobId);
  }

  Future<bool> _isJobSaved(String jobId) async {
    return JobService.isJobSaved(user!.uid, jobId);
  }

  Future<void> _saveJob(String jobId) async {
    final job = await JobService.getJobById(jobId);
    final isSaved = await _isJobSaved(jobId);
    if (isSaved) {
      await JobService.unsaveJob(user!.uid, jobId);
      await AuthenService().pushNotification('Job successfully unsaved',
          'Job "${job?['title']} - ${job?['company']}" has been unsaved');
      Fluttertoast.showToast(msg: "Job Unsaved");
    } else {
      await JobService.saveJob(user!.uid, jobId);
      await AuthenService().pushNotification('Job successfully saved',
          'Job "${job?['title']} - ${job?['company']}" has been saved');
      Fluttertoast.showToast(msg: "Job Saved");
    }
  }

  bool searchJob(Map<String, dynamic> job, String? search) {
    if (search != null && search.isNotEmpty) {
      return (job['company'] ?? '').toLowerCase().contains(search) ||
          (job['title'] ?? '').toLowerCase().contains(search) ||
          (job['location'] ?? '').toLowerCase().contains(search);
    }
    return true;
  }

  Widget _jobVacanciesList(String? search) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final jobs = (snapshot.data ?? [])
              .where((doc) => searchJob(doc, search))
              .toList();
          return ListView(
            children: jobs
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
                                  color: Colors.grey[200]),
                              padding: const EdgeInsets.all(8),
                              child: Image.network(
                                  doc['logo'] ?? '',
                                  height: 35,
                                  width: 35,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.business, size: 35)),
                            ),
                            Flexible(
                              child: ListTile(
                                title: Text(doc['title'] ?? '',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: base,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'GreycliffCF')),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(doc['company'] ?? '',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: base,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'GreycliffCF')),
                                    FutureBuilder<int>(
                                      future: _getJobTotalApplicant(doc['id']),
                                      builder: (context, res) {
                                        if (res.connectionState ==
                                            ConnectionState.done) {
                                          return Text(
                                              '${res.data ?? 0} Applicants',
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey,
                                                  fontFamily: 'GreycliffCF'));
                                        }
                                        return const SizedBox(
                                            height: 10,
                                            width: 10,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 1));
                                      },
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: dpurple),
                                          child: Text(doc['contract'] ?? '',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'GreycliffCF')),
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
                                                color: yellow),
                                            child: Text(doc['work_type'] ?? '',
                                                style: TextStyle(
                                                    color: base,
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'GreycliffCF')),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    FutureBuilder<bool>(
                                      future: _isJobApplied(doc['id']),
                                      builder: (context, res) {
                                        final applied = res.data ?? false;
                                        if (res.connectionState ==
                                            ConnectionState.done) {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                backgroundColor: !applied
                                                    ? lblue
                                                    : Colors.grey,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                minimumSize: const Size(60, 0),
                                              ),
                                              onPressed: () {
                                                if (!applied)
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ApplyJob(
                                                                  job_vacation_id:
                                                                      doc['id'])));
                                              },
                                              child: Text(
                                                  !applied
                                                      ? 'Apply'
                                                      : 'Applied',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'GreycliffCF',
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            ),
                                          );
                                        }
                                        return const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2));
                                      },
                                    ),
                                    FutureBuilder<bool>(
                                      future: _isJobSaved(doc['id']),
                                      builder: (context, res) {
                                        final saved = res.data ?? false;
                                        if (res.connectionState ==
                                            ConnectionState.done) {
                                          return Ink(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: bblue),
                                            child: IconButton(
                                              icon: Icon(saved
                                                  ? Icons.bookmark
                                                  : Icons
                                                      .bookmark_border_outlined),
                                              color: lblue,
                                              iconSize: 20,
                                              onPressed: () async {
                                                await _saveJob(doc['id']);
                                                setState(() {});
                                              },
                                            ),
                                          );
                                        }
                                        return const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          );
        }
        return const Center(child: CircularProgressIndicator());
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
    final TextEditingController search = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: SafeArea(
          child: Form(
              key: formKey,
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
                                  controller: search,
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
                                    searchVal = search.text;
                                  });
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(9),
                                  backgroundColor: lblue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                ),
                                child: Icon(
                                  Icons.search,
                                  color: bblue,
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
