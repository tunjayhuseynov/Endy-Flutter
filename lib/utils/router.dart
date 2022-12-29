import 'package:endy/pages/main/Main.dart';
import 'package:endy/pages/main/bonus/BonusAdd.dart';
import 'package:endy/pages/main/bonus/BonusDetail.dart';
import 'package:endy/pages/main/bonus/CameraQrScanner.dart';
import 'package:endy/pages/main/Home/CategorySelectionList/Categories.dart';
import 'package:endy/pages/main/Home/CategorySelectionList/Subcategories.dart';
import 'package:endy/pages/main/Home/DetailPage/DetailPageContainer.dart';
import 'package:endy/pages/main/Home/FilterPage/FilterPage.dart';
import 'package:endy/pages/main/Home/CategoryGrid/CategoryGrid.dart';
import 'package:endy/pages/main/Home/DetailPage/Map.dart';
import 'package:endy/pages/main/list/ListDetail.dart';
import 'package:endy/pages/main/Setting/AboutUs.dart';
import 'package:endy/pages/main/Setting/Notification.dart';
import 'package:endy/pages/main/Setting/Profile.dart';
import 'package:endy/pages/onboard.dart';
import 'package:endy/pages/sign/forgot.dart';
import 'package:endy/pages/sign/main.dart';
import 'package:endy/pages/sign/newPassword.dart';
import 'package:endy/pages/sign/otp.dart';
import 'package:endy/pages/sign/registration.dart';
import 'package:endy/pages/sign/signin.dart';
import 'package:endy/types/company.dart';
import 'package:endy/types/place.dart';
import 'package:endy/types/user.dart';
import 'package:flutter/cupertino.dart';

routerSwitch(RouteSettings setting) {
  late WidgetBuilder builder;
  switch (setting.name) {
    case '/onboard':
      builder = (context) => const Onboard();
      break;
    case '/home':
      builder = (context) => const MainProvider();
      break;
    case "/home/map":
      builder = (BuildContext context) => MapPage(
            places: (setting.arguments as List)[0] as List<Place>,
            company: (setting.arguments as List)[1] as Company,
          );
      break;
    case "/home/main/all":
      builder = (BuildContext context) => const CategoryGrid();
      break;
    case "/home/detail":
      builder = (BuildContext context) => DetailPageContainer(
            id: setting.arguments as String,
          );
      break;
    case "/home/category":
      builder = (BuildContext context) => const SubcategoryList();
      break;
    case "/home/category/all":
      builder = (BuildContext context) => const CategoryList();
      break;
    case "/home/filter":
      builder = (BuildContext context) => const FilterPage();
      break;

    case "/bonus/detail":
      builder = (BuildContext context) => BonusDetailPage(
            card: setting.arguments as BonusCard,
          );
      break;
    case "/bonus/camera":
      builder = (BuildContext context) => const Camera();
      break;
    case "/bonus/add":
      builder = (BuildContext context) => BonusAdd(
            code: setting.arguments as String?,
          );
      break;

    case "/list/single":
      builder = (BuildContext context) => ListDetail();
      break;

    case "/sign/main":
      builder = (BuildContext context) => const Sign();
      break;
    case "/sign/forgot":
      builder = (BuildContext context) => const Forgot();
      break;
    case "/sign/new-password":
      builder = (BuildContext context) => const NewPassword();
      break;
    case "/sign/signin":
      builder = (BuildContext context) => const SignIn();
      break;
    case "/sign/registration":
      builder = (BuildContext context) => const Registration();
      break;
    case "/sign/otp":
      builder = (BuildContext context) => OTP(
            params: setting.arguments as OtpParams,
          );
      break;

    case "/setting/profile":
      builder = (BuildContext context) => Profile();
      break;
    case "/setting/notification":
      builder = (BuildContext context) => NotificationPage();
      break;
    case "/setting/about":
      builder = (BuildContext context) => const AboutUs();
      break;
    default:
      builder = (context) => const MainProvider();
  }
  return builder;
}
