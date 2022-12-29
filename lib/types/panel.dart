class Panel {
  late String id;
  late String name;
  late String photo;
  late int createdAt;

  Panel({
    required this.id,
    required this.name,
    required this.photo,
    required this.createdAt,
  });

  Panel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    photo = json['image'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['created_at'] = createdAt;
    return data;
  }
}
