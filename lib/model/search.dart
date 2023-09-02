class SearchHit {
  final String objectID;
  final String name;
  final String primaryImage;
  final dynamic discount;
  final dynamic price;
  final dynamic discountedPrice;
  final dynamic deadline;
  final String company;
  final String category;
  final String subcategory;
  final dynamic created_at;

  SearchHit(
      this.objectID,
      this.name,
      this.primaryImage,
      this.discount,
      this.deadline,
      this.discountedPrice,
      this.price,
      this.company,
      this.category,
      this.subcategory,
      this.created_at);

  static SearchHit fromJson(Map<String, dynamic> json) {
    return SearchHit(
        json['objectID'] as String,
        json['name'],
        json['primaryImage'],
        json['discount'],
        json['deadline'],
        json['discountedPrice'],
        json['price'],
        json['company'],
        json['category'],
        json['subcategory'],
        json['created_at']);
  }
}
