// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i31;
import 'package:firebase_auth/firebase_auth.dart' as _i35;
import 'package:flutter/material.dart' as _i32;

import '../components/GlobalWidget.dart' as _i1;
import '../Pages/main/Bonus/BonusAdd.dart' as _i21;
import '../Pages/main/Bonus/BonusDetail.dart' as _i18;
import '../Pages/main/Bonus/BonusHome.dart' as _i19;
import '../Pages/main/Bonus/CameraQrScanner.dart' as _i20;
import '../Pages/main/Catalog/CatalogDetail.dart' as _i8;
import '../Pages/main/Catalog/CatalogMain.dart' as _i7;
import '../Pages/main/Catalog/CatalogSingle.dart' as _i9;
import '../Pages/main/Favorite/FavoriteMain.dart' as _i5;
import '../Pages/main/Home/CategoryGrid/CategoryBlocProvider.dart' as _i11;
import '../Pages/main/Home/CategorySelectionList/CategoryList.dart' as _i13;
import '../Pages/main/Home/CategorySelectionList/SubcategoryAndCompanyList.dart'
    as _i12;
import '../Pages/main/Home/DetailPage/DetailPageContainer.dart' as _i6;
import '../Pages/main/Home/DetailPage/Map.dart' as _i26;
import '../Pages/main/Home/FilterPage/FilterPageScaffold.dart' as _i15;
import '../Pages/main/Home/HomePage/HomePageContainer.dart' as _i3;
import '../Pages/main/Home/SearchPage/Search.dart' as _i4;
import '../Pages/main/List/ListDetail.dart' as _i23;
import '../Pages/main/List/ListHome.dart' as _i24;
import '../Pages/main/NeedRegister/index.dart' as _i22;
import '../Pages/main/Onboard/Onboard.dart' as _i25;
import '../Pages/main/Setting/AboutUs.dart' as _i10;
import '../Pages/main/Setting/Notification.dart' as _i16;
import '../Pages/main/Setting/Profile.dart' as _i17;
import '../Pages/main/Setting/Setting.dart' as _i14;
import '../Pages/Sign/Main.dart' as _i27;
import '../Pages/Sign/OTP/OTP.dart' as _i30;
import '../Pages/Sign/Register/RegistrationContainer.dart' as _i29;
import '../Pages/Sign/SignIn/SignIn.dart' as _i28;
import '../Pages/Sign/Wrapper.dart' as _i2;
import '../types/user.dart' as _i36;
import 'guard.dart' as _i33;
import 'permission.dart' as _i34;

class AppRouter extends _i31.RootStackRouter {
  AppRouter({
    _i32.GlobalKey<_i32.NavigatorState>? navigatorKey,
    required this.authGuard,
    required this.permissionGuard,
  }) : super(navigatorKey);

  final _i33.AuthGuard authGuard;

  final _i34.PermissionGuard permissionGuard;

  @override
  final Map<String, _i31.PageFactory> pagesMap = {
    GlobalWidgetRoute.name: (routeData) {
      return _i31.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.GlobalWidgetRoute(),
        transitionsBuilder: _i31.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    SingWrapper.name: (routeData) {
      return _i31.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.SingWrapper(),
      );
    },
    MainContainerRoute.name: (routeData) {
      return _i31.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i3.MainContainerRoute(),
        transitionsBuilder: _i31.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    SearchRouteRoute.name: (routeData) {
      final queryParams = routeData.queryParams;
      final args = routeData.argsAs<SearchRouteRouteArgs>(
          orElse: () => SearchRouteRouteArgs(
                categoryId: queryParams.optString('categoryId'),
                subcategoryId: queryParams.optString('subcategoryId'),
                companyId: queryParams.optString('companyId'),
                params: queryParams.getString(
                  'params',
                  '',
                ),
              ));
      return _i31.CustomPage<dynamic>(
        routeData: routeData,
        child: _i4.SearchPageRoute(
          key: args.key,
          categoryId: args.categoryId,
          subcategoryId: args.subcategoryId,
          companyId: args.companyId,
          params: args.params,
        ),
        transitionsBuilder: _i31.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    FavoriteMainRoute.name: (routeData) {
      return _i31.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i5.FavoriteMainRoute(),
        transitionsBuilder: _i31.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    DetailRouteContainerRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<DetailRouteContainerRouteArgs>(
          orElse: () => DetailRouteContainerRouteArgs(
                  id: pathParams.getString(
                'id',
                "",
              )));
      return _i31.CustomPage<dynamic>(
        routeData: routeData,
        child: _i6.DetailPageContainerRoute(
          key: args.key,
          id: args.id,
        ),
        transitionsBuilder: _i31.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    CatalogMainRoute.name: (routeData) {
      return _i31.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i7.CatalogMainRoute(),
        transitionsBuilder: _i31.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    CatalogDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<CatalogDetailRouteArgs>(
          orElse: () => CatalogDetailRouteArgs(
              companyId: pathParams.optString('companyId')));
      return _i31.CustomPage<dynamic>(
        routeData: routeData,
        child: _i8.CatalogDetailRoute(
          key: args.key,
          companyId: args.companyId,
        ),
        transitionsBuilder: _i31.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    CatalogSingleRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<CatalogSingleRouteArgs>(
          orElse: () => CatalogSingleRouteArgs(id: pathParams.optString('id')));
      return _i31.CustomPage<dynamic>(
        routeData: routeData,
        child: _i9.CatalogSingleRoute(
          key: args.key,
          id: args.id,
        ),
        transitionsBuilder: _i31.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    AboutUsRoute.name: (routeData) {
      return _i31.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i10.AboutUsRoute(),
        transitionsBuilder: _i31.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    CategoryBlocProviderRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<CategoryBlocProviderRouteArgs>(
          orElse: () => CategoryBlocProviderRouteArgs(
                id: pathParams.optString('id'),
                subcategoryId: pathParams.optString('subcategoryId'),
                type: pathParams.getString('type'),
              ));
      return _i31.CustomPage<dynamic>(
        routeData: routeData,
        child: _i11.CategoryBlocProviderRoute(
          key: args.key,
          id: args.id,
          subcategoryId: args.subcategoryId,
          type: args.type,
        ),
        transitionsBuilder: _i31.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    SubcategoryListRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<SubcategoryListRouteArgs>(
          orElse: () => SubcategoryListRouteArgs(
                id: pathParams.optString('id'),
                type: pathParams.optString('type'),
              ));
      return _i31.CustomPage<dynamic>(
        routeData: routeData,
        child: _i12.SubcategoryListRoute(
          key: args.key,
          id: args.id,
          type: args.type,
        ),
        transitionsBuilder: _i31.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    CategoryListRoute.name: (routeData) {
      return _i31.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i13.CategoryListRoute(),
        transitionsBuilder: _i31.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    SettingRoute.name: (routeData) {
      return _i31.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i14.SettingRoute(),
        transitionsBuilder: _i31.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    FilterRouteScaffoldRoute.name: (routeData) {
      return _i31.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i15.FilterPageScaffoldRoute(),
        transitionsBuilder: _i31.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    NotificationRouteRoute.name: (routeData) {
      return _i31.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i16.NotificationPageRoute(),
        transitionsBuilder: _i31.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProfileRoute.name: (routeData) {
      return _i31.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i17.ProfileRoute(),
        transitionsBuilder: _i31.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    BonusDetailRouteRoute.name: (routeData) {
      final args = routeData.argsAs<BonusDetailRouteRouteArgs>();
      return _i31.CustomPage<dynamic>(
        routeData: routeData,
        child: _i18.BonusDetailPageRoute(
          key: args.key,
          card: args.card,
        ),
        transitionsBuilder: _i31.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    BonusHomeRoute.name: (routeData) {
      return _i31.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i19.BonusHomeRoute(),
        transitionsBuilder: _i31.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    CameraRoute.name: (routeData) {
      return _i31.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i20.CameraRoute(),
        transitionsBuilder: _i31.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    BonusAddRoute.name: (routeData) {
      final args = routeData.argsAs<BonusAddRouteArgs>(
          orElse: () => const BonusAddRouteArgs());
      return _i31.CustomPage<dynamic>(
        routeData: routeData,
        child: _i21.BonusAddRoute(
          key: args.key,
          code: args.code,
        ),
        transitionsBuilder: _i31.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    NeedRegisterRoute.name: (routeData) {
      final args = routeData.argsAs<NeedRegisterRouteArgs>(
          orElse: () => const NeedRegisterRouteArgs());
      return _i31.CustomPage<dynamic>(
        routeData: routeData,
        child: _i22.NeedRegisterRoute(
          key: args.key,
          activeTab: args.activeTab,
        ),
        transitionsBuilder: _i31.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ListDetailRoute.name: (routeData) {
      return _i31.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i23.ListDetailRoute(),
        transitionsBuilder: _i31.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ListHomeRoute.name: (routeData) {
      return _i31.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i24.ListHomeRoute(),
        transitionsBuilder: _i31.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    OnboardRoute.name: (routeData) {
      return _i31.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i25.OnboardRoute(),
        transitionsBuilder: _i31.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    MapRouteRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<MapRouteRouteArgs>(
          orElse: () => MapRouteRouteArgs(id: pathParams.optString('id')));
      return _i31.CustomPage<dynamic>(
        routeData: routeData,
        child: _i26.MapPageRoute(
          key: args.key,
          id: args.id,
        ),
        transitionsBuilder: _i31.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    SignRoute.name: (routeData) {
      return _i31.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i27.SignRoute(),
        transitionsBuilder: _i31.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    SignInRoute.name: (routeData) {
      return _i31.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i28.SignInRoute(),
        transitionsBuilder: _i31.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    RegistrationContainerRoute.name: (routeData) {
      return _i31.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i29.RegistrationContainerRoute(),
        transitionsBuilder: _i31.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    OTP.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<OTPArgs>(
          orElse: () => OTPArgs(
                  phone: pathParams.getString(
                'phone',
                "",
              )));
      return _i31.CustomPage<_i35.PhoneAuthCredential>(
        routeData: routeData,
        child: _i30.OTP(
          key: args.key,
          phone: args.phone,
        ),
        transitionsBuilder: _i31.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
  };

  @override
  List<_i31.RouteConfig> get routes => [
        _i31.RouteConfig(
          GlobalWidgetRoute.name,
          path: '/',
          guards: [authGuard],
          children: [
            _i31.RouteConfig(
              MainContainerRoute.name,
              path: '',
              parent: GlobalWidgetRoute.name,
            ),
            _i31.RouteConfig(
              SearchRouteRoute.name,
              path: 'search',
              parent: GlobalWidgetRoute.name,
            ),
            _i31.RouteConfig(
              FavoriteMainRoute.name,
              path: 'favorite',
              parent: GlobalWidgetRoute.name,
              guards: [permissionGuard],
            ),
            _i31.RouteConfig(
              DetailRouteContainerRoute.name,
              path: 'home/detail/:id',
              parent: GlobalWidgetRoute.name,
            ),
            _i31.RouteConfig(
              CatalogMainRoute.name,
              path: 'catalog',
              parent: GlobalWidgetRoute.name,
            ),
            _i31.RouteConfig(
              CatalogDetailRoute.name,
              path: 'catalog/detail/:companyId',
              parent: GlobalWidgetRoute.name,
            ),
            _i31.RouteConfig(
              CatalogSingleRoute.name,
              path: 'catalog/single/:id',
              parent: GlobalWidgetRoute.name,
            ),
            _i31.RouteConfig(
              AboutUsRoute.name,
              path: 'about',
              parent: GlobalWidgetRoute.name,
            ),
            _i31.RouteConfig(
              CategoryBlocProviderRoute.name,
              path: ':type/products/:id/:subcategoryId',
              parent: GlobalWidgetRoute.name,
            ),
            _i31.RouteConfig(
              SubcategoryListRoute.name,
              path: ':type/list/:id',
              parent: GlobalWidgetRoute.name,
            ),
            _i31.RouteConfig(
              CategoryListRoute.name,
              path: 'category/list',
              parent: GlobalWidgetRoute.name,
            ),
            _i31.RouteConfig(
              SettingRoute.name,
              path: 'setting',
              parent: GlobalWidgetRoute.name,
            ),
            _i31.RouteConfig(
              FilterRouteScaffoldRoute.name,
              path: 'home/filter',
              parent: GlobalWidgetRoute.name,
            ),
            _i31.RouteConfig(
              NotificationRouteRoute.name,
              path: 'notification',
              parent: GlobalWidgetRoute.name,
            ),
            _i31.RouteConfig(
              ProfileRoute.name,
              path: 'profile',
              parent: GlobalWidgetRoute.name,
              guards: [permissionGuard],
            ),
            _i31.RouteConfig(
              BonusDetailRouteRoute.name,
              path: 'bonus/detail/:id',
              parent: GlobalWidgetRoute.name,
              guards: [permissionGuard],
            ),
            _i31.RouteConfig(
              BonusHomeRoute.name,
              path: 'bonus',
              parent: GlobalWidgetRoute.name,
              guards: [permissionGuard],
            ),
            _i31.RouteConfig(
              CameraRoute.name,
              path: 'bonus/camera',
              parent: GlobalWidgetRoute.name,
              guards: [permissionGuard],
            ),
            _i31.RouteConfig(
              BonusAddRoute.name,
              path: 'bonus/add/:code',
              parent: GlobalWidgetRoute.name,
              guards: [permissionGuard],
            ),
            _i31.RouteConfig(
              NeedRegisterRoute.name,
              path: 'needRegister',
              parent: GlobalWidgetRoute.name,
            ),
            _i31.RouteConfig(
              ListDetailRoute.name,
              path: 'list/single',
              parent: GlobalWidgetRoute.name,
              guards: [permissionGuard],
            ),
            _i31.RouteConfig(
              ListHomeRoute.name,
              path: 'list',
              parent: GlobalWidgetRoute.name,
              guards: [permissionGuard],
            ),
            _i31.RouteConfig(
              OnboardRoute.name,
              path: 'onboard',
              parent: GlobalWidgetRoute.name,
            ),
            _i31.RouteConfig(
              MapRouteRoute.name,
              path: 'detail/map/:id',
              parent: GlobalWidgetRoute.name,
            ),
          ],
        ),
        _i31.RouteConfig(
          SingWrapper.name,
          path: '/sign',
          children: [
            _i31.RouteConfig(
              SignRoute.name,
              path: 'main',
              parent: SingWrapper.name,
            ),
            _i31.RouteConfig(
              SignInRoute.name,
              path: 'signin',
              parent: SingWrapper.name,
            ),
            _i31.RouteConfig(
              RegistrationContainerRoute.name,
              path: 'registration',
              parent: SingWrapper.name,
            ),
            _i31.RouteConfig(
              OTP.name,
              path: 'otp/:phone',
              parent: SingWrapper.name,
            ),
          ],
        ),
      ];
}

/// generated route for
/// [_i1.GlobalWidgetRoute]
class GlobalWidgetRoute extends _i31.PageRouteInfo<void> {
  const GlobalWidgetRoute({List<_i31.PageRouteInfo>? children})
      : super(
          GlobalWidgetRoute.name,
          path: '/',
          initialChildren: children,
        );

  static const String name = 'GlobalWidgetRoute';
}

/// generated route for
/// [_i2.SingWrapper]
class SingWrapper extends _i31.PageRouteInfo<void> {
  const SingWrapper({List<_i31.PageRouteInfo>? children})
      : super(
          SingWrapper.name,
          path: '/sign',
          initialChildren: children,
        );

  static const String name = 'SingWrapper';
}

/// generated route for
/// [_i3.MainContainerRoute]
class MainContainerRoute extends _i31.PageRouteInfo<void> {
  const MainContainerRoute()
      : super(
          MainContainerRoute.name,
          path: '',
        );

  static const String name = 'MainContainerRoute';
}

/// generated route for
/// [_i4.SearchPageRoute]
class SearchRouteRoute extends _i31.PageRouteInfo<SearchRouteRouteArgs> {
  SearchRouteRoute({
    _i32.Key? key,
    String? categoryId,
    String? subcategoryId,
    String? companyId,
    String params = '',
  }) : super(
          SearchRouteRoute.name,
          path: 'search',
          args: SearchRouteRouteArgs(
            key: key,
            categoryId: categoryId,
            subcategoryId: subcategoryId,
            companyId: companyId,
            params: params,
          ),
          rawQueryParams: {
            'categoryId': categoryId,
            'subcategoryId': subcategoryId,
            'companyId': companyId,
            'params': params,
          },
        );

  static const String name = 'SearchRouteRoute';
}

class SearchRouteRouteArgs {
  const SearchRouteRouteArgs({
    this.key,
    this.categoryId,
    this.subcategoryId,
    this.companyId,
    this.params = '',
  });

  final _i32.Key? key;

  final String? categoryId;

  final String? subcategoryId;

  final String? companyId;

  final String params;

  @override
  String toString() {
    return 'SearchRouteRouteArgs{key: $key, categoryId: $categoryId, subcategoryId: $subcategoryId, companyId: $companyId, params: $params}';
  }
}

/// generated route for
/// [_i5.FavoriteMainRoute]
class FavoriteMainRoute extends _i31.PageRouteInfo<void> {
  const FavoriteMainRoute()
      : super(
          FavoriteMainRoute.name,
          path: 'favorite',
        );

  static const String name = 'FavoriteMainRoute';
}

/// generated route for
/// [_i6.DetailPageContainerRoute]
class DetailRouteContainerRoute
    extends _i31.PageRouteInfo<DetailRouteContainerRouteArgs> {
  DetailRouteContainerRoute({
    _i32.Key? key,
    String id = "",
  }) : super(
          DetailRouteContainerRoute.name,
          path: 'home/detail/:id',
          args: DetailRouteContainerRouteArgs(
            key: key,
            id: id,
          ),
          rawPathParams: {'id': id},
        );

  static const String name = 'DetailRouteContainerRoute';
}

class DetailRouteContainerRouteArgs {
  const DetailRouteContainerRouteArgs({
    this.key,
    this.id = "",
  });

  final _i32.Key? key;

  final String id;

  @override
  String toString() {
    return 'DetailRouteContainerRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i7.CatalogMainRoute]
class CatalogMainRoute extends _i31.PageRouteInfo<void> {
  const CatalogMainRoute()
      : super(
          CatalogMainRoute.name,
          path: 'catalog',
        );

  static const String name = 'CatalogMainRoute';
}

/// generated route for
/// [_i8.CatalogDetailRoute]
class CatalogDetailRoute extends _i31.PageRouteInfo<CatalogDetailRouteArgs> {
  CatalogDetailRoute({
    _i32.Key? key,
    String? companyId,
  }) : super(
          CatalogDetailRoute.name,
          path: 'catalog/detail/:companyId',
          args: CatalogDetailRouteArgs(
            key: key,
            companyId: companyId,
          ),
          rawPathParams: {'companyId': companyId},
        );

  static const String name = 'CatalogDetailRoute';
}

class CatalogDetailRouteArgs {
  const CatalogDetailRouteArgs({
    this.key,
    this.companyId,
  });

  final _i32.Key? key;

  final String? companyId;

  @override
  String toString() {
    return 'CatalogDetailRouteArgs{key: $key, companyId: $companyId}';
  }
}

/// generated route for
/// [_i9.CatalogSingleRoute]
class CatalogSingleRoute extends _i31.PageRouteInfo<CatalogSingleRouteArgs> {
  CatalogSingleRoute({
    _i32.Key? key,
    String? id,
  }) : super(
          CatalogSingleRoute.name,
          path: 'catalog/single/:id',
          args: CatalogSingleRouteArgs(
            key: key,
            id: id,
          ),
          rawPathParams: {'id': id},
        );

  static const String name = 'CatalogSingleRoute';
}

class CatalogSingleRouteArgs {
  const CatalogSingleRouteArgs({
    this.key,
    this.id,
  });

  final _i32.Key? key;

  final String? id;

  @override
  String toString() {
    return 'CatalogSingleRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i10.AboutUsRoute]
class AboutUsRoute extends _i31.PageRouteInfo<void> {
  const AboutUsRoute()
      : super(
          AboutUsRoute.name,
          path: 'about',
        );

  static const String name = 'AboutUsRoute';
}

/// generated route for
/// [_i11.CategoryBlocProviderRoute]
class CategoryBlocProviderRoute
    extends _i31.PageRouteInfo<CategoryBlocProviderRouteArgs> {
  CategoryBlocProviderRoute({
    _i32.Key? key,
    String? id,
    String? subcategoryId,
    required String type,
  }) : super(
          CategoryBlocProviderRoute.name,
          path: ':type/products/:id/:subcategoryId',
          args: CategoryBlocProviderRouteArgs(
            key: key,
            id: id,
            subcategoryId: subcategoryId,
            type: type,
          ),
          rawPathParams: {
            'id': id,
            'subcategoryId': subcategoryId,
            'type': type,
          },
        );

  static const String name = 'CategoryBlocProviderRoute';
}

class CategoryBlocProviderRouteArgs {
  const CategoryBlocProviderRouteArgs({
    this.key,
    this.id,
    this.subcategoryId,
    required this.type,
  });

  final _i32.Key? key;

  final String? id;

  final String? subcategoryId;

  final String type;

  @override
  String toString() {
    return 'CategoryBlocProviderRouteArgs{key: $key, id: $id, subcategoryId: $subcategoryId, type: $type}';
  }
}

/// generated route for
/// [_i12.SubcategoryListRoute]
class SubcategoryListRoute
    extends _i31.PageRouteInfo<SubcategoryListRouteArgs> {
  SubcategoryListRoute({
    _i32.Key? key,
    String? id,
    String? type,
  }) : super(
          SubcategoryListRoute.name,
          path: ':type/list/:id',
          args: SubcategoryListRouteArgs(
            key: key,
            id: id,
            type: type,
          ),
          rawPathParams: {
            'id': id,
            'type': type,
          },
        );

  static const String name = 'SubcategoryListRoute';
}

class SubcategoryListRouteArgs {
  const SubcategoryListRouteArgs({
    this.key,
    this.id,
    this.type,
  });

  final _i32.Key? key;

  final String? id;

  final String? type;

  @override
  String toString() {
    return 'SubcategoryListRouteArgs{key: $key, id: $id, type: $type}';
  }
}

/// generated route for
/// [_i13.CategoryListRoute]
class CategoryListRoute extends _i31.PageRouteInfo<void> {
  const CategoryListRoute()
      : super(
          CategoryListRoute.name,
          path: 'category/list',
        );

  static const String name = 'CategoryListRoute';
}

/// generated route for
/// [_i14.SettingRoute]
class SettingRoute extends _i31.PageRouteInfo<void> {
  const SettingRoute()
      : super(
          SettingRoute.name,
          path: 'setting',
        );

  static const String name = 'SettingRoute';
}

/// generated route for
/// [_i15.FilterPageScaffoldRoute]
class FilterRouteScaffoldRoute extends _i31.PageRouteInfo<void> {
  const FilterRouteScaffoldRoute()
      : super(
          FilterRouteScaffoldRoute.name,
          path: 'home/filter',
        );

  static const String name = 'FilterRouteScaffoldRoute';
}

/// generated route for
/// [_i16.NotificationPageRoute]
class NotificationRouteRoute extends _i31.PageRouteInfo<void> {
  const NotificationRouteRoute()
      : super(
          NotificationRouteRoute.name,
          path: 'notification',
        );

  static const String name = 'NotificationRouteRoute';
}

/// generated route for
/// [_i17.ProfileRoute]
class ProfileRoute extends _i31.PageRouteInfo<void> {
  const ProfileRoute()
      : super(
          ProfileRoute.name,
          path: 'profile',
        );

  static const String name = 'ProfileRoute';
}

/// generated route for
/// [_i18.BonusDetailPageRoute]
class BonusDetailRouteRoute
    extends _i31.PageRouteInfo<BonusDetailRouteRouteArgs> {
  BonusDetailRouteRoute({
    _i32.Key? key,
    required _i36.BonusCard card,
  }) : super(
          BonusDetailRouteRoute.name,
          path: 'bonus/detail/:id',
          args: BonusDetailRouteRouteArgs(
            key: key,
            card: card,
          ),
        );

  static const String name = 'BonusDetailRouteRoute';
}

class BonusDetailRouteRouteArgs {
  const BonusDetailRouteRouteArgs({
    this.key,
    required this.card,
  });

  final _i32.Key? key;

  final _i36.BonusCard card;

  @override
  String toString() {
    return 'BonusDetailRouteRouteArgs{key: $key, card: $card}';
  }
}

/// generated route for
/// [_i19.BonusHomeRoute]
class BonusHomeRoute extends _i31.PageRouteInfo<void> {
  const BonusHomeRoute()
      : super(
          BonusHomeRoute.name,
          path: 'bonus',
        );

  static const String name = 'BonusHomeRoute';
}

/// generated route for
/// [_i20.CameraRoute]
class CameraRoute extends _i31.PageRouteInfo<void> {
  const CameraRoute()
      : super(
          CameraRoute.name,
          path: 'bonus/camera',
        );

  static const String name = 'CameraRoute';
}

/// generated route for
/// [_i21.BonusAddRoute]
class BonusAddRoute extends _i31.PageRouteInfo<BonusAddRouteArgs> {
  BonusAddRoute({
    _i32.Key? key,
    String? code,
  }) : super(
          BonusAddRoute.name,
          path: 'bonus/add/:code',
          args: BonusAddRouteArgs(
            key: key,
            code: code,
          ),
        );

  static const String name = 'BonusAddRoute';
}

class BonusAddRouteArgs {
  const BonusAddRouteArgs({
    this.key,
    this.code,
  });

  final _i32.Key? key;

  final String? code;

  @override
  String toString() {
    return 'BonusAddRouteArgs{key: $key, code: $code}';
  }
}

/// generated route for
/// [_i22.NeedRegisterRoute]
class NeedRegisterRoute extends _i31.PageRouteInfo<NeedRegisterRouteArgs> {
  NeedRegisterRoute({
    _i32.Key? key,
    bool? activeTab,
  }) : super(
          NeedRegisterRoute.name,
          path: 'needRegister',
          args: NeedRegisterRouteArgs(
            key: key,
            activeTab: activeTab,
          ),
        );

  static const String name = 'NeedRegisterRoute';
}

class NeedRegisterRouteArgs {
  const NeedRegisterRouteArgs({
    this.key,
    this.activeTab,
  });

  final _i32.Key? key;

  final bool? activeTab;

  @override
  String toString() {
    return 'NeedRegisterRouteArgs{key: $key, activeTab: $activeTab}';
  }
}

/// generated route for
/// [_i23.ListDetailRoute]
class ListDetailRoute extends _i31.PageRouteInfo<void> {
  const ListDetailRoute()
      : super(
          ListDetailRoute.name,
          path: 'list/single',
        );

  static const String name = 'ListDetailRoute';
}

/// generated route for
/// [_i24.ListHomeRoute]
class ListHomeRoute extends _i31.PageRouteInfo<void> {
  const ListHomeRoute()
      : super(
          ListHomeRoute.name,
          path: 'list',
        );

  static const String name = 'ListHomeRoute';
}

/// generated route for
/// [_i25.OnboardRoute]
class OnboardRoute extends _i31.PageRouteInfo<void> {
  const OnboardRoute()
      : super(
          OnboardRoute.name,
          path: 'onboard',
        );

  static const String name = 'OnboardRoute';
}

/// generated route for
/// [_i26.MapPageRoute]
class MapRouteRoute extends _i31.PageRouteInfo<MapRouteRouteArgs> {
  MapRouteRoute({
    _i32.Key? key,
    required String? id,
  }) : super(
          MapRouteRoute.name,
          path: 'detail/map/:id',
          args: MapRouteRouteArgs(
            key: key,
            id: id,
          ),
          rawPathParams: {'id': id},
        );

  static const String name = 'MapRouteRoute';
}

class MapRouteRouteArgs {
  const MapRouteRouteArgs({
    this.key,
    required this.id,
  });

  final _i32.Key? key;

  final String? id;

  @override
  String toString() {
    return 'MapRouteRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i27.SignRoute]
class SignRoute extends _i31.PageRouteInfo<void> {
  const SignRoute()
      : super(
          SignRoute.name,
          path: 'main',
        );

  static const String name = 'SignRoute';
}

/// generated route for
/// [_i28.SignInRoute]
class SignInRoute extends _i31.PageRouteInfo<void> {
  const SignInRoute()
      : super(
          SignInRoute.name,
          path: 'signin',
        );

  static const String name = 'SignInRoute';
}

/// generated route for
/// [_i29.RegistrationContainerRoute]
class RegistrationContainerRoute extends _i31.PageRouteInfo<void> {
  const RegistrationContainerRoute()
      : super(
          RegistrationContainerRoute.name,
          path: 'registration',
        );

  static const String name = 'RegistrationContainerRoute';
}

/// generated route for
/// [_i30.OTP]
class OTP extends _i31.PageRouteInfo<OTPArgs> {
  OTP({
    _i32.Key? key,
    String phone = "",
  }) : super(
          OTP.name,
          path: 'otp/:phone',
          args: OTPArgs(
            key: key,
            phone: phone,
          ),
          rawPathParams: {'phone': phone},
        );

  static const String name = 'OTP';
}

class OTPArgs {
  const OTPArgs({
    this.key,
    this.phone = "",
  });

  final _i32.Key? key;

  final String phone;

  @override
  String toString() {
    return 'OTPArgs{key: $key, phone: $phone}';
  }
}