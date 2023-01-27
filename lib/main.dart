import 'package:endy/FirebaseMessaging.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/Category_Grid_Bloc.dart';
import 'package:endy/Pages/main/Home/CategorySelectionList/Category_List_Bloc.dart';
import 'package:endy/Pages/main/Home/CategorySelectionList/Category_Selection_List_Bloc.dart';
import 'package:endy/Pages/main/Home/FilterPage/Filter_Page_Bloc.dart';
import 'package:endy/Pages/main/Home/HomePage/Home_Page_Bloc.dart';
import 'package:endy/env.dart';
import 'package:endy/firebase_options.dart';
import 'package:endy/Pages/main/list/List_Bloc.dart';
import 'package:endy/Pages/Sign/OTP/OTP_Bloc.dart';
import 'package:endy/mainMaterial.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:typesense/typesense.dart';

final typesenseConfig = Configuration(
  // Replace with your configuration
  TYPESENSE_API,
  nodes: {
    Node(
      Protocol.https,
      "9ia1pbszodc3l2xwp-1.a1.typesense.net",
      port: 443,
    ),
  },
  numRetries: 3, // A total of 4 tries (1 original try + 3 retries)
  connectionTimeout: const Duration(seconds: 10),
);

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );
  FirebaseMessaging.instance.requestPermission(
      alert: true,
      sound: true,
      badge: true,
      announcement: true,
      criticalAlert: true);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // FirebaseAuth.instance.signOut();
  if (!kIsWeb) {
    await setupFlutterNotifications();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  void initState() {
    if (!kIsWeb) {
      FirebaseMessaging.instance.getInitialMessage();

      FirebaseMessaging.onMessage.listen((message) async {
        // await setupFlutterNotifications();
        showFlutterNotification(message);
      });
      FirebaseMessaging.instance.subscribeToTopic('all');
    }
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<GlobalBloc>(
          lazy: false, create: (context) => GlobalBloc()..loadUtils()),
      BlocProvider<HomePageNavBloc>(create: (context) => HomePageNavBloc()),
      BlocProvider<OTPBloc>(create: (context) => OTPBloc()),
      BlocProvider<CategoryGridBloc>(create: (context) => CategoryGridBloc()),
      BlocProvider<FilterPageBloc>(create: (context) => FilterPageBloc()),
      BlocProvider<HomePageCacheBloc>(create: (context) => HomePageCacheBloc()),
      BlocProvider<CategorySelectionListBloc>(
          create: (context) => CategorySelectionListBloc()),
      BlocProvider<CategoryListBloc>(create: (context) => CategoryListBloc()),
      BlocProvider<ListBloc>(create: (context) => ListBloc()),
    ], child: AppMaterial());
  }
}
