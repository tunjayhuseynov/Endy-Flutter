import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endy/model/panel.dart';

class PanelCrud {
  static Future<Panel> getPanel(String id) async {
    final panelsData =
        await FirebaseFirestore.instance.collection('panels').doc(id).get();

    final data = panelsData.data();
    if (data == null) throw Exception('Panel not found');

    Panel panel = Panel.fromJson(data);
    return panel;
  }

  static Future<List<Panel>> getPanels() async {
    final raws = await FirebaseFirestore.instance
        .collection('panels')
        .orderBy('name')
        .get();
    var panels = raws.docs.map((doc) {
      final panel = Panel.fromJson(doc.data());
      return panel;
    }).toList();

    panels.sort((a, b) => a.order.compareTo(b.order));

    return panels;
  }

  static Future<String> getAbout() async {
    final about = await FirebaseFirestore.instance
        .collection('aboutUs')
        .doc('content')
        .get();
    return about.data()!['text'];
  }
}
