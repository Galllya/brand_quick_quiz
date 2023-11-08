// import 'package:admob_flutter/admob_flutter.dart';
import 'package:brand_quick_quiz/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:brand_quick_quiz/presentation/home/home_page.dart';
import 'package:brand_quick_quiz/style/theme.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  // RequestConfiguration configuration = RequestConfiguration(
  //   testDeviceIds: [
  //     "1410495DA2D87354F076A2C20FEFD573",
  //   ],
  // );
  // MobileAds.instance.updateRequestConfiguration(configuration);

  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<SharedPreferences>(
          create: ((context) => sharedPreferences),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: appTheme,
      home: const HomePage(),
    );
  }
}
