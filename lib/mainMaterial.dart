import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/utils/connection.dart';
import 'package:endy/utils/router.dart';
import 'package:endy/utils/scrollBehavior.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
    return Portal(
      child: MaterialApp(
          scrollBehavior: MyCustomScrollBehavior(),
          title: 'Endy',
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en'),
            Locale('az'),
          ],
          theme: ThemeData(
              primarySwatch: Colors.red,
              useMaterial3: true,
              textTheme: GoogleFonts.robotoTextTheme(Theme.of(context)
                  .textTheme
                  .copyWith(bodyLarge: const TextStyle())
                  .apply(
                    bodyColor: const Color.fromARGB(255, 48, 46, 46),
                  ))),
          initialRoute: FirebaseAuth.instance.currentUser == null ? "/sign/main" : '/',
          // home: GlobalWidget(child: const MainProvider(), disallowAnonym: false),
          onGenerateRoute: (RouteSettings setting) {
            return CustomPageRoute(
                builder: routerSwitch(setting), settings: setting);
          }),
    );
  }
}

class CustomPageRoute extends MaterialPageRoute {
  CustomPageRoute({builder, settings})
      : super(builder: builder, settings: settings);

  @override
  Duration get transitionDuration => Duration(milliseconds: kIsWeb ? 0 : 300);
}
