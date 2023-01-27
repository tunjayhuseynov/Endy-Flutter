import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Main.dart';
import 'package:endy/utils/connection.dart';
import 'package:endy/utils/router.dart';
import 'package:endy/utils/scrollBehavior.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AppMaterial extends StatefulWidget {
  const AppMaterial({super.key});

  @override
  State<AppMaterial> createState() => AppMaterialState();
}

class AppMaterialState extends State<AppMaterial> {
  Map _source = {ConnectivityResult.none: false};
  final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;

  @override
  void initState() {
    if (!kIsWeb) {
      _networkConnectivity.initialise();
      _networkConnectivity.myStream.listen((source) {
        _source = source;

        if (_source.keys.toList()[0] == ConnectivityResult.none ||
            _source.values.toList()[0] == false) {
          context.read<GlobalBloc>().updateInternetConnectionLost(true);
        } else {
          context.read<GlobalBloc>().updateInternetConnectionLost(false);
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _networkConnectivity.disposeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        scrollBehavior: MyCustomScrollBehavior(),
        title: 'Endy',
        theme: ThemeData(
            primarySwatch: Colors.red,
            useMaterial3: true,
            textTheme: GoogleFonts.robotoTextTheme(Theme.of(context)
                .textTheme
                .copyWith(bodyLarge: const TextStyle())
                .apply(
                  bodyColor: const Color.fromARGB(255, 48, 46, 46),
                ))),
        // initialRoute: '/home',
        home: const MainProvider(),
        onGenerateRoute: (RouteSettings setting) {
          return MaterialPageRoute(
              builder: routerSwitch(setting), settings: setting);
        });
  }
}
