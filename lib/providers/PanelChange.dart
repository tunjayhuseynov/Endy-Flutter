import 'package:endy/streams/categories.dart';
import 'package:endy/streams/panel.dart';
import 'package:endy/types/panel.dart';
import 'package:flutter/foundation.dart';

class PanelChange extends ChangeNotifier {
  List<Panel> panels = [];
  String aboutUs = "";

  PanelChange() {
    PanelCrud.getPanels().then((value) => {panels = value, notifyListeners()});
    PanelCrud.getAbout().then((value) => {aboutUs = value, notifyListeners()});
  }

  void setCategories(List<Panel> panels) {
    this.panels = panels;
    notifyListeners();
  }
}
