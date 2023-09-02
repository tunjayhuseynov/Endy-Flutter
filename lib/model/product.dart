class Product {
  late String id;
  late String name;
  late double price;
  late String description;
  late double discountedPrice;
  late dynamic discount;
  late int deadline;
  late bool isPrime;
  String? link;
  late String primaryImage;
  late List<String> images = [];
  late String companyId;
  late int createdAt = 0;

  late List<dynamic> availablePlaces = [];
  late dynamic company;
  late dynamic category;
  late dynamic subcategory;

  late int seenTimes;

  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.discountedPrice,
      required this.discount,
      required this.deadline,
      required this.isPrime,
      this.link,
      required this.company,
      required this.category,
      required this.subcategory,
      required this.primaryImage,
      required this.images,
      required this.availablePlaces,
      required this.createdAt});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = (json['price'] as num).toDouble();
    discountedPrice = (json['discountedPrice'] as num).toDouble();
    discount = json['discount'];
    deadline = json['deadline'];
    isPrime = json['isPrime'];
    link = json['link'];
    primaryImage = json['primaryImage'];
    images = json['images'].cast<String>();
    seenTimes = json['seenTimes'];

    // if (json['availablePlaces']) {
    //   availablePlaces = <Place>[];
    //   json['availablePlaces'].forEach((v) {
    //     availablePlaces.add(Place.fromJson(v));
    //   });
    // }

    availablePlaces = json['availablePlaces'];
    description = json['description'];
    company = json['company'];
    companyId = json['companyId'];
    category = json['category'];
    subcategory = json['subcategory'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['discountedPrice'] = discountedPrice;
    data['discount'] = discount;
    data['isPrime'] = isPrime;
    data['deadline'] = deadline;
    data['link'] = link;
    data['primaryImage'] = primaryImage;
    data['images'] = images;
    data['availablePlaces'] = availablePlaces.map((v) => v.toJson()).toList();
    data['company'] = company;
    data['companyId'] = companyId;
    data['category'] = category;
    data['subcategory'] = subcategory;
    data['created_at'] = createdAt;
    data['seenTimes'] = seenTimes;
    return data;
  }
}
