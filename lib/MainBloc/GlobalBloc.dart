import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endy/MainBloc/Parent.dart';
import 'package:endy/streams/categories.dart';
import 'package:endy/streams/companies.dart';
import 'package:endy/streams/notifications.dart';
import 'package:endy/streams/panel.dart';
import 'package:endy/types/category.dart';
import 'package:endy/types/company.dart';
import 'package:endy/types/notification.dart';
import 'package:endy/types/panel.dart';
import 'package:endy/types/product.dart';
import 'package:endy/types/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum GlobalStatus { loading, loaded, error }

enum GlobalAuthStatus { error, loggedIn, notLoggedIn, loading }

class GlobalState {
  final GlobalAuthStatus authStatus;
  final User? user;
  final UserData? userData;
  final int? reset;
  final String aboutApp;

  final GlobalStatus packageStatus;
  final List<NotificationMessage> notifications;
  final int unseenNotificationCount;
  final List<Company> companies;
  final List<Category> categories;
  final List<Subcategory> subcategories;
  final List<Panel> panels;

  GlobalState({
    this.authStatus = GlobalAuthStatus.loading,
    this.userData,
    this.reset,
    this.user,
    this.packageStatus = GlobalStatus.loading,
    this.categories = const [],
    this.notifications = const [],
    this.unseenNotificationCount = 0,
    this.subcategories = const [],
    this.companies = const [],
    this.panels = const [],
    this.aboutApp = "",
  });

  GlobalState copyWith({
    GlobalAuthStatus? authStatus,
    GlobalStatus? packageStatus,
    User? user,
    UserData? userData,
    int? reset,
    List<Company>? companies,
    List<NotificationMessage>? notifications,
    int? unseenNotificationCount,
    List<Category>? categories,
    List<Subcategory>? subcategories,
    List<Panel>? panels,
    String? aboutApp,
  }) {
    return GlobalState(
      packageStatus: packageStatus ?? this.packageStatus,
      authStatus: authStatus ?? this.authStatus,
      user: user ?? this.user,
      userData: userData ?? this.userData,
      notifications: notifications ?? this.notifications,
      unseenNotificationCount:
          unseenNotificationCount ?? this.unseenNotificationCount,
      companies: companies ?? this.companies,
      categories: categories ?? this.categories,
      subcategories: subcategories ?? this.subcategories,
      panels: panels ?? this.panels,
      reset: reset ?? this.reset,
      aboutApp: aboutApp ?? this.aboutApp,
    );
  }

  List<Object?> get props => [
        categories,
        subcategories,
        companies,
        panels,
        user,
        userData,
        authStatus,
        notifications,
        unseenNotificationCount,
        packageStatus,
        reset,
        aboutApp,
      ];
}

class GlobalBloc extends Parent {
  GlobalBloc() : super() {
    setAll();
  }

  void setAuthLoading(GlobalAuthStatus status) {
    emit(state.copyWith(authStatus: status));
  }

  void setCompanies(List<Company> companies) {
    emit(state.copyWith(companies: companies));
  }

  void setCategories(List<Category> categories) {
    emit(state.copyWith(categories: categories));
  }

  void setSubcategories(List<Subcategory> subcategories) {
    emit(state.copyWith(subcategories: subcategories));
  }

  void setPanels(List<Panel> panels) {
    emit(state.copyWith(panels: panels));
  }

  void setUserData(UserData userData) {
    emit(state.copyWith(
        userData: userData,
        user: FirebaseAuth.instance.currentUser,
        authStatus: GlobalAuthStatus.loggedIn));
  }

  void addSubscription(String sub) {
    if (state.userData != null) {
      var data = UserData.fromInstance(state.userData!);
      data.subscribedCompanies.add(sub);
      emit(state.copyWith(userData: data));
      updateUser(data);
    }
  }

  void removeSubscription(String sub) {
    if (state.userData != null) {
      var data = UserData.fromInstance(state.userData!);
      data.subscribedCompanies.remove(sub);
      emit(state.copyWith(userData: data));
      updateUser(data);
    }
  }

  void addFavorite(Product product) {
    var data = UserData.fromInstance(state.userData!);
    data.liked
        .add(FirebaseFirestore.instance.collection("products").doc(product.id));
    emit(state.copyWith(userData: data));
    updateUser(data);
  }

  void removeFavorite(Product product) {
    var data = UserData.fromInstance(state.userData!);
    data.liked.remove(
        FirebaseFirestore.instance.collection("products").doc(product.id));
    emit(state.copyWith(userData: data));
    updateUser(data);
  }

  void addBonusCard(BonusCard bonus) {
    if (state.userData != null) {
      var data = UserData.fromInstance(state.userData!);
      data.bonusCard.add(bonus);
      emit(state.copyWith(userData: data));
      updateUser(data);
    }
  }

  void removeBonusCard(BonusCard bonus) {
    if (state.userData != null) {
      var data = UserData.fromInstance(state.userData!);
      data.bonusCard
          .removeWhere((element) => element.cardNumber == bonus.cardNumber);
      emit(state.copyWith(userData: data));
      updateUser(data);
    }
  }

  void updatePP(String pp) {
    if (state.userData != null) {
      var user = UserData.fromInstance(state.userData!);
      user.profilePic = pp;
      emit(state.copyWith(userData: user));
      updateUser(user);
    }
  }

  void setAll() {
    Future.wait([
      CompanyCrud.getCompanies(),
      CategoryCrud.getCategories(),
      PanelCrud.getPanels(),
      PanelCrud.getAbout()
      // SubcategoryCrud.getSubcategories(),
    ]).then((value) {
      emit(state.copyWith(
        packageStatus: GlobalStatus.loaded,
        companies: value[0] as List<Company>,
        categories: value[1] as List<Category>,
        panels: value[2] as List<Panel>,
        aboutApp: value[3] as String,
        // subcategories: value[2] as List<Subcategory>,
      ));
    });

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        emit(GlobalState()
            .copyWith(authStatus: GlobalAuthStatus.notLoggedIn, user: null));
      } else {
        FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((value) {
          if (value.exists && value.data() != null) {
            var data = UserData.fromJson(value.data()!);
            NotificationCrud.getNotifications(data.subscribedCompanies)
                .then((notifications) {
              int count = notifications
                  .where((element) =>
                      element.createdAt > data.notificationSeenTime)
                  .length;
              emit(state.copyWith(
                  notifications: notifications,
                  unseenNotificationCount: count,
                  authStatus: GlobalAuthStatus.loggedIn,
                  user: user,
                  userData: data));
            });
          }
        });
      }
    });
  }

  void setFirstEnter() {
    var data = UserData.fromInstance(state.userData!);
    data.isFirstEnter = false;
    emit(state.copyWith(userData: data));
    updateUser(data);
  }

  void resetAll() {
    emit(state.copyWith(reset: (state.reset ?? 0) + 1));
  }

  void logout() {
    emit(state.copyWith(
        user: null, userData: null, authStatus: GlobalAuthStatus.loading));
  }

  void updateNotificationSeenTime() {
    if (state.userData != null) {
      var user = UserData.fromInstance(state.userData!);
      user.notificationSeenTime =
          (DateTime.now().millisecondsSinceEpoch / 1000).round();
      emit(state.copyWith(userData: user, unseenNotificationCount: 0));
      updateUser(user);
    }
  }
}
