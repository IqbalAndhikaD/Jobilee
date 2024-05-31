import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tubes/rsc/colors.dart';

class Notif extends StatefulWidget {
  const Notif({super.key});

  @override
  State<Notif> createState() => _NotifState();
}

class _NotifState extends State<Notif> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lblue,
        title: Text(
          'Notification',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: 'GreycliffCF'),
        ),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Column(
            children: [
              ListTile(
                leading: Icon(Icons.notifications, color: yellow,),
                title: Text(
                  notification.title,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'GreycliffCF'),
                ),
                subtitle: Text(
                  notification.message,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'GreycliffCF'),
                ),
                trailing: Text(
                  notification.date,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'GreycliffCF'),
                ),
              ),
              Divider(height: 1, color: Colors.grey), // Add a divider here
            ],
          );
        },
      ),
    );
  }
}

class Notification {
  final String title;
  final String message;
  final String date;

  Notification(
      {required this.title, required this.message, required this.date});
}

final notifications = [
  Notification(
      title: 'New Message', message: 'You have a new message', date: 'Today'),
  
  Notification(
      title: 'New Message', message: 'You have a new message', date: 'Today'),
];
