// import 'package:endy/MainBloc/GlobalBloc.dart';
// import 'package:endy/Pages/main/Bonus/BonusHome.dart';
// import 'package:endy/Pages/main/Catalog/CatalogMain.dart';
// import 'package:endy/Pages/main/Favorite/FavoriteMain.dart';
// import 'package:endy/Pages/main/Home/HomePage/HomePageContainer.dart';
// import 'package:endy/Pages/main/Home/SearchPage/Search.dart';
// import 'package:endy/Pages/main/Home/SearchPage/Search_Page_Bloc.dart';
// import 'package:endy/Pages/main/Setting/Setting.dart';
// import 'package:endy/components/Navbar.dart';
// import 'package:endy/main.dart';
// import 'package:endy/types/catalog.dart';
// import 'package:endy/types/company.dart';
// import 'package:endy/types/place.dart';
// import 'package:endy/types/user.dart';
// import 'package:endy/utils/index.dart';
// import 'package:endy/Pages/Sign/OTP/OTP.dart';
// import 'package:endy/Pages/Sign/Register/RegistrationContainer.dart';
// import 'package:endy/Pages/main/Catalog/CatalogSingle.dart';
// import 'package:endy/Pages/main/Home/CategoryGrid/CategoryBlocProvider.dart';
// import 'package:endy/Pages/main/Home/FilterPage/FilterPageScaffold.dart';
// import 'package:endy/Pages/main/bonus/BonusAdd.dart';
// import 'package:endy/Pages/main/bonus/BonusDetail.dart';
// import 'package:endy/Pages/main/Home/CategorySelectionList/Categories.dart';
// import 'package:endy/Pages/main/Home/CategorySelectionList/Subcategories.dart';
// import 'package:endy/Pages/main/Home/DetailPage/DetailPageContainer.dart';
// import 'package:endy/Pages/main/list/ListDetail.dart';
// import 'package:endy/Pages/main/Setting/AboutUs.dart';
// import 'package:endy/Pages/main/Setting/Notification.dart';
// import 'package:endy/Pages/main/Setting/Profile.dart';
// import 'package:endy/Pages/main/Catalog/CatalogDetail.dart';
// import 'package:endy/Pages/main/List/ListHome.dart';
// import 'package:endy/Pages/main/NeedRegister/index.dart';
// import 'package:endy/Pages/main/bonus/CameraQrScanner.dart';
// import 'package:endy/Pages/main/Home/DetailPage/Map.dart';
// import 'package:endy/Pages/main/Onboard/Onboard.dart';
// import 'package:endy/Pages/sign/Main.dart';
// import 'package:endy/Pages/sign/SignIn/SignIn.dart';
// import 'package:flutter/material.dart';

// import '../components/GlobalWidget.dart';

// Widget Function(BuildContext context) routerSwitch(RouteSettings setting) {
//   late Widget widget;
//   bool disallowAnonym = false;
//   final uri = Uri.parse(setting.name ?? "");
//   final id = uri.queryParameters['id'];
//   switch (uri.path) {
//     case '/onboard':
//       widget = const OnboardRoute();
//       break;
//     case '/':
//       widget = const MainContainerRoute();
//       break;
//     case "/bonus":
//       widget = const BonusHomeRoute();
//       disallowAnonym = true;
//       break;
//     case "/catalog":
//       widget = const CatalogMainRoute();
//       break;
//     case "/setting":
//       widget = const SettingRoute();
//       disallowAnonym = true;
//       break;
//     case "/favorite":
//       widget = const FavoriteMainRoute();
//       disallowAnonym = true;
//       break;
//     case "/home/map":
//       widget = MapPageRoute(
//         places: (setting.arguments as List)[0] as List<Place>,
//         company: (setting.arguments as List)[1] as Company,
//       );
//       disallowAnonym = true;
//       break;
//     case "/home/main/all":
//       widget = const CategoryBlocProviderRoute();
//       break;
//     case "/home/detail":
//       widget = DetailPageContainerRoute(
//         id: id ?? setting.arguments as String,
//       );
//       break;
//     case "/home/category":
//       widget = const SubcategoryListRoute();
//       break;
//     case "/home/category/all":
//       widget = const CategoryListRoute();
//       break;
//     case "/home/filter":
//       widget = const FilterPageScaffoldRoute();
//       break;

//     case "/bonus/detail":
//       widget = BonusDetailPageRoute(
//         card: setting.arguments as BonusCard,
//       );
//       disallowAnonym = true;
//       break;
//     case "/bonus/camera":
//       widget = const CameraRoute();
//       disallowAnonym = true;
//       break;
//     case "/bonus/add":
//       widget = BonusAddRoute(
//         code: setting.arguments as String?,
//       );
//       disallowAnonym = true;
//       break;

//     case "/needregister":
//       widget = NeedRegisterRoute(activeTab: setting.arguments as bool?);
//       break;

//     case "/list/single":
//       widget = const ListDetailRoute();
//       disallowAnonym = true;
//       break;
//     case "/list":
//       widget = const ListHomeRoute();
//       disallowAnonym = true;
//       break;

//     case "/sign/main":
//       widget = const SignRoute();
//       break;
//     case "/sign/signin":
//       widget = const SignInRoute();
//       break;
//     case "/sign/registration":
//       widget = const RegistrationContainerRoute();
//       break;
//     case "/sign/otp":
//       widget = OTP(
//         params: setting.arguments as OtpParams,
//       );
//       break;

//     case "/profile":
//       widget = const ProfileRoute();
//       disallowAnonym = true;
//       break;
//     case "/notification":
//       widget = const NotificationPageRoute();
//       disallowAnonym = true;
//       break;
//     case "/about":
//       widget = const AboutUsRoute();
//       break;

//     case "/catalog/detail":
//       widget = CatalogDetailRoute(
//         company: (setting.arguments as Company),
//       );
//       break;
//     case "/catalog/single":
//       widget = CatalogSingleRoute(
//         catalog: (setting.arguments as Catalog),
//       );
//       break;
//     default:
//       widget = const MainContainerRoute();
//   }


//   return (BuildContext context) {
//     // ScrollController controller = ScrollController();
//     return MediaQuery(
//         data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
//         child: GlobalWidgetRoute(
//           child: widget,
//           disallowAnonym: disallowAnonym,
//           urlPath: setting.name ?? "",
//         ));
//   };
// }
