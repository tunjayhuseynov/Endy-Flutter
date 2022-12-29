import 'package:flutter/foundation.dart';

enum Mode { none, lastDay, more20, lastAdded, nearby }

class FilterChange extends ChangeNotifier {
  List<Mode> mode = [Mode.none];
  Map<String, dynamic>? subAndCategory;

  void setSubAndCategory(Map<String, dynamic>? subAndCategory) {
    this.subAndCategory = subAndCategory;
    notifyListeners();
  }

  void setSubAndCategoryWhNotify(Map<String, dynamic>? subAndCategory) {
    this.subAndCategory = subAndCategory;
  }

  void removeSubAndCategory() {
    subAndCategory = null;
    notifyListeners();
  }

  void removeSubcategory() {
    subAndCategory = {
      "subcategory": null,
      "category": subAndCategory?["category"],
      "company": subAndCategory?["company"]
    };
    notifyListeners();
  }

  void removeSubAndCategoryWoNotify() {
    subAndCategory = null;
  }

  void clearMode() {
    mode = [Mode.none];
    notifyListeners();
  }

  void addNewMode(Mode mode) {
    this.mode.clear();
    this.mode.add(mode);
    notifyListeners();
  }

  void addNewModeWhNotify(Mode mode) {
    this.mode.clear();
    this.mode.add(mode);
  }

  void removeMode(Mode mode) {
    this.mode.remove(mode);
    notifyListeners();
  }

  void removeModeWhNotify(Mode mode) {
    this.mode.remove(mode);
  }
}
