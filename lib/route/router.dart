import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/Sign/Main.dart';
import 'package:endy/Pages/Sign/OTP/OTP.dart';
import 'package:endy/Pages/Sign/Register/RegistrationContainer.dart';
import 'package:endy/Pages/Sign/SignIn/SignIn.dart';
import 'package:endy/Pages/loading.dart';
import 'package:endy/Pages/main/Bonus/BonusAdd.dart';
import 'package:endy/Pages/main/Bonus/BonusDetail.dart';
import 'package:endy/Pages/main/Bonus/BonusHome.dart';
import 'package:endy/Pages/main/Bonus/CameraQrScanner.dart';
import 'package:endy/Pages/main/Catalog/CatalogDetail.dart';
import 'package:endy/Pages/main/Catalog/CatalogMain.dart';
import 'package:endy/Pages/main/Catalog/CatalogSingle.dart';
import 'package:endy/Pages/main/Favorite/FavoriteMain.dart';
import 'package:endy/Pages/main/Home/CategorySelectionList/CategoryList.dart';
import 'package:endy/Pages/main/Home/Labels/CompanyLabelList.dart';
import 'package:endy/Pages/main/Home/CategorySelectionList/SubcategoryAndCompanyList.dart';
import 'package:endy/Pages/main/Home/DetailPage/DetailPageContainer.dart';
import 'package:endy/Pages/main/Home/DetailPage/Map.dart';
import 'package:endy/Pages/main/Home/FilterPage/FilterPageScaffold.dart';
import 'package:endy/Pages/main/Home/HomePage/HomePage.dart';
import 'package:endy/Pages/main/Home/ProductList/ProductListPage.dart';
import 'package:endy/components/BottomNavBar.dart';
import 'package:endy/Pages/main/Home/SearchPage/Search.dart';
import 'package:endy/Pages/main/List/ListDetail.dart';
import 'package:endy/Pages/main/List/ListHome.dart';
import 'package:endy/Pages/main/Unauthrozation/index.dart';
import 'package:endy/Pages/main/Onboard/Onboard.dart';
import 'package:endy/Pages/main/Setting/AboutUs.dart';
import 'package:endy/Pages/main/Setting/Notification.dart';
import 'package:endy/Pages/main/Setting/Profile.dart';
import 'package:endy/Pages/main/Setting/Setting.dart';
import 'package:endy/route/router_names.dart';
import 'package:endy/services/goRouterRefreshStream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

int _getCurrentIndex(GoRouterState state) {
  if (state.location == APP_PAGE.HOME.toFullPath) {
    return 0;
  } else if (state.location == APP_PAGE.BONUS_CARD.toFullPath) {
    return 1;
  } else if (state.location == APP_PAGE.FAVORITE.toFullPath) {
    return 2;
  } else if (state.location == APP_PAGE.CATALOG.toFullPath) {
    return 3;
  } else if (state.location == APP_PAGE.SETTING.toFullPath) {
    return 4;
  } else {
    return 0;
  }
}

void _navigateToRoute(int index) {
  String route;
  switch (index) {
    case 0:
      route = APP_PAGE.HOME.toFullPath;
      break;
    case 1:
      route = APP_PAGE.BONUS_CARD.toFullPath;
      break;
    case 2:
      route = APP_PAGE.FAVORITE.toFullPath;
      break;
    case 3:
      route = APP_PAGE.CATALOG.toFullPath;
      break;
    case 4:
      route = APP_PAGE.SETTING.toFullPath;
      break;
    // Add more cases for other indexes as needed
    default:
      route = APP_PAGE.HOME.toFullPath;
  }

  GoRouter.of(_shellNavigatorKey.currentContext!).go(route);
}

final _shellNavigatorKey = GlobalKey<NavigatorState>();
String initialPage = APP_PAGE.HOME.toFullPath;

class CustomRouter {
  final List<Stream<dynamic>> streams;

  CustomRouter({
    required this.streams,
  });

  GoRouter _router() {
    final _rootNavigatorKey = GlobalKey<NavigatorState>();

    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: initialPage,
      refreshListenable: GoRouterRefreshStream(streams),
      // "${APP_PAGE.audioPlayer.toPath}?sourceLink=${Uri.encodeComponent("https://firebasestorage.googleapis.com/v0/b/just-story-it.appspot.com/o/dua%20lipa.mp3?alt=media&token=7621c714-577a-4181-9732-2eed8651c38c")}",
      routes: [
        GoRoute(
          path: APP_PAGE.SIGN_MAIN.toPath,
          name: APP_PAGE.SIGN_MAIN.toName,
          redirect: AuthRedirector,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => SignRoute(),
          routes: [
            GoRoute(
              redirect: AuthRedirector,
              path: APP_PAGE.SIGN_IN.toPath,
              name: APP_PAGE.SIGN_IN.toName,
              builder: (context, state) => const SignInRoute(),
            ),
            GoRoute(
              redirect: AuthRedirector,
              path: APP_PAGE.SIGN_UP.toPath,
              name: APP_PAGE.SIGN_UP.toName,
              builder: (context, state) => const RegistrationContainerRoute(),
            ),
            GoRoute(
              redirect: AuthRedirector,
              path: APP_PAGE.OTP.toPath,
              name: APP_PAGE.OTP.toName,
              builder: (context, state) =>
                  OTP(phone: (state.pathParameters["phone"] ?? "")),
            ),
          ],
        ),
        GoRoute(
          path: APP_PAGE.LOADING.toPath,
          name: APP_PAGE.LOADING.toName,
          redirect: AuthRedirector,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const LoadingPage(),
        ),
        GoRoute(
          path: APP_PAGE.UNAUTHORIZATION.toPath,
          name: APP_PAGE.UNAUTHORIZATION.toName,
          redirect: AuthRedirector,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const UnauthorizationRoute(),
        ),
        GoRoute(
          path: APP_PAGE.NOTIFICATION.toPath,
          name: APP_PAGE.NOTIFICATION.toName,
          redirect: AuthRedirector,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const NotificationPageRoute(),
        ),
        GoRoute(
          path: APP_PAGE.FILTER.toPath,
          name: APP_PAGE.FILTER.toName,
          redirect: AuthRedirector,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const FilterPageScaffoldRoute(),
        ),
        GoRoute(
          path: APP_PAGE.PRODUCT_DETAIL.toPath,
          name: APP_PAGE.PRODUCT_DETAIL.toName,
          redirect: AuthRedirector,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) =>
              DetailPageContainerRoute(id: state.pathParameters["id"] ?? ""),
        ),
        GoRoute(
          path: APP_PAGE.PRODUCT_MAP.toPath,
          name: APP_PAGE.PRODUCT_MAP.toName,
          redirect: AuthRedirector,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) =>
              MapPageRoute(id: state.pathParameters["id"]),
        ),
        GoRoute(
          path: APP_PAGE.PROFILE.toPath,
          name: APP_PAGE.PROFILE.toName,
          redirect: AuthRedirector,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const ProfileRoute(),
        ),
        GoRoute(
          path: APP_PAGE.SEARCH.toPath,
          name: APP_PAGE.SEARCH.toName,
          redirect: AuthRedirector,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => SearchPageRoute(
              categoryId: state.queryParameters["categoryId"],
              companyId: state.queryParameters["companyId"],
              noTabbar: state.queryParameters["noTabbar"] as bool,
              subcategoryId: state.queryParameters["subcategoryId"]),
        ),
        GoRoute(
          path: APP_PAGE.SHOPPING_LIST.toPath,
          name: APP_PAGE.SHOPPING_LIST.toName,
          redirect: AuthRedirector,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => ListHomeRoute(),
        ),
        GoRoute(
          path: APP_PAGE.SHOPPING_LIST_DETAIL.toPath,
          name: APP_PAGE.SHOPPING_LIST_DETAIL.toName,
          redirect: AuthRedirector,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) =>
              ListDetailRoute(id: state.pathParameters["id"]),
        ),
        GoRoute(
          path: APP_PAGE.CATEGORY_LIST.toPath,
          name: APP_PAGE.CATEGORY_LIST.toName,
          redirect: AuthRedirector,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => CategoryListRoute(),
        ),
        GoRoute(
          path: APP_PAGE.SUBCATEGORY_LIST.toPath,
          name: APP_PAGE.SUBCATEGORY_LIST.toName,
          redirect: AuthRedirector,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) =>
              SubcategoryListRoute(id: state.pathParameters["id"]!, type: "subcategory"),
        ),
        GoRoute(
          path: APP_PAGE.COMPANY_LIST.toPath,
          name: APP_PAGE.COMPANY_LIST.toName,
          redirect: AuthRedirector,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => SubcategoryListRoute(id: state.pathParameters["id"]!, type: "company"),
        ),
        GoRoute(
          path: APP_PAGE.COMPANY_LABEL_LIST.toPath,
          name: APP_PAGE.COMPANY_LABEL_LIST.toName,
          redirect: AuthRedirector,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => CompanyLabelListRoute(),
        ),
        GoRoute(
          path: APP_PAGE.COMPANY_PRODUCTS_LIST.toPath,
          name: APP_PAGE.COMPANY_PRODUCTS_LIST.toName,
          redirect: AuthRedirector,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => ProductListPage(
              type: "company", id: state.pathParameters["id"] ?? ""),
        ),
        GoRoute(
          path: APP_PAGE.CATEGORY_PRODUCTS_LIST.toPath,
          name: APP_PAGE.CATEGORY_PRODUCTS_LIST.toName,
          redirect: AuthRedirector,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => ProductListPage(
              type: "category", id: state.pathParameters["id"] ?? ""),
        ),
        GoRoute(
          path: APP_PAGE.CATALOG_SINGLE.toPath,
          name: APP_PAGE.CATALOG_SINGLE.toName,
          redirect: AuthRedirector,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) =>
              CatalogSingleRoute(id: state.pathParameters["id"]),
        ),
        GoRoute(
          path: APP_PAGE.CATALOG_COMPANY_LIST.toPath,
          name: APP_PAGE.CATALOG_COMPANY_LIST.toName,
          redirect: AuthRedirector,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) =>
              CatalogDetailRoute(companyId: state.pathParameters["companyId"]),
        ),
        GoRoute(
          path: APP_PAGE.BONUS_CARD_CAMERA.toPath,
          name: APP_PAGE.BONUS_CARD_CAMERA.toName,
          redirect: AuthRedirector,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => CameraRoute(),
        ),
        GoRoute(
          path: APP_PAGE.BONUS_CARD_DETAIL.toPath,
          name: APP_PAGE.BONUS_CARD_DETAIL.toName,
          redirect: AuthRedirector,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) =>
              BonusDetailPageRoute(id: state.pathParameters["id"]),
        ),
        GoRoute(
          path: APP_PAGE.BONUS_CARD_ADD.toPath,
          name: APP_PAGE.BONUS_CARD_ADD.toName,
          redirect: AuthRedirector,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) =>
              BonusAddRoute(code: state.pathParameters["code"]),
        ),
        GoRoute(
          path: APP_PAGE.ABOUT.toPath,
          name: APP_PAGE.ABOUT.toName,
          redirect: AuthRedirector,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => AboutUsRoute(),
        ),
        GoRoute(
          path: APP_PAGE.ONBOARD.toPath,
          name: APP_PAGE.ONBOARD.toName,
          redirect: AuthRedirector,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => OnboardRoute(),
        ),
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return Scaffold(
                extendBody: true,
                body: child,
                bottomNavigationBar: SizedBox(
                  height: 80,
                  child: BottomNavBar(
                    currentIndex: _getCurrentIndex(state),
                    onTap: (int index) {
                      _navigateToRoute(index);
                    },
                  ),
                ));
          },
          routes: [
            GoRoute(
              path: APP_PAGE.HOME.toPath,
              name: APP_PAGE.HOME.toName,
              redirect: AuthRedirector,
              builder: (context, state) => const HomePage(),
            ),
            GoRoute(
              path: APP_PAGE.FAVORITE.toPath,
              name: APP_PAGE.FAVORITE.toName,
              redirect: AuthRedirector,
              builder: (context, state) => const FavoriteMainRoute(),
            ),
            GoRoute(
              path: APP_PAGE.SETTING.toPath,
              name: APP_PAGE.SETTING.toName,
              redirect: AuthRedirector,
              builder: (context, state) => const SettingRoute(),
            ),
            GoRoute(
              path: APP_PAGE.CATALOG.toPath,
              name: APP_PAGE.CATALOG.toName,
              redirect: AuthRedirector,
              builder: (context, state) => CatalogMainRoute(),
            ),
            GoRoute(
              path: APP_PAGE.BONUS_CARD.toPath,
              name: APP_PAGE.BONUS_CARD.toName,
              redirect: AuthRedirector,
              builder: (context, state) => BonusHomeRoute(),
            ),
          ],
        ),
      ],
    );
  }

  GoRouter get router => _router();

  Future<String?> AuthRedirector(
      BuildContext context, GoRouterState state) async {
    var global = context.read<GlobalBloc>().state;
    print(global.packageStatus);
    if (global.packageStatus == GlobalStatus.loading) {
      return APP_PAGE.LOADING.toFullPath;
    }
    if (global.packageStatus == GlobalStatus.loaded &&
        state.fullPath == APP_PAGE.LOADING.toFullPath) {
      return initialPage;
    }
    return null;
  }
}
