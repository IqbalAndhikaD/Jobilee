import 'package:flutter/material.dart';

import 'package:tubes/authentication/authen_service.dart';
import 'package:tubes/rsc/colors.dart';

import 'package:firebase_database/firebase_database.dart';

class Notif extends StatefulWidget {
  const Notif({super.key});

  @override
  State<Notif> createState() => _NotifState();
}

class _NotifState extends State<Notif> {
  final user = AuthenService().currentUser;
  final notificationRef = FirebaseDatabase.instance.ref('notifications/${AuthenService().currentUser!.uid}')
      .orderByChild('datetime');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lblue,
        title: const Text(
          'Notification',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: 'GreycliffCF'),
        ),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: notificationRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;
            if (data != null) {
              final List<Notification> notifications = data.entries.map((entry) {
                final value = entry.value as Map<dynamic, dynamic>;
                return Notification(
                  title: value['title'],
                  msg: value['msg'],
                );
              }).toList();

              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Column(children: [
                    ListTile(
                      leading: Icon(
                        Icons.notifications,
                        color: yellow,
                      ),
                      title: Text(notification.title),
                      subtitle: Text(notification.msg),
                    ),
                    const Divider(height: 1, color: Colors.grey),
                  ]);
                },
              );
            } else {
              return const Center(
                child: Text('No notifications'),
              );
            }
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading notifications'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class Notification {
  final String title;
  final String msg;

  Notification(
      {required this.title, required this.msg});
}
