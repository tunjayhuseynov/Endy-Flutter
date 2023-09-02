class Catalog {
  late String id;
  late String name;
  late String logo;
  late int createdAt;
  late int startDate;
  late int endDate;
  late String doclink;
  late dynamic companyId;
  late String status;
  late List<String> images;

  Catalog(
      {required this.id,
      required this.name,
      required this.logo,
      required this.createdAt,
      required this.images,
      required this.status,
      required this.companyId,
      required this.startDate,
      required this.endDate,
      required this.doclink});

  Catalog.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    createdAt = json['created_at'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    doclink = json['docLink'];
    companyId = json['companyId'];
    status = json['status'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['logo'] = logo;
    data['created_at'] = createdAt;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['docLink'] = doclink;
    data['companyId'] = companyId;
    data['status'] = status;
    data['images'] = images;
    return data;
  }
}
