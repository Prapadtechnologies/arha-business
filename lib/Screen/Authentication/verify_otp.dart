import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:we_courier_merchant_app/Screen/Authentication/sign_in.dart';
import '../../Controllers/auth-controller.dart';
import '../../utils/image.dart';
import '../Widgets/button_global.dart';
import '../Widgets/constant.dart';
import '../Widgets/otp_form.dart';
import 'package:get/get.dart';


class OtpVerify extends StatefulWidget {
  final String mobile;
  final String OurOtp;

  const OtpVerify({Key? key, required this.mobile, required this.OurOtp}) : super(key: key);

  @override
  State<OtpVerify> createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> {
  AuthController authController = AuthController();
  bool isChecked = true;

  @override
  void initState() {
    authController = Get.put(AuthController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Mobile ==>${widget.mobile.toString()+","+widget.OurOtp.toString()}");
    return Scaffold(
      backgroundColor: kBgColor,

      appBar: AppBar(
        titleSpacing: 0,
        title:Container(
          padding: EdgeInsets.only(bottom: 10,),
          height: 80,width: 300,
          child: Row(  mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(Images.appLogo, fit: BoxFit.cover),
            ],
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignIn()));

            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),

        backgroundColor: kBgColor,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: (Column(
          children: [
            const SizedBox(height: 40,),
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: Color(0xFFf9f9fe),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange,
                    spreadRadius: 4,
                    offset: Offset(0, 0),
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  topLeft: Radius.circular(30.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Text('confirm_otp'.tr,
                      style: kTextStyle.copyWith(
                          color: kGreyTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),

                    const SizedBox(height: 30.0),
                    Text(
                      'check_your_phone_we_have_send_you_a_5_digit_otp_please_confirm_that_otp_to_verify_your_phone_number_for_registrations'.tr,
                      style: kTextStyle.copyWith(color: kTitleColor),
                      textAlign: TextAlign.center,
                    ),
                    Center(
                      child: Text(
                        '********',
                        style: kTextStyle.copyWith(
                            color: kTitleColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Center(
                      child: Text(
                        'your_otp'.tr,
                        style: kTextStyle.copyWith(
                            color: kTitleColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    const OtpForm(),
                    const SizedBox(height: 50.0),
                    ButtonGlobal(
                        buttontext: 'submit'.tr,
                        buttonDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: kMainColor),
                        onPressed: () async {
                          if(authController.otp1.text.toString() != 'null'){
                            isChecked = true;
                            await authController.otpVerification(widget.mobile.toString(),widget.OurOtp.toString());
                          }else {
                            Get.rawSnackbar(
                                message: "enter_your_otp_code".tr,
                                backgroundColor: Colors.red,
                                snackPosition: SnackPosition.TOP);
                          }
                        }),
                    const SizedBox(height: 20.0),
                    RichText(
                      text: TextSpan(
                        text: 'didn_t_get'.tr,
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                        children: [
                          TextSpan(
                              text: 'resend_code'.tr,
                              style: kTextStyle.copyWith(color: Colors.pink),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  authController.LoginWithOtp(email: widget.mobile.toString(),);
                                }

                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
