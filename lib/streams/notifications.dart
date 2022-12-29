import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endy/types/notification.dart';

class NotificationCrud {
  static Future<NotificationMessage> getNotification(String id) async {
    final notificationData = await FirebaseFirestore.instance
        .collection('notifications')
        .doc(id)
        .get();

    final data = notificationData.data();
    if (data == null) throw Exception('Notification not found');

    NotificationMessage notification = NotificationMessage.fromJson(data);
    return notification;
  }

  static Future<List<NotificationMessage>> getNotifications(
      List<String> topics) async {
    final notifications = await FirebaseFirestore.instance
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .where("topic", whereIn: [...topics, "all"]).get();
    return notifications.docs.map((doc) {
      final notification = NotificationMessage.fromJson(doc.data());
      return notification;
    }).toList();
  }
}
