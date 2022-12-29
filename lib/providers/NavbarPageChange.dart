import 'package:flutter/foundation.dart';

class NavbarPageChange extends ChangeNotifier {
  int index = 0;

  void setIndex(int i) {
    index = i;
    notifyListeners();
  }
}
