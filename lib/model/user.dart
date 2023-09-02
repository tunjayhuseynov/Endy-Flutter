
class UserData {
  late String id;
  late String role;
  late String name;
  late String phone;
  late String mail;
  late int birthDate;

  late String? profilePic;

  late bool isFirstEnter;

  late List<UserList> list;
  late List<BonusCard> bonusCard;
  late List<dynamic> liked = [];
  late List<String> subscribedCompanies;
  late List<Notification> notifications;
  late int notificationSeenTime;

  late int createdAt;

  UserData.fromInstance(UserData user) {
    id = user.id;
    role = user.role;
    name = user.name;
    phone = user.phone;
    mail = user.mail;
    birthDate = user.birthDate;
    profilePic = user.profilePic;
    isFirstEnter = user.isFirstEnter;
    list = user.list;
    bonusCard = user.bonusCard;
    liked = user.liked;
    subscribedCompanies = user.subscribedCompanies;
    notifications = user.notifications;
    notificationSeenTime = user.notificationSeenTime;
    createdAt = user.createdAt;
  }

  UserData({
    required this.id,
    required this.role,
    required this.name,
    required this.phone,
    required this.mail,
    required this.birthDate,
    required this.isFirstEnter,
    this.profilePic,
    required this.list,
    required this.bonusCard,
    required this.liked,
    required this.subscribedCompanies,
    required this.notifications,
    required this.createdAt,
    required this.notificationSeenTime,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'];
    name = json['name'];
    phone = json['phone'];
    mail = json['mail'];
    birthDate = json['birthDate'];
    profilePic = json['profilePic'];
    isFirstEnter = json['isFirstEnter'];

    list = (json['list'] as List<dynamic>)
        .map((e) => UserList.fromJson(e))
        .toList();
    bonusCard = (json['bonusCard'] as List<dynamic>)
        .map((e) => BonusCard.fromJson(e))
        .toList();
    liked = (json['liked'] as List<dynamic>)
            .map((e) => (e))
            .toList();
    subscribedCompanies = json['subscribedCompanies']?.cast<String>();
    notifications = json['notifications']?.cast<Notification>();
    createdAt = json['created_at'];
    notificationSeenTime = json['notificationSeenTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['role'] = role;
    data['name'] = name;
    data['phone'] = phone;
    data['mail'] = mail;
    data['birthDate'] = birthDate;
    data['profilePic'] = profilePic;
    data['isFirstEnter'] = isFirstEnter;

    data['list'] = list.map((e) => e.toJson()).toList();
    data['bonusCard'] = bonusCard.map((e) => e.toJson()).toList();
    data['liked'] = liked;
    data['subscribedCompanies'] = subscribedCompanies;
    data['notifications'] = notifications;
    data['created_at'] = createdAt;
    data['notificationSeenTime'] = notificationSeenTime;
    return data;
  }
}

class UserList {
  late String id;
  late String name;
  late List<UserListDetail> details;

  UserList({
    required this.id,
    required this.name,
    required this.details,
  });

  UserList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    details = (json['details'] as List<dynamic>)
        .map((e) => UserListDetail.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['details'] = details.map((e) => e.toJson()).toList();
    return data;
  }
}

class UserListDetail {
  late String id;
  late String name;
  late bool isDone;

  UserListDetail({
    required this.id,
    required this.name,
    required this.isDone,
  });

  UserListDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isDone = json['isDone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['isDone'] = isDone;
    return data;
  }
}

class BonusCard {
  late String? cardFront;
  late String? cardBack;
  late String cardName;
  late String cardNumber;
  int createdAt = DateTime.now().millisecondsSinceEpoch;

  BonusCard({
    required this.cardFront,
    required this.cardBack,
    required this.cardName,
    required this.cardNumber,
  });

  BonusCard.fromJson(Map<String, dynamic> json) {
    cardFront = json['cardFront'];
    cardBack = json['cardBack'];
    cardName = json['cardName'];
    cardNumber = json['cardNumber'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cardFront'] = cardFront;
    data['cardBack'] = cardBack;
    data['cardName'] = cardName;
    data['cardNumber'] = cardNumber;
    data['created_at'] = createdAt;
    return data;
  }
}

class Notification {
  late String id;
  late String title;
  late String message;
  late int createdAt;

  Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
  });

  Notification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    message = json['message'];
    createdAt = json['created_at'];
  }
}
