// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:jobilee/authentication/notification_service.dart';
import 'package:jobilee/getmap.dart';
import 'package:jobilee/navbar.dart';
import 'package:jobilee/rsc/colors.dart';
import 'package:jobilee/authentication/authen_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jobilee/services/job_service.dart';
import 'package:jobilee/rsc/log.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ApplyJob extends StatefulWidget {
  final String job_vacation_id;
  const ApplyJob({super.key, required this.job_vacation_id});

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
  Map<String, dynamic>? job;

  Future<dynamic> getUserInfo() async {
    var result = await AuthenService().getUserInfo();
    if (result != null) {
      setState(() {
        userInfo = result;
      });
    }
  }

  Future<int> _getJobTotalApplicant(String jobId) async {
    return JobService.getJobApplicantCount(jobId);
  }

  Future<void> getData() async {
    final result = await JobService.getJobById(widget.job_vacation_id);
    AppLog.info(result);
    AppLog.info('LOGO URL: ${result?['logo']}');
    setState(() {
      job = result;
    });
  }

  Future<bool> _isJobApplied(String jobId) async {
    return JobService.isJobApplied(user!.uid, jobId);
  }

  Future<void> _applyJob(String jobId, BuildContext context) async {
    try {
      final success = await JobService.applyJob(user!.uid, jobId);
      if (success) {
        await AuthenService().pushNotification(
            'Job applied',
            'Job "${job?['title'] ?? ''} - ${job?['company'] ?? ''}" has been applied');
        Fluttertoast.showToast(msg: "Job Applied");
        showNotification(
            'Job Successfully Applied',
            'Job "${job?['title'] ?? ''} - ${job?['company'] ?? ''}" has been applied');
        _applyNotifications(context);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void showNotification(String title, String body) {
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
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Stack(
        children: [
          // ── Banner cover perusahaan ──
          SizedBox(
            height: height * 0.30,
            width: double.infinity,
            child: job != null &&
                    (job!['cover_img'] ?? '').toString().isNotEmpty
                ? Image.network(
                    job!['cover_img'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: greyb,
                        child: const Center(
                            child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (_, __, ___) =>
                        Container(color: greyb),
                  )
                : Container(color: greyb),
          ),

          // ── Konten putih (card rounded + full height) ──
          Container(
            margin: EdgeInsets.only(
                top: height * 0.27), // sedikit overlap cover agar rounded terlihat
            height: height - height * 0.27,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(26),
                  topRight: Radius.circular(26),
                ),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: 70,       // ruang untuk logo yang overlap
                  bottom: 150,   // ruang untuk tombol Apply & See Location
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ── Info perusahaan & jabatan ──
                    Text(
                      job?['company'] ?? '',
                      style: const TextStyle(
                        fontSize: 19,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'GreycliffCF',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      job?['title'] ?? '',
                      style: const TextStyle(
                        fontSize: 19,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'GreycliffCF',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // ── Badge lokasi ──
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: dpurple,
                      ),
                      child: Text(
                        job?['location'] ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'GreycliffCF',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Card Applicants & Salary ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Applicants
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 4),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.4)),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    color: ppblue,
                                    child: Icon(
                                        Icons.people_alt_rounded,
                                        color: lblue),
                                  ),
                                ),
                                Column(
                                  children: [
                                    FutureBuilder(
                                      future: _getJobTotalApplicant(
                                          widget.job_vacation_id),
                                      builder: (context,
                                          AsyncSnapshot<int> snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          return Text(
                                            snapshot.data.toString(),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'GreycliffCF',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          );
                                        } else if (snapshot
                                                .connectionState ==
                                            ConnectionState.none) {
                                          return const Text("No data");
                                        }
                                        return const CircularProgressIndicator();
                                      },
                                    ),
                                    const Text(
                                      '  Applicants  ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'GreycliffCF',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Salary
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 4),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.4)),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    color: pgreen,
                                    child: Icon(
                                        Icons.attach_money_rounded,
                                        color: lgreen),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '\$${job?['salary'] ?? ''}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'GreycliffCF',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Text(
                                      '  per year  ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'GreycliffCF',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ── Job Description ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 44),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Job Description',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'GreycliffCF',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            job?['description'] ?? '',
                            style: TextStyle(
                              fontSize: 12,
                              color: base,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'GreycliffCF',
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Logo perusahaan (overlap cover & card) ──
          if (job != null)
            Positioned(
              top: height * 0.27 - 60,
              left: 0,
              right: 0,
              child: Center(
                child: buildLogoImage(
                  (job != null &&
                          (job!['logo'] ?? '').toString().isNotEmpty)
                      ? job!['logo'].toString().trim()
                      : '',
                ),
              ),
            ),

          // ── Back button ──
          Positioned(
            top: statusBarHeight + 10,
            left: 20,
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
                      builder: (context) => const NavBar(index: 0),
                    ));
              },
              child: Icon(Icons.arrow_back, color: lblue, size: 24),
            ),
          ),

          // ── Button Apply Job ──
          Positioned(
            bottom: 64,
            left: 0,
            right: 0,
            child: Center(
              child: FutureBuilder<bool>(
                future: _isJobApplied(widget.job_vacation_id),
                builder: (context, res) {
                  if (res.connectionState == ConnectionState.done) {
                    return (res.data == false)
                        ? TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(10),
                              fixedSize: const Size(340, 0),
                              backgroundColor: lblue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              _applyJob(
                                  widget.job_vacation_id, context);
                            },
                            child: const Text(
                              'Apply Job',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'GreycliffCF',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : const SizedBox.shrink();
                  } else if (res.connectionState ==
                      ConnectionState.none) {
                    return const Text("No data");
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
          ),

          // ── Button See Job Location ──
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                  fixedSize: const Size(340, 0),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GetMap(
                      job_vacation_id: widget.job_vacation_id,
                    ),
                  ),
                ),
                child: Text(
                  'See Job Location',
                  style: TextStyle(
                    color: lblue,
                    fontFamily: 'GreycliffCF',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Logo perusahaan ──
  Widget buildLogoImage(String imgUrl) {
    if (imgUrl.isEmpty) {
      return CircleAvatar(
        radius: 60,
        backgroundColor: Colors.white,
        child: const Icon(Icons.business, size: 60, color: Colors.grey),
      );
    }
    return CircleAvatar(
      radius: 60,
      backgroundColor: Colors.white,
      child: ClipOval(
        child: Image.network(
          imgUrl,
          width: 110,
          height: 110,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(strokeWidth: 2),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Logo load error: $error | URL: $imgUrl');
            return const Icon(Icons.business,
                size: 60, color: Colors.grey);
          },
        ),
      ),
    );
  }

  Future<void> _applyNotifications(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          icon: Icon(Icons.task_alt_rounded, size: 150, color: lblue),
          title: const Text(
            'Job Applied Successfully',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'GreycliffCF',
              fontWeight: FontWeight.w600,
            ),
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
                      builder: (context) => const NavBar(index: 1),
                    ));
              },
              child: const Text(
                'See My Applications',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'GreycliffCF',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}