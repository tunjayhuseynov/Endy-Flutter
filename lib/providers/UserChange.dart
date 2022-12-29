import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endy/streams/notifications.dart';
import 'package:endy/types/notification.dart';
import 'package:endy/types/product.dart';
import 'package:endy/types/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:endy/types/category.dart' as MyCategory;

class UserChange extends ChangeNotifier {
  UserData? user;
  List<Map<MyCategory.Category, List<Product>>> productList = [];
  List<NotificationMessage> notificationList = [];
  int unseenNotification = 0;

  UserChange() {
    // SharedPreferences.getInstance().then((prefes) => {
    //       if (prefes.containsKey("user"))
    //         {
    //           user = UserData.fromJson(jsonDecode(prefes.getString("user")!)),
    //           notifyListeners()
    //         }
    //     });
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        if (value.exists && value.data() != null) {
          user = UserData.fromJson(value.data()!);
          NotificationCrud.getNotifications(user!.subscribedCompanies)
              .then((notifications) {
            notificationList = notifications;
            unseenNotification = notifications
                .where(
                    (element) => element.createdAt > user!.notificationSeenTime)
                .length;
            notifyListeners();
          });
          // notifyListeners();
        }
      });
    }
  }

  void setProductList(List<Map<MyCategory.Category, List<Product>>> list) {
    productList = list;
    notifyListeners();
  }

  // void setPreference(UserData user) {
  //   SharedPreferences.getInstance().then(
  //       (prefes) => {prefes.setString("user", jsonEncode(user.toJson(true)))});
  // }

  Future<void> updateUser(UserData user) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.id)
        .update(UserData.fromInstance(user).toJson());
    notifyListeners();
  }

  Future<void> updateUserWhNotify(UserData user) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.id)
        .update(UserData.fromInstance(user).toJson());
  }

  void updatePP(String pp) {
    if (user != null) {
      user!.profilePic = pp;
      updateUser(user!);
      notifyListeners();
    }
  }

  void updateNotificationSeenTime() {
    if (user != null) {
      user!.notificationSeenTime =
          (DateTime.now().millisecondsSinceEpoch / 1000).round();
      unseenNotification = 0;
      updateUser(user!);
      notifyListeners();
    }
  }

  void updateNotificationSeenTimeWhNotify() {
    if (user != null) {
      user!.notificationSeenTime =
          (DateTime.now().millisecondsSinceEpoch / 1000).round();
      unseenNotification = 0;
      updateUser(user!);
    }
  }

  void resetUser() {
    user = null;
    notifyListeners();
  }

  void setUser(UserData? newUser) {
    if (newUser != null) {
      user = newUser;
      // setPreference(newUser);
      updateUser(newUser);
    }
  }

  void addFavorite(Product product) {
    user!.liked
        .add(FirebaseFirestore.instance.collection("products").doc(product.id));
    // setPreference(user!);
    updateUserWhNotify(user!);
  }

  void removeFavorite(Product product) {
    user!.liked.remove(
        FirebaseFirestore.instance.collection("products").doc(product.id));
    // setPreference(user!);
    updateUserWhNotify(user!);
  }

  void setisFirstEnter(bool value) {
    user!.isFirstEnter = value;
    // setPreference(user!);
    updateUser(user!);
  }

  void addBonusCard(BonusCard bonus) {
    if (user != null) {
      user?.bonusCard.add(bonus);
      updateUser(user!);
    }
  }

  void removeBonusCard(BonusCard bonus) {
    if (user != null) {
      user?.bonusCard
          .removeWhere((element) => element.cardNumber == bonus.cardNumber);

      updateUser(user!);
    }
  }

  void addSubscription(String sub) {
    if (user != null) {
      user?.subscribedCompanies.add(sub);
      updateUser(user!);
    }
  }

  void removeSubscription(String sub) {
    if (user != null) {
      user?.subscribedCompanies.remove(sub);
      updateUser(user!);
    }
  }
}
