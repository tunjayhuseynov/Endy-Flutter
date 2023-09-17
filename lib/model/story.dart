class Story {
  final String id;
  final String companyId;
  final int createdAt;
  final int from;
  final int to;
  final String mediaLink;
  final String mediaType;
  final String? referenceLink;
  final String? text;

  const Story(
      {required this.id,
      required this.companyId,
      required this.createdAt,
      required this.to,
      required this.from,
      required this.mediaLink,
      required this.mediaType,
      this.referenceLink,
      this.text});

  static Story fromJson(Map<String, dynamic> json) {
    return Story(
        id: json["id"] as String,
        companyId: json["companyId"] as String,
        createdAt: json["createAt"] as int,
        to: json["to"] as int,
        from: json["from"] as int,
        mediaLink: json["mediaLink"] as String,
        mediaType: json["mediaType"] as String,
        referenceLink: json["referenceLink"] != null
            ? json["referenceLink"] as String
            : null,
        text: json["text"] != null ? json["text"] as String : null);
  }
}
