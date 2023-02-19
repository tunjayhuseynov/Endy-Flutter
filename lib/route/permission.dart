import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PermissionGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (FirebaseAuth.instance.currentUser?.isAnonymous == true) {
      router.pushNamed("/needRegister");
    } else {
      resolver.next(true);
    }
  }
}
