import '/Screen/Authentication/sign_up.dart';
import '/Screen/Widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Controllers/auth-controller.dart';
import '../../utils/size_config.dart';
import '../Widgets/button_global.dart';
import 'package:get/get.dart';
import '../Widgets/loader.dart';


class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isChecked = true;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  AuthController authController = AuthController();

  @override
  Widget build(BuildContext context) {
    SizeConfigCustom sizeConfig = SizeConfigCustom();
    sizeConfig.init(context);
    return GetBuilder<AuthController>(
      init: AuthController(),
      builder: (auth) => SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              // Orange gradient colored box
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(150),
                    ),
                  ),
                ),
              ),
              // Orange gradient colored box
              Positioned(
                top: 120,
                left: 100,
                child: Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(55),
                  ),
                ),
              ),
              // Blue gradient colored box
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),

              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      // Reduced padding here
                      child: const SizedBox(
                          height: 200), // Adjusted the height here
                    ),
                    Image.asset(
                      'assets/images/logo.png',
                      width: 400,
                      height: 110,
                    ),

                    const SizedBox(height: 40,),


                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 0, bottom: 0),
                      // Adjusted padding here
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            AppTextField(
                              showCursor: true,
                              controller: _emailController,
                              validator: (value) {
                                if (_emailController.text.isEmpty) {
                                  return "this_field_can_t_be_empty".tr;
                                }
                                return null;
                              },
                              cursorColor: kTitleColor,
                              textFieldType: TextFieldType.PHONE,
                              maxLength: 10,
                              decoration: kInputDecoration.copyWith(
                                labelText: 'mobile'.tr,
                                labelStyle:
                                kTextStyle.copyWith(color: kTitleColor),
                                hintText: '1234567890',
                                hintStyle:
                                kTextStyle.copyWith(color: kGreyTextColor),
                                suffixIcon: const Icon(
                                  Icons.phone_android, /*color: kGreyTextColor*/
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),

                            ButtonGlobal(
                              buttontext: 'sign_in'.tr,
                              buttonDecoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  auth.LoginWithOtp(email: _emailController.text.toString().trim(),);
                                  /*auth.loginOnTap(
                                    email: _emailController.text.toString().trim(),
                                    pass: _passwordController.text.toString().trim(),
                                  );*/
                                }
                              },
                            ),

                            /* AppTextField(
                              showCursor: true,
                              cursorColor: kTitleColor,
                              controller: _passwordController,
                              validator: (value) {
                                if (_passwordController.text.isEmpty) {
                                  return "this_field_can_t_be_empty".tr;
                                }
                                return null;
                              },
                              textFieldType: TextFieldType.PASSWORD,
                              decoration: kInputDecoration.copyWith(
                                labelText: 'password'.tr,
                                labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                hintText: '********',
                                hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  activeColor: kMainColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                  ),
                                  value: isChecked,
                                  onChanged: (val) {
                                    setState(
                                          () {
                                        isChecked = val!;
                                      },
                                    );
                                  },
                                ),
                                Text(
                                  'remember_me'.tr,
                                  style: kTextStyle.copyWith(
                                      color: kTitleColor,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                            const SizedBox(height: 30.0),
                            // Using ButtonGlobal widget for the sign-in button
                            const SizedBox(height: 10.0),
                            RichText(
                              text: TextSpan(
                                text: 'dont_have_an_account'.tr,
                                style: kTextStyle.copyWith(color: kTitleColor),
                                children: [
                                  TextSpan(
                                    text: 'sign_up_here'.tr,
                                    style: kTextStyle.copyWith(color: kMainColor),
                                  )
                                ],
                              ),
                            ).onTap(() => Get.off(SignUp())),*/
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              auth.loader
                  ? Positioned(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white60,
                  child: const Center(child: LoaderCircle()),
                ),
              )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
