import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '/Controllers/global-controller.dart';
import '/Models/hubs_model.dart';
import '/Screen/Authentication/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Controllers/auth-controller.dart';
import '../../utils/image.dart';
import '../../utils/size_config.dart';
import '../Widgets/button_global.dart';
import '../Widgets/constant.dart';
import 'package:get/get.dart';

import '../Widgets/loader.dart';


class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();

}

class _SignUpState extends State<SignUp> {
  bool isChecked = true;
  final _formKey = GlobalKey<FormState>();
  int hub = 1;
  AuthController authController = AuthController();
  GlobalController globalController = Get.put(GlobalController());
  String address ='';
   Position? currentposition = null;
  late TextEditingController _controller;

  getLocation()async{
    LocationPermission permission  = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever){
      log("Location denied");
      LocationPermission ask = await Geolocator.requestPermission();
    }else{
      currentposition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      log("Lat ==> ${currentposition!.latitude.toString()}");
      log("Long ==> ${currentposition!.longitude.toString()}");
      List<Placemark> newPlace = await placemarkFromCoordinates(currentposition!.latitude , currentposition!.longitude);
      Placemark placeMark  = newPlace[0];
      String? name = placeMark.name;
      String? subLocality = placeMark.subLocality;
      String? locality = placeMark.locality;
      String? administrativeArea = placeMark.administrativeArea;
      String? postalCode = placeMark.postalCode;
      String? country = placeMark.country;
       address = "${name}, ${subLocality}, ${locality}, ${administrativeArea} ${postalCode}, ${country}";
      print(address); // do what you want with it
      log("address ==> ${address}");
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfigCustom sizeConfig = SizeConfigCustom();
    sizeConfig.init(context);
    getLocation();

    return Scaffold(
      backgroundColor: kMainColor,
      body: GetBuilder<AuthController>(
       init: AuthController(),
       builder: (auth) =>
        Stack(children: [
        Center(
        child:
        SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
           /* Container(
              margin: EdgeInsets.only(right: 30),
              height: 120,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Images.appLogo),
                  fit: BoxFit.contain,
                ),
              ),
            ),*/
            Text(
              'registration_form'.tr,
              style: kTextStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
           /* const SizedBox(height: 5.0),
            Text(
              'please_enter_your_user_information'.tr,
              style: kTextStyle.copyWith(color: Colors.white),
            ),*/
            const SizedBox(
              height: 30,
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child:
                Form(
                  key: _formKey,
                  child:
                      Column(
                       mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/logo.png',
                                width: 350,
                                height: 150,
                              ),
                            ],
                          ),
                       /*   const SizedBox(height: 20),
                          AppTextField(
                            showCursor: true,
                            controller: auth.businessNameController,
                            validator: (value) {
                              if (auth.businessNameController.text.isEmpty) {
                                return "this_field_can_t_be_empty".tr;
                              }
                              return null;
                            },
                            cursorColor: kTitleColor,
                            textFieldType: TextFieldType.NAME,
                            decoration: kInputDecoration.copyWith(
                              labelText: 'business_name'.tr,
                              labelStyle: kTextStyle.copyWith(color: kTitleColor),
                              hintText: 'wecourier'.tr,
                              hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                            ),
                          ),*/
                          AppTextField(
                            showCursor: true,
                            controller: auth.firstNameController,
                            validator: (value) {
                              if (auth.firstNameController.text.isEmpty) {
                                return "this_field_can_t_be_empty".tr;
                              }
                              return null;
                            },
                            cursorColor: kTitleColor,
                            textFieldType: TextFieldType.NAME,
                            decoration: kInputDecoration.copyWith(
                              labelText: 'first_name'.tr,
                              labelStyle: kTextStyle.copyWith(color: kTitleColor),
                              hintText: 'enter your first name'.tr,
                              hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                            ),
                          ),
                          const SizedBox(height: 20),
                          AppTextField(
                            showCursor: true,
                            controller: auth.lastNameController,
                            validator: (value) {
                              if (auth.lastNameController.text.isEmpty) {
                                return "this_field_can_t_be_empty".tr;
                              }
                              return null;
                            },
                            cursorColor: kTitleColor,
                            textFieldType: TextFieldType.NAME,
                            decoration: kInputDecoration.copyWith(
                              labelText: 'last_name'.tr,
                              labelStyle: kTextStyle.copyWith(color: kTitleColor),
                              hintText: 'enter your last name'.tr,
                              hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                            ),
                          ),
                          const SizedBox(height: 20),

                       //   getLcation(),

                          TextFormField(
                            cursorColor: kTitleColor,
                            controller: /*auth.addressController+*/ TextEditingController()..text = address.toString(),
/*
                            TextEditingController()..text = address
*/
                            /*validator: (value) {
                              if (auth.addressController.text.isEmpty) {
                                return "this_field_can_t_be_empty".tr;
                              }
                              return null;
                            },*/

                            textAlign: TextAlign.start,
                            decoration: kInputDecoration.copyWith(
                              hintStyle: kTextStyle.copyWith(color: kTitleColor),
                              labelText: 'address ',
                              labelStyle: kTextStyle.copyWith(color: kTitleColor),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 30, horizontal: 10.0),
                            ),
                          ),
                          const SizedBox(height: 20),
                          globalController.hubList.isNotEmpty ? SizedBox(
                           height: 60.0,
                            child: FormField(
                              builder: (FormFieldState<dynamic> field) {
                                return InputDecorator(
                                  decoration: kInputDecoration.copyWith(
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelText: 'hub'.tr,
                                    hintText: 'select_hub'.tr,
                                    labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child:  DropdownButton<Hubs>(
                                    items: globalController.dropDownItems,
                                    value: globalController.hubList[globalController.hubList.indexWhere((i) => i.id == hub)],
                                    onChanged: (value) {
                                      setState(() {
                                        hub = value!.id!;
                                      });
                                    },
                                  )
                                  ),
                                );
                              },
                            ),
                          ): SizedBox(width: 0,),
                          const SizedBox(height: 20),
                          AppTextField(
                            showCursor: true,
                            cursorColor: kTitleColor,
                            controller: auth.phoneController,
                            validator: (value) {
                              if (auth.phoneController.text.isEmpty) {
                                return "this_field_can_t_be_empty".tr;
                              }
                              return null;
                            },
                            textFieldType: TextFieldType.PHONE,
                            /*inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp("[0-9].")),
                            ],*/
                            maxLength: 10,
                            decoration: kInputDecoration.copyWith(
                              labelText: 'mobile'.tr,
                              labelStyle: kTextStyle.copyWith(color: kTitleColor),
                              hintText: '1234567890',
                              hintStyle: kTextStyle.copyWith(color: kGreyTextColor),

                            ),
                          ),
                          const SizedBox(height: 20),
                          AppTextField(
                            showCursor: true,
                            cursorColor: kTitleColor,
                            controller: auth.passwordController,
                            validator: (value) {
                              if (auth.passwordController.text.isEmpty) {
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
                          const SizedBox(height: 10),
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
                              Flexible(
                                child: RichText(
                                  text: TextSpan(
                                      text: 'i_agree_to'.tr,
                                      style: kTextStyle.copyWith(color: kTitleColor),
                                      children: [
                                        TextSpan(
                                          text: ' Arha express '.tr,
                                          style: kTextStyle.copyWith(
                                              color: kGreyTextColor),
                                        ),
                                        TextSpan(
                                          text: 'privacy_Policy_&_terms'.tr,
                                          style:
                                          kTextStyle.copyWith(color: kTitleColor),
                                        )
                                      ]),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20.0),
                    SizedBox( height: 70,
                        child:
                          ButtonGlobal(
                              buttontext: 'register_my_account'.tr,
                              buttonDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: kMainColor),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                 await auth.signupOnTap(hub,address+currentposition!.latitude.toString()+currentposition!.latitude.toString());
                                }
                              })),
                    Flexible(child:
                          RichText(
                            text: TextSpan(
                              text: 'already_member'.tr,
                              style: kTextStyle.copyWith(color: kGreyTextColor),
                              children: [
                                TextSpan(
                                  text: 'login_here'.tr,
                                  style: kTextStyle.copyWith(color: kMainColor),
                                ),
                              ],
                            ),
                          ).onTap(
                                () => const SignIn().launch(context),
                          )),
                        ],
                      )),
              ),
            )
          ],
        ),
      )),
          auth.loader
              ? Positioned(
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.white60,
                child: const Center(child: LoaderCircle())),
          )
              : const SizedBox.shrink(),
        ])
      ),
    );
  }
}
