import 'dart:async';

import 'package:flutter/material.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  late final List<StreamSubscription<dynamic>> _subscription;

  GoRouterRefreshStream(List<Stream<dynamic>> streams) {
    notifyListeners();
    _subscription = streams
        .map((e) => e.asBroadcastStream().listen((_) => notifyListeners()))
        .toList();
  }

  @override
  void dispose() {
    for (var element in _subscription) {
      element.cancel();
    }
    super.dispose();
  }
}