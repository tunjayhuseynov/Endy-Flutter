class NotificationMessage {
  late String title;
  late String body;
  late String icon;
  late String topic;
  late int createdAt;
  late String? onClick;

  NotificationMessage(
      {required this.title,
      required this.body,
      required this.icon,
      required this.topic,
      this.onClick,
      required this.createdAt});

  NotificationMessage.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    icon = json['icon'];
    topic = json['topic'];
    createdAt = json['createdAt'];
    onClick = json['onClick'];
  }
}
