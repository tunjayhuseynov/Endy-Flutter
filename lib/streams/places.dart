import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endy/types/place.dart';

class PlaceCrud {
  static Future<Place?> getPlace(String id) async {
    final placesData =
        await FirebaseFirestore.instance.collection('places').doc(id).get();

    final data = placesData.data();
    if (data == null) return null;

    Place place = Place.fromJson(data);
    return place;
  }

  static Future<List<Place>> getPlaces() async {
    final places = await FirebaseFirestore.instance
        .collection('places')
        .orderBy('name')
        .get();
    return places.docs.map((doc) {
      final place = Place.fromJson(doc.data());
      return place;
    }).toList();
  }
}
