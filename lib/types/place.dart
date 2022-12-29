class Place {
  // late String address;
  late String companyId;
  late String id;
  late double lat;
  late double lng;
  late String name;
  late List<dynamic> location;

  Place(
      {
      required this.companyId,
      required this.id,
      required this.lat,
      required this.lng,
      required this.location,
      required this.name});

  Place.fromJson(Map<String, dynamic> json) {
    // address = json['address'];
    companyId = json['companyId'];
    id = json['id'];
    lat = (json['lat'] as num).toDouble();
    lng = (json['lng'] as num).toDouble();
    location = json['location'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['address'] = address;
    data['companyId'] = companyId;
    return data;
  }
}
