import 'package:flutter/material.dart';

import 'package:jobilee/authentication/authen_service.dart';
import 'package:jobilee/rsc/colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Notif extends StatefulWidget {
  const Notif({super.key});

  @override
  State<Notif> createState() => _NotifState();
}

class _NotifState extends State<Notif> {
  final _supabase = Supabase.instance.client;
  final user = AuthenService().currentUser;
  List<NotificationItem> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    if (user == null) return;
    try {
      final data = await _supabase
          .from('notifications')
          .select()
          .eq('user_id', user!.uid)
          .order('datetime', ascending: false);

      setState(() {
        _notifications = (data as List)
            .map((item) => NotificationItem(
                  title: item['title'] ?? '',
                  msg: item['msg'] ?? '',
                ))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? const Center(child: Text('No notifications'))
              : RefreshIndicator(
                  onRefresh: _loadNotifications,
                  child: ListView.builder(
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final notification = _notifications[index];
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
                  ),
                ),
    );
  }
}

class NotificationItem {
  final String title;
  final String msg;

  NotificationItem({required this.title, required this.msg});
}
