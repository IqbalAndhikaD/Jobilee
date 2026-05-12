import 'package:flutter/material.dart';
import 'package:jobilee/applyjob.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:jobilee/authentication/authen_service.dart';
import 'package:jobilee/notification.dart';
import 'package:jobilee/rsc/colors.dart';
import 'package:jobilee/services/job_service.dart';

class Apply extends StatefulWidget {
  const Apply({super.key});

  @override
  State<Apply> createState() => _ApplyState();
}

class _ApplyState extends State<Apply> {
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
    return JobService.getMyApplications(user!.uid);
  }

  bool searchJobData(Map<String, dynamic>? job, String? search) {
    if (job == null) return false;
    if (search != null && search.isNotEmpty) {
      return (job['company'] ?? '').toLowerCase().contains(search) ||     // ✅ was: company_name
          (job['title'] ?? '').toLowerCase().contains(search) ||           // ✅ was: position
          (job['location'] ?? '').toLowerCase().contains(search);          // ✅ was: contract
    }
    return true;
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

  Widget _jobApplicationsList(String? search) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final applications = snapshot.data ?? [];
          return ListView(
            children: applications.map((appRow) {
              final jobId = appRow['job_id'] as String; // ✅ was: job_vacation_id
              return FutureBuilder<Map<String, dynamic>?>(
                future: JobService.getJobById(jobId),
                builder: (context, res) {
                  if (res.connectionState == ConnectionState.done) {
                    final job = res.data;
                    if (job == null || !searchJobData(job, search))
                      return Container();
                    return Card(
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
                                job['logo'] ?? '', // ✅ was: company_img — online URL from DB
                                height: 35,
                                width: 35,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.business, size: 35),
                              ),
                            ),
                            Flexible(
                              child: ListTile(
                                title: Text(job['title'] ?? '',  // ✅ was: position
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: base,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'GreycliffCF')),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(job['company'] ?? '',  // ✅ was: company_name
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: base,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'GreycliffCF')),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: _getStatusBGColor(
                                            appRow['status'] ?? ''),
                                      ),
                                      child: Text(
                                        appRow['status'] ?? '',
                                        style: TextStyle(
                                            color: _getStatusTextColor(
                                                appRow['status'] ?? ''),
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'GreycliffCF'),
                                      ),
                                    )
                                  ],
                                ),
                                trailing: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: lblue,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      minimumSize: const Size(60, 0),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ApplyJob(
                                                job_vacation_id: jobId),
                                          ));
                                    },
                                    child: const Text('See Details',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'GreycliffCF',
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const LinearProgressIndicator();
                },
              );
            }).toList(),
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

                              //Graduate
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
                                                  builder: (context) =>
                                                      const Notif(),
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
                                    'Search job, company, location and others...',
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

                  // My Applications Title
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

                  Padding(
                      padding: EdgeInsets.only(top: searchVal != '' ? 7 : 0),
                      child: searchVal != ''
                          ? Row(children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4),
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
                                      borderRadius: BorderRadius.circular(4),
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
                  Flexible(child: _jobApplicationsList(searchVal))
                ],
              ))),
    );
  }
}