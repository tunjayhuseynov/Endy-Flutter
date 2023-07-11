enum APP_PAGE {
  HOME,
  FAVORITE,
  ABOUT,
  CATALOG,
  CATALOG_SINGLE,
  CATALOG_COMPANY_LIST,
  CATEGORY_LIST,
  SUBCATEGORY_LIST,
  COMPANY_LIST,
  COMPANY_LABEL_LIST,
  FILTER,
  ONBOARD,
  UNAUTHORIZATION,
  PRODUCT_DETAIL,
  CATEGORY_PRODUCTS_LIST,
  COMPANY_PRODUCTS_LIST,
  PRODUCT_MAP,
  PROFILE,
  SEARCH,
  NOTIFICATION,
  SETTING,
  BONUS_CARD_DETAIL,
  BONUS_CARD,
  BONUS_CARD_CAMERA,
  BONUS_CARD_ADD,
  SHOPPING_LIST,
  SHOPPING_LIST_DETAIL,
  SIGN_MAIN,
  SIGN_IN,
  SIGN_UP,
  OTP,
  LOADING
}

extension APP_PAGE_FEATURES on APP_PAGE {
  String get toFullPath {
    switch (this) {
      case APP_PAGE.LOADING:
        return "/loading";
      case APP_PAGE.HOME:
        return "/";
      case APP_PAGE.UNAUTHORIZATION:
        return "/unauthorization";
      case APP_PAGE.NOTIFICATION:
        return "/notification";
      case APP_PAGE.FILTER:
        return "/filter";
      case APP_PAGE.FAVORITE:
        return "/favorite";
      case APP_PAGE.PRODUCT_DETAIL:
        return "/product/:id";
      case APP_PAGE.PRODUCT_MAP:
        return "/product/:id/map";

      case APP_PAGE.PROFILE:
        return "/profile";
      case APP_PAGE.SETTING:
        return "/setting";
      case APP_PAGE.SEARCH:
        return "/search";

      case APP_PAGE.SHOPPING_LIST:
        return "/shopping-list";
      case APP_PAGE.SHOPPING_LIST_DETAIL:
        return "/shopping-list/:id";

      case APP_PAGE.CATEGORY_LIST:
        return "/category/list";
      case APP_PAGE.SUBCATEGORY_LIST:
        return "/subcategory/list/:id";
      case APP_PAGE.COMPANY_LIST:
        return "/company/list/:id";
      case APP_PAGE.COMPANY_LABEL_LIST:
        return "/company/list/label";
      case APP_PAGE.COMPANY_PRODUCTS_LIST:
        return "/company/products/:id";
      case APP_PAGE.CATEGORY_PRODUCTS_LIST:
        return "/category/products/:id";

      //AUTH
      case APP_PAGE.SIGN_IN:
        return "/auth/signin";
      case APP_PAGE.SIGN_UP:
        return "/auth/registration";
      case APP_PAGE.SIGN_MAIN:
        return "/auth";
      case APP_PAGE.OTP:
        return "/auth/otp/:phone";

      case APP_PAGE.CATALOG_SINGLE:
        return "/catalog/single/:id";
      case APP_PAGE.CATALOG_COMPANY_LIST:
        return "/catalog/company/:companyId";
      case APP_PAGE.CATALOG:
        return "/catalog";

      case APP_PAGE.BONUS_CARD_ADD:
        return "/bonus-card/add/:code";
      case APP_PAGE.BONUS_CARD_DETAIL:
        return "/bonus-card/detail/:id";
      case APP_PAGE.BONUS_CARD_CAMERA:
        return "/bonus-card/camera";
      case APP_PAGE.BONUS_CARD:
        return "/bonus-card";

      case APP_PAGE.ABOUT:
        return "/about";
      case APP_PAGE.ONBOARD:
        return "/onboard";
      default:
        return "";
    }
  }

  String get toPath {
    switch (this) {
      case APP_PAGE.LOADING:
        return "/loading";
      case APP_PAGE.HOME:
        return "/";
      case APP_PAGE.UNAUTHORIZATION:
        return "/unauthorization";
      case APP_PAGE.NOTIFICATION:
        return "/notification";
      case APP_PAGE.FILTER:
        return "/filter";
      case APP_PAGE.FAVORITE:
        return "/favorite";
      case APP_PAGE.PRODUCT_DETAIL:
        return "/product/:id";
      case APP_PAGE.PRODUCT_MAP:
        return "/product/:id/map";

      case APP_PAGE.PROFILE:
        return "/profile";
      case APP_PAGE.SETTING:
        return "/setting";
      case APP_PAGE.SEARCH:
        return "/search";

      case APP_PAGE.SHOPPING_LIST:
        return "/shopping-list";
      case APP_PAGE.SHOPPING_LIST_DETAIL:
        return "/shopping-list/:id";

      case APP_PAGE.CATEGORY_LIST:
        return "/category/list";
      case APP_PAGE.SUBCATEGORY_LIST:
        return "/subcategory/list/:id";
      case APP_PAGE.COMPANY_LIST:
        return "/company/list/:id";
      case APP_PAGE.COMPANY_LABEL_LIST:
        return "/company/list/label";
      case APP_PAGE.COMPANY_PRODUCTS_LIST:
        return "/company/products/:id";
      case APP_PAGE.CATEGORY_PRODUCTS_LIST:
        return "/category/products/:id";

      //AUTH
      case APP_PAGE.SIGN_IN:
        return "signin";
      case APP_PAGE.SIGN_UP:
        return "registration";
      case APP_PAGE.SIGN_MAIN:
        return "/auth";
      case APP_PAGE.OTP:
        return "otp/:phone";

      case APP_PAGE.CATALOG_SINGLE:
        return "/catalog/single/:id";
      case APP_PAGE.CATALOG_COMPANY_LIST:
        return "/catalog/company/:companyId";
      case APP_PAGE.CATALOG:
        return "/catalog";

      case APP_PAGE.BONUS_CARD_ADD:
        return "/bonus-card/add/:code";
      case APP_PAGE.BONUS_CARD_DETAIL:
        return "/bonus-card/detail/:id";
      case APP_PAGE.BONUS_CARD_CAMERA:
        return "/bonus-card/camera";
      case APP_PAGE.BONUS_CARD:
        return "/bonus-card";

      case APP_PAGE.ABOUT:
        return "/about";
      case APP_PAGE.ONBOARD:
        return "/onboard";
      default:
        return "/";
    }
  }

  String get toName {
    switch (this) {
      case APP_PAGE.LOADING:
        return "LOADING";
      case APP_PAGE.HOME:
        return "HOME";
      case APP_PAGE.UNAUTHORIZATION:
        return "UNAUTHORIZATION";
      case APP_PAGE.NOTIFICATION:
        return "NOTIFICATION";
      case APP_PAGE.FILTER:
        return "FILTER";
      case APP_PAGE.FAVORITE:
        return "FAVORITE";
      case APP_PAGE.PRODUCT_DETAIL:
        return "PRODUCT_DETAIL";
      case APP_PAGE.PRODUCT_MAP:
        return "PRODUCT_MAP";

      case APP_PAGE.PROFILE:
        return "PROFILE";
      case APP_PAGE.SETTING:
        return "SETTING";
      case APP_PAGE.SEARCH:
        return "SEARCH";

      case APP_PAGE.SHOPPING_LIST:
        return "SHOPPING_LIST";
      case APP_PAGE.SHOPPING_LIST_DETAIL:
        return "SHOPPING_LIST_DETAIL";

      case APP_PAGE.CATEGORY_LIST:
        return "CATEGORY_LIST";
      case APP_PAGE.SUBCATEGORY_LIST:
        return "SUBCATEGORY_LIST";
      case APP_PAGE.COMPANY_LIST:
        return "COMPANY_LIST";
      case APP_PAGE.COMPANY_LABEL_LIST:
        return "COMPANY_LABEL_LIST";
      case APP_PAGE.COMPANY_PRODUCTS_LIST:
        return "COMPANY_PRODUCTS_LIST";
      case APP_PAGE.CATEGORY_PRODUCTS_LIST:
        return "CATEGORY_PRODUCTS_LIST";

      //AUTH
      case APP_PAGE.SIGN_IN:
        return "SIGN_IN";
      case APP_PAGE.SIGN_UP:
        return "SIGN_UP";
      case APP_PAGE.SIGN_MAIN:
        return "SIGN_MAIN";
      case APP_PAGE.OTP:
        return "OTP";

      case APP_PAGE.CATALOG_SINGLE:
        return "CATALOG_SINGLE";
      case APP_PAGE.CATALOG_COMPANY_LIST:
        return "CATALOG_COMPANY_LIST";
      case APP_PAGE.CATALOG:
        return "CATALOG";

      case APP_PAGE.BONUS_CARD_ADD:
        return "BONUS_CARD_ADD";
      case APP_PAGE.BONUS_CARD_DETAIL:
        return "BONUS_CARD_DETAIL";
      case APP_PAGE.BONUS_CARD_CAMERA:
        return "BONUS_CARD_CAMERA";
      case APP_PAGE.BONUS_CARD:
        return "BONUS_CARD";

      case APP_PAGE.ABOUT:
        return "ABOUT";
      case APP_PAGE.ONBOARD:
        return "ONBOARD";
      default:
        return "";
    }
  }
}
