import 'package:auto_route/annotations.dart';
import 'package:endy/Pages/main/Catalog/CatalogMain.dart';
import 'package:endy/Pages/main/Home/HomePage/HomePageContainer.dart';
import 'package:endy/Pages/main/Onboard/Onboard.dart';
import 'package:endy/Pages/main/bonus/bonusHome.dart';
import 'package:endy/utils/router.dart';

@MaterialAutoRouter(
  // replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      path: '/',
      page: GlobalWidget,
      
    )
  ],
)
class $AppRouter {}
