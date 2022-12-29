class NotificationMessage {
  late String title;
  late String body;
  late String icon;
  late String topic;
  late int createdAt;

  NotificationMessage(
      {required this.title,
      required this.body,
      required this.icon,
      required this.topic,
      required this.createdAt});

  NotificationMessage.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    icon = json['icon'];
    topic = json['topic'];
    createdAt = json['createdAt'];
  }
}
