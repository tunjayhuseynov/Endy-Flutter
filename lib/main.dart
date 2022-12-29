import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/pages/main/Home/CategoryGrid/Category_Grid_Bloc.dart';
import 'package:endy/pages/main/Home/CategorySelectionList/Category_List_Bloc.dart';
import 'package:endy/pages/main/Home/CategorySelectionList/Category_Selection_List_Bloc.dart';
import 'package:endy/pages/main/Home/FilterPage/Filter_Page_Bloc.dart';
import 'package:endy/pages/main/Home/HomePage/Home_Page_Bloc.dart';
import 'package:endy/firebase_options.dart';
import 'package:endy/pages/main/list/List_Bloc.dart';
import 'package:endy/providers/FilterChange.dart';
import 'package:endy/providers/ListChange.dart';
import 'package:endy/providers/PanelChange.dart';
import 'package:endy/providers/UserChange.dart';
import 'package:endy/utils/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await setupFlutterNotifications();
  showFlutterNotification(message);
}

late AndroidNotificationChannel channel;
bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: 'launch_background',
          ),
        ),
        payload: message.data["onClick"]);
  }
}

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    await setupFlutterNotifications();
  }

  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
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
    super.initState();

    FirebaseMessaging.instance.getInitialMessage().then((message) => {
          print(message?.data),
          if (message != null && message.data["onClick"] != null)
            {
              Navigator.of(context).pushNamed("main/home/detail",
                  arguments: message.data["onClick"])
            }
        });

    FirebaseMessaging.onMessage.listen(showFlutterNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Daxil oldu");
      print(message.data["onClick"]);
      if (message.data["onClick"] != null) {
        Navigator.of(context)
            .pushNamed("main/home/detail", arguments: message.data["onClick"]);
      }
    });

    FirebaseMessaging.instance.subscribeToTopic('all');
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<FilterChange>(create: (_) => FilterChange()),
          ChangeNotifierProvider<ListChange>(create: (_) => ListChange()),
          ChangeNotifierProvider<UserChange>(create: (_) => UserChange()),
          ChangeNotifierProvider<PanelChange>(create: (_) => PanelChange()),
          // ChangeNotifierProvider<CacheChange>(create: (_) => CacheChange()),
          // ChangeNotifierProvider<NavbarPageChange>(
          //     create: (_) => NavbarPageChange()),
          // ChangeNotifierProvider<CategoryChange>(
          //     create: (_) => CategoryChange()),
          // ChangeNotifierProvider<CompanyChange>(create: (_) => CompanyChange()),
        ],
        child: MultiBlocProvider(
            providers: [
              BlocProvider<GlobalBloc>(
                  lazy: false, create: (context) => GlobalBloc()),
              BlocProvider<HomePageNavBloc>(
                  create: (context) => HomePageNavBloc()),
              BlocProvider<CategoryGridBloc>(
                  create: (context) => CategoryGridBloc()),
              BlocProvider<FilterPageBloc>(
                  create: (context) => FilterPageBloc()),
              BlocProvider<HomePageCacheBloc>(
                  create: (context) => HomePageCacheBloc()),
              BlocProvider<CategorySelectionListBloc>(
                  create: (context) => CategorySelectionListBloc()),
              BlocProvider<CategoryListBloc>(
                  create: (context) => CategoryListBloc()),
              BlocProvider<ListBloc>(create: (context) => ListBloc()),
            ],
            child: MaterialApp(
                title: 'Endy',
                theme: ThemeData(
                    primarySwatch: Colors.red,
                    useMaterial3: true,
                    textTheme: GoogleFonts.robotoTextTheme(Theme.of(context)
                        .textTheme
                        .copyWith(bodyText1: const TextStyle())
                        .apply(
                          bodyColor: const Color.fromARGB(255, 48, 46, 46),
                        ))),
                initialRoute: '/home',
                onGenerateRoute: (RouteSettings setting) {
                  return MaterialPageRoute(
                      builder: routerSwitch(setting), settings: setting);
                })));
  }
}
