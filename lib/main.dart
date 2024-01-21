import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'Controllers/global-controller.dart';
import 'Locale/language.dart';
import 'Screen/SplashScreen/splash_screen.dart';
import 'Screen/Widgets/constant.dart';

Future<void> main() async {
  final box = GetStorage();
  WidgetsFlutterBinding.ensureInitialized();
  const firebaseOptions = FirebaseOptions(
    appId: '1:696555057769:android:13fa3d05f669fc7602a8f8',
    apiKey: 'AIzaSyA2lXnXLx2IFT5LoGQATs8VefD-LhYyobE',
    projectId: 'courier-8637f',
    messagingSenderId: '696555057769',
    authDomain: 'we-courier-81101.firebaseapp.com',

    /*appId: '1:151878495365:android:2510842ed9330bba260dec',
    apiKey: 'AIzaSyDCthiio0WgX1F2CiVlw1Z-kWOKYYi6vQI',
    projectId: 'we-courier-81101',
    messagingSenderId: '151878495365',
    authDomain: 'we-courier-81101.firebaseapp.com',*/
  );
  await Firebase.initializeApp(name: 'Customer App (Clone from Merchant App)'/*'courier'*/, options: firebaseOptions);
  await GetStorage.init();
  dynamic langValue = const Locale('en', 'US');
  if (box.read('lang') != null) {
    langValue = Locale(box.read('lang'), box.read('langKey'));
  } else {
    langValue = const Locale('en', 'US');
  }

  runApp( MyApp(lang: langValue,));
}

class MyApp extends StatelessWidget {
  final Locale lang;
  MyApp({Key? key, required this.lang}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: kMainColor
    ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Get.put(GlobalController()).onInit();

    return  ScreenUtilInit(
        designSize: Size(360, 800),
        builder: ((context, child) =>
            GetMaterialApp(
              debugShowCheckedModeBanner: false,
              translations: Languages(),
              locale: lang,
              title: 'Arha Merchant',
              theme: ThemeData(fontFamily: 'Display'),
              home: const SplashScreen(),
            )));
  }
}

