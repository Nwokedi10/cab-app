import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pusher_beams/pusher_beams.dart';
import 'package:udrive/src/app/theme/colors.dart';
import 'package:udrive/src/features/splashscreen/loading_splash_screen.dart';
import 'package:udrive/src/utils/constants/constant_barrel.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'src/global/controller/location_controller.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  if (kDebugMode) {
    print("ensured");
  }
  await GetStorage.init();
  await PusherBeams.instance.start("78a4bcf1-1756-4c58-b7d0-472a2fde0189");
  // Freshchat.init(
  //   "d2d760d4-90cb-486f-a5bf-d3a048fa58c1",
  //   "67d39752-f594-4af1-ac45-298aee27022a",
  //   "msdk.freshchat.com",
  //   fileSelectionEnabled: false,
  //   cameraCaptureEnabled: false,
  //   gallerySelectionEnabled: false,
  // );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black.withOpacity(0.002)));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // injectDependencies();
    Get.put(LocationController(), permanent: true);
    FlutterNativeSplash.remove();
    return GetMaterialApp(
        title: 'Udrive',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'GB'), // English
        ],
        theme: ThemeData(
          fontFamily: Assets.appFontFamily,
          primarySwatch: AppColors.primaryColor,
          textSelectionTheme: TextSelectionThemeData(
              cursorColor: AppColors.white,
              selectionColor: AppColors.black.withOpacity(0.3),
              selectionHandleColor: AppColors.white),
          scaffoldBackgroundColor: AppColors.primaryColor,
          navigationBarTheme:
              const NavigationBarThemeData(backgroundColor: AppColors.transparent),
        ),
        home: const LoadingSplashScreen());
  }
}
