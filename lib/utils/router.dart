import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Bonus/BonusHome.dart';
import 'package:endy/Pages/main/Catalog/CatalogMain.dart';
import 'package:endy/Pages/main/Favorite/FavoriteMain.dart';
import 'package:endy/Pages/main/Home/HomePage/HomePageContainer.dart';
import 'package:endy/Pages/main/Setting/Setting.dart';
import 'package:endy/components/Navbar.dart';
import 'package:endy/types/catalog.dart';
import 'package:endy/types/company.dart';
import 'package:endy/types/place.dart';
import 'package:endy/types/user.dart';
import 'package:endy/utils/index.dart';
import 'package:endy/Pages/Sign/OTP/OTP.dart';
import 'package:endy/Pages/Sign/Register/RegistrationContainer.dart';
import 'package:endy/Pages/main/Catalog/CatalogSingle.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/CategoryBlocProvider.dart';
import 'package:endy/Pages/main/Home/FilterPage/FilterPageScaffold.dart';
import 'package:endy/Pages/main/bonus/BonusAdd.dart';
import 'package:endy/Pages/main/bonus/BonusDetail.dart';
import 'package:endy/Pages/main/Home/CategorySelectionList/Categories.dart';
import 'package:endy/Pages/main/Home/CategorySelectionList/Subcategories.dart';
import 'package:endy/Pages/main/Home/DetailPage/DetailPageContainer.dart';
import 'package:endy/Pages/main/list/ListDetail.dart';
import 'package:endy/Pages/main/Setting/AboutUs.dart';
import 'package:endy/Pages/main/Setting/Notification.dart';
import 'package:endy/Pages/main/Setting/Profile.dart';
import 'package:endy/Pages/main/Catalog/CatalogDetail.dart';
import 'package:endy/Pages/main/List/ListHome.dart';
import 'package:endy/Pages/main/NeedRegister/index.dart';
import 'package:endy/Pages/main/bonus/CameraQrScanner.dart';
import 'package:endy/Pages/main/Home/DetailPage/Map.dart';
import 'package:endy/Pages/main/Onboard/Onboard.dart';
import 'package:endy/Pages/sign/Main.dart';
import 'package:endy/Pages/sign/SignIn/SignIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tap_canvas/tap_canvas.dart';

Widget Function(BuildContext context) routerSwitch(RouteSettings setting) {
  late Widget widget;
  bool disallowAnonym = false;
  final uri = Uri.parse(setting.name ?? "");
  final id = uri.queryParameters['id'];
  switch (uri.path) {
    case '/onboard':
      widget = const Onboard();
      break;
    case '/':
      widget = const MainContainer();
      break;
    case "/bonus":
      widget = const BonusHome();
      disallowAnonym = true;
      break;
    case "/catalog":
      widget = const CatalogMain();
      break;
    case "/setting":
      widget = const Setting();
      disallowAnonym = true;
      break;
    case "/favorite":
      widget = const FavoriteMain();
      disallowAnonym = true;
      break;
    case "/home/map":
      widget = MapPage(
        places: (setting.arguments as List)[0] as List<Place>,
        company: (setting.arguments as List)[1] as Company,
      );
      disallowAnonym = true;
      break;
    case "/home/main/all":
      widget = const CategoryBlocProvider();
      break;
    case "/home/detail":
      widget = DetailPageContainer(
        id: id ?? setting.arguments as String,
      );
      break;
    case "/home/category":
      widget = const SubcategoryList();
      break;
    case "/home/category/all":
      widget = const CategoryList();
      break;
    case "/home/filter":
      widget = const FilterPageScaffold();
      break;

    case "/bonus/detail":
      widget = BonusDetailPage(
        card: setting.arguments as BonusCard,
      );
      disallowAnonym = true;
      break;
    case "/bonus/camera":
      widget = const Camera();
      disallowAnonym = true;
      break;
    case "/bonus/add":
      widget = BonusAdd(
        code: setting.arguments as String?,
      );
      disallowAnonym = true;
      break;

    case "/needregister":
      widget = NeedRegister(activeTab: setting.arguments as bool?);
      break;

    case "/list/single":
      widget = const ListDetail();
      disallowAnonym = true;
      break;
    case "/list":
      widget = const ListHome();
      disallowAnonym = true;
      break;

    case "/sign/main":
      widget = const Sign();
      break;
    case "/sign/signin":
      widget = const SignIn();
      break;
    case "/sign/registration":
      widget = const RegistrationContainer();
      break;
    case "/sign/otp":
      widget = OTP(
        params: setting.arguments as OtpParams,
      );
      break;

    case "/setting/profile":
      widget = const Profile();
      disallowAnonym = true;
      break;
    case "/setting/notification":
      widget = const NotificationPage();
      disallowAnonym = true;
      break;
    case "/setting/about":
      widget = const AboutUs();
      break;

    case "/catalog/detail":
      widget = CatalogDetail(
        company: (setting.arguments as Company),
      );
      break;
    case "/catalog/single":
      widget = CatalogSingle(
        catalog: (setting.arguments as Catalog),
      );
      break;
    default:
      widget = const MainContainer();
  }
  var needSign = FirebaseAuth.instance.currentUser == null;
  if (needSign && setting.name != null && !setting.name!.contains('/sign')) {
    widget = const Sign();
  } else if (!needSign &&
      setting.name != null &&
      setting.name!.contains('/sign')) {
    widget = const MainContainer();
  }

  return (BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    ScrollController controller = ScrollController();
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: TapCanvas(
          child: GlobalWidget(
            child: w < 1024
                ? widget
                : Scaffold(
                    backgroundColor: Colors.white,
                    body: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView(
                          controller: controller,
                          shrinkWrap: true,
                          children: [
                            if (setting.name != null &&
                                !setting.name!.contains("/sign") &&
                                !needSign)
                              Navbar(),
                            Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: widget),
                          ]),
                    ),
                  ),
            disallowAnonym: disallowAnonym,
          ),
        ));
  };
}

class GlobalWidget extends StatefulWidget {
  final Widget child;
  final bool disallowAnonym;
  const GlobalWidget(
      {super.key, required this.child, required this.disallowAnonym});

  @override
  State<GlobalWidget> createState() => _GlobalWidgetState();
}

class _GlobalWidgetState extends State<GlobalWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GlobalBloc, GlobalState>(
      listener: (context, state) {
        if (state.internetConnectionLost) {
          ShowTopSnackBar(
              context,
              error: state.internetConnectionLost,
              info: !state.internetConnectionLost,
              state.internetConnectionLost == true
                  ? "Internet əlaqəsi yoxdur"
                  : "Internet əlaqəsi quruldu");
        }

        if (state.userData != null &&
            !kIsWeb &&
            state.userData!.subscribedCompanies.length > 0) {
          for (var sub in state.userData!.subscribedCompanies) {
            FirebaseMessaging.instance.subscribeToTopic(sub);
          }
        }
      },
      listenWhen: (previous, current) =>
          previous.internetConnectionLost != current.internetConnectionLost ||
          previous.authStatus != current.authStatus,
      // buildWhen: (previous, current) =>
      //     current.authStatus == GlobalAuthStatus.loggedIn,
      builder: (context, state) {
        if (state.authStatus == GlobalAuthStatus.loggedIn ||
            state.authStatus == GlobalAuthStatus.loading) {
          if (state.categories.isEmpty ||
              state.companies.isEmpty ||
              state.authStatus == GlobalAuthStatus.loading) {
            return const Scaffold(
              body: Align(
                alignment: Alignment.center,
                child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      color: Color(mainColor),
                    )),
              ),
            );
          }
          return state.userData != null && state.userData!.isFirstEnter
              ? const Onboard()
              : state.authStatus == GlobalAuthStatus.loggedIn &&
                      state.userData == null &&
                      widget.disallowAnonym
                  ? NeedRegister(
                      activeTab: true,
                    )
                  : widget.child;
        }
        return widget.child;
      },
    );
  }
}
