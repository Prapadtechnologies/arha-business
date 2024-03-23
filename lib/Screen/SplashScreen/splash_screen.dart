import 'dart:async';
import '/utils/image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Controllers/auth-controller.dart';
import '../../Controllers/global-controller.dart';
import '../Authentication/sign_in.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final AuthController _authController = AuthController();

  @override
  void initState() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {});
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {});
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
    FirebaseMessaging.instance.getToken().then((token) {
      update(token!);
    });
    Timer(
      const Duration(seconds: 2),
          () => {
        logInCheck(),
      },
    );
    super.initState();
  }

  update(String token) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString('deviceToken', token);
    print('fcm token===========>');
    print(token);
  }



  logInCheck() async {
    if (Get.find<GlobalController>().isUser) {
       _authController.refreshToken();
    } else {
      Get.off(() => const SignIn());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white/*kBgColor*/,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:  [
          Center(
            child: Image(width: 600,height: 600,
              image: AssetImage(Images.appLogo),
            ),
          ),
        ],
      ),
    );
  }
}
