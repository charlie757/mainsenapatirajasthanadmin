import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:mainsenapatirajasthanadmin/admin/admindashboard.dart';
import 'package:mainsenapatirajasthanadmin/admin/adminlogin.dart';
import 'package:mainsenapatirajasthanadmin/admin/alldistrict.dart';
import 'package:mainsenapatirajasthanadmin/admin/allvidhansabha.dart';
import 'package:mainsenapatirajasthanadmin/admin/showchartdata.dart';
import 'package:mainsenapatirajasthanadmin/admin/userdetails.dart';
import 'package:mainsenapatirajasthanadmin/admin/viewdata.dart';
import 'package:mainsenapatirajasthanadmin/utils/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase.initializeApp();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyD5Nk_h8zcURXw_J62niBdh7weiNx1CdFE",
      projectId: "mainsenapatirajasthan",
      messagingSenderId: "652413472184",
      appId: "1:652413472184:web:7aa24e3c8c271b9f4a534d",
    ));
  } else {
    Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    checkUserLogin();
    super.initState();
  }

  bool isLogin = false;

  checkUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLogin') != null) {
      isLogin = prefs.getBool('isLogin')!;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        if (settings.name == '/adminLogin') {
          return MaterialPageRoute(builder: (_) => AdminLogin());
        }
        if (settings.name == '/adminDashboard') {
          return MaterialPageRoute(builder: (_) => AdminDashboard());
        }
        if (settings.name == '/ViewData') {
          return MaterialPageRoute(builder: (_) => ViewData());
        }
      },
      getPages: [
        GetPage(
            name: Routes.userDetails,
            page: () => const UserDetails(),
            transition: Transition.fade,
            transitionDuration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut),
        GetPage(
            name: Routes.chart,
            page: () => const ShowChartData(),
            transition: Transition.fade,
            transitionDuration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut),
        GetPage(
            name: Routes.allDistrict,
            page: () => const AllDistrict(),
            transition: Transition.fade,
            transitionDuration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut),
        GetPage(
            name: Routes.allVidhan,
            page: () => const AllVidhan(),
            transition: Transition.fade,
            transitionDuration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut),
        GetPage(
            name: Routes.adminLogin,
            page: () => const AdminLogin(),
            transition: Transition.fade,
            transitionDuration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut),
        GetPage(
            name: Routes.adminDashboard,
            page: () => const AdminDashboard(),
            transition: Transition.fade,
            transitionDuration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut),
        GetPage(
            name: Routes.viewdata,
            page: () => const ViewData(),
            transition: Transition.fade,
            transitionDuration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut),
      ],
      title: 'MainSenapatiRajasthanAdmin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLogin ? const AdminDashboard() : const AdminLogin(),
    );
  }
}
