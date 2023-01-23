import 'package:endy/Pages/Sign/Register/RegistrationContainer.dart';
import 'package:endy/Pages/main/Catalog/CatalogDetail.dart';
import 'package:endy/Pages/main/Catalog/CatalogSingle.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/CategoryBlocProvider.dart';
import 'package:endy/Pages/main/List/ListHome.dart';
import 'package:endy/Pages/main/Main.dart';
import 'package:endy/Pages/main/bonus/BonusAdd.dart';
import 'package:endy/Pages/main/bonus/BonusDetail.dart';
import 'package:endy/Pages/main/bonus/CameraQrScanner.dart';
import 'package:endy/Pages/main/Home/CategorySelectionList/Categories.dart';
import 'package:endy/Pages/main/Home/CategorySelectionList/Subcategories.dart';
import 'package:endy/Pages/main/Home/DetailPage/DetailPageContainer.dart';
import 'package:endy/Pages/main/Home/FilterPage/FilterPage.dart';
import 'package:endy/Pages/main/Home/DetailPage/Map.dart';
import 'package:endy/Pages/main/list/ListDetail.dart';
import 'package:endy/Pages/main/Setting/AboutUs.dart';
import 'package:endy/Pages/main/Setting/Notification.dart';
import 'package:endy/Pages/main/Setting/Profile.dart';
import 'package:endy/Pages/main/Onboard/Onboard.dart';
import 'package:endy/Pages/sign/Main.dart';
import 'package:endy/Pages/sign/OTP/OTP.dart';
import 'package:endy/Pages/sign/SignIn/SignIn.dart';
import 'package:endy/types/catalog.dart';
import 'package:endy/types/company.dart';
import 'package:endy/types/place.dart';
import 'package:endy/types/user.dart';
import 'package:flutter/cupertino.dart';

routerSwitch(RouteSettings setting) {
  late Widget widget;

  switch (setting.name) {
    case '/onboard':
      widget = const Onboard();
      break;
    case '/home':
      widget = const MainProvider();
      break;
    case "/home/map":
      widget = MapPage(
        places: (setting.arguments as List)[0] as List<Place>,
        company: (setting.arguments as List)[1] as Company,
      );
      break;
    case "/home/main/all":
      widget = const CategoryBlocProvider();
      break;
    case "/home/detail":
      widget = DetailPageContainer(
        id: setting.arguments as String,
      );
      break;
    case "/home/category":
      widget = const SubcategoryList();
      break;
    case "/home/category/all":
      widget = const CategoryList();
      break;
    case "/home/filter":
      widget = const FilterPage();
      break;

    case "/bonus/detail":
      widget = BonusDetailPage(
        card: setting.arguments as BonusCard,
      );
      break;
    case "/bonus/camera":
      widget = const Camera();
      break;
    case "/bonus/add":
      widget = BonusAdd(
        code: setting.arguments as String?,
      );
      break;

    case "/list/single":
      widget = const ListDetail();
      break;
    case "/list":
      widget = const ListHome();
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
      break;
    case "/setting/notification":
      widget = const NotificationPage();
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
      widget = const MainProvider();
  }

  return (BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: widget);
  };
}
