import 'package:auto_route/auto_route.dart';
import 'package:endy/Pages/Sign/Main.dart';
import 'package:endy/Pages/Sign/OTP/OTP.dart';
import 'package:endy/Pages/Sign/Register/RegistrationContainer.dart';
import 'package:endy/Pages/Sign/SignIn/SignIn.dart';
import 'package:endy/Pages/Sign/Wrapper.dart';
import 'package:endy/Pages/main/Bonus/BonusAdd.dart';
import 'package:endy/Pages/main/Bonus/BonusDetail.dart';
import 'package:endy/Pages/main/Bonus/BonusHome.dart';
import 'package:endy/Pages/main/Bonus/CameraQrScanner.dart';
import 'package:endy/Pages/main/Catalog/CatalogDetail.dart';
import 'package:endy/Pages/main/Catalog/CatalogMain.dart';
import 'package:endy/Pages/main/Catalog/CatalogSingle.dart';
import 'package:endy/Pages/main/Favorite/FavoriteMain.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/CategoryBlocProvider.dart';
import 'package:endy/Pages/main/Home/CategorySelectionList/CategoryList.dart';
import 'package:endy/Pages/main/Home/CategorySelectionList/SubcategoryAndCompanyList.dart';
import 'package:endy/Pages/main/Home/DetailPage/DetailPageContainer.dart';
import 'package:endy/Pages/main/Home/DetailPage/Map.dart';
import 'package:endy/Pages/main/Home/FilterPage/FilterPageScaffold.dart';
import 'package:endy/Pages/main/Home/HomePage/HomePage.dart';
import 'package:endy/Pages/main/Home/HomePage/HomePageContainer.dart';
import 'package:endy/Pages/main/Home/SearchPage/Search.dart';
import 'package:endy/Pages/main/List/ListDetail.dart';
import 'package:endy/Pages/main/List/ListHome.dart';
import 'package:endy/Pages/main/NeedRegister/index.dart';
import 'package:endy/Pages/main/Onboard/Onboard.dart';
import 'package:endy/Pages/main/Setting/AboutUs.dart';
import 'package:endy/Pages/main/Setting/Notification.dart';
import 'package:endy/Pages/main/Setting/Profile.dart';
import 'package:endy/Pages/main/Setting/Setting.dart';
import 'package:endy/components/GlobalWidget.dart';
import 'package:endy/route/guard.dart';
import 'package:endy/route/permission.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Pages/main/Home/CategorySelectionList/CompanyLabelList.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    CustomRoute(page: GlobalWidgetRoute, transitionsBuilder: TransitionsBuilders.noTransition, path: "/", guards: [
      AuthGuard
    ], children: [
      CustomRoute(transitionsBuilder: TransitionsBuilders.noTransition, page: MainContainerRoute, path: "", initial: true,), // DM NavFooter
      CustomRoute(transitionsBuilder: TransitionsBuilders.noTransition, page: HomePage, path: "home",), // DM NavFooter
      CustomRoute(transitionsBuilder: TransitionsBuilders.noTransition, page: FavoriteMainRoute, path: "favorite", guards: [ PermissionGuard ] ), // DM NavFooter
      CustomRoute(transitionsBuilder: TransitionsBuilders.noTransition, page: CatalogMainRoute, path: "catalog"), // DM NavFooter
      CustomRoute(transitionsBuilder: TransitionsBuilders.noTransition, page: CatalogSingleRoute, path: "catalog/single/:id"), // DM NavFooter
      CustomRoute(transitionsBuilder: TransitionsBuilders.noTransition, page: CatalogDetailRoute, path: "catalog/detail/:companyId"), // DM NavFooter
      CustomRoute(transitionsBuilder: TransitionsBuilders.noTransition, page: AboutUsRoute, path: "about"), // DM NavFooter
      CustomRoute(transitionsBuilder: TransitionsBuilders.noTransition, page: CategoryListRoute, path: "category/list"), // NoD M NoNavFooter
      CustomRoute(transitionsBuilder: TransitionsBuilders.noTransition, page: SubcategoryListRoute, path: ":type/list/:id"), // NoD M NoNavFooter - params: Company List or Subcategory List
      CustomRoute(transitionsBuilder: TransitionsBuilders.noTransition, page: DetailPageContainerRoute, path: "home/detail/:id"), // DM NavFooter
      CustomRoute(transitionsBuilder: TransitionsBuilders.noTransition, page: CompanyLabelListRoute, path: "companyLabel/list"), // NoD M NoNavFooter
      CustomRoute(transitionsBuilder: TransitionsBuilders.noTransition, page: FilterPageScaffoldRoute, path: "home/filter"), //NoD M NoNavFooter
      CustomRoute(transitionsBuilder: TransitionsBuilders.noTransition, page: OnboardRoute, path: "onboard"), // DM NoNavFooter
      CustomRoute(transitionsBuilder: TransitionsBuilders.noTransition, page: NeedRegisterRoute, path: "needRegister"), // DM NavFooter
      
      CustomRoute(transitionsBuilder: TransitionsBuilders.noTransition, page: CategoryBlocProviderRoute, path: ":type/products/:id/:subcategoryId"), // DM NavFooter


      CustomRoute(transitionsBuilder: TransitionsBuilders.noTransition, page: MapPageRoute, path: "detail/map/:id"), // DM NoNavFooter
      CustomRoute(transitionsBuilder: TransitionsBuilders.noTransition, page: ProfileRoute, path: "profile", guards: [ PermissionGuard ]), // DM NavFooter
      CustomRoute(transitionsBuilder: TransitionsBuilders.noTransition, page: SearchPageRoute, path: "search"), // DM NavFooter
      CustomRoute(transitionsBuilder: TransitionsBuilders.noTransition, page: NotificationPageRoute, path: "notification"), // NoD M NoNavFooter
      CustomRoute(transitionsBuilder: TransitionsBuilders.noTransition, page: SettingRoute, path: "setting"), // NoD M NoNavFooter
      CustomRoute(transitionsBuilder: TransitionsBuilders.noTransition, page: BonusDetailPageRoute, path: "bonus/detail/:id", guards: [ PermissionGuard ]), // NoD M NoNavFooter
      CustomRoute(transitionsBuilder: TransitionsBuilders.noTransition, page: BonusHomeRoute, path: "bonus", guards: [ PermissionGuard ]), // NoD M NoNavFooter
      CustomRoute(transitionsBuilder: TransitionsBuilders.noTransition, page: CameraRoute, path: "bonus/camera", guards: [ PermissionGuard ]), // NoD M NoNavFooter
      CustomRoute(transitionsBuilder: TransitionsBuilders.noTransition, page: BonusAddRoute, path: "bonus/add/:code", guards: [ PermissionGuard ]), // NoD M NoNavFooter
      CustomRoute(transitionsBuilder: TransitionsBuilders.noTransition, page: ListDetailRoute, path: "list/detail/:id", guards: [ PermissionGuard ]), // NoD M NoNavFooter
      CustomRoute(transitionsBuilder: TransitionsBuilders.noTransition, page: ListHomeRoute, path: "list", guards: [ PermissionGuard ]), // NoD M NoNavFooter
    ]),
    // Need to add 2 guards: 1 for auth redirect if logged in, 2 for showing web users that you need to download app in order to use these features
    // And also test dynamic routes if wrong params goes
    
    CustomRoute(path: "/sign", transitionsBuilder: TransitionsBuilders.noTransition, page: SingWrapper, children: [
      CustomRoute(transitionsBuilder: TransitionsBuilders.noTransition, page: SignRoute, path: "main"), // DM
      CustomRoute(transitionsBuilder: TransitionsBuilders.noTransition, page: SignInRoute, path: "signin"), // DM
      CustomRoute(transitionsBuilder: TransitionsBuilders.noTransition, page: RegistrationContainerRoute, path: "registration"), //DM
      CustomRoute<PhoneAuthCredential>(transitionsBuilder: TransitionsBuilders.noTransition, page: OTP, path: "otp/:phone"), // DM
    ]),
    // Also add a not found page => It currently redirects to home page but it should redirect to a not found page
    RedirectRoute(redirectTo: "/" , path: "*"),
  ],
)
class $AppRouter {}
