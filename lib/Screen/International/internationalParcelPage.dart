import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:we_courier_merchant_app/Screen/Widgets/button_global.dart';

import '../../utils/image.dart';
import '../Home/home.dart';
import '../Widgets/constant.dart';

class InternationalParcelPage extends StatefulWidget {
  @override
  _InternationalParcelPageState createState() => _InternationalParcelPageState();
}

class _InternationalParcelPageState extends State<InternationalParcelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title:Container(
          padding: EdgeInsets.only(bottom: 10,),
          height: 100,width: 275,
          child: Row(  mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(Images.appLogo, fit: BoxFit.cover),
            ],
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));

              // Get.find<ParcelController>().clearAll();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),

        backgroundColor: kBgColor,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),

      ),

      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          elevation: 20,

          child: Center(
            child: Text(
              "Comming Soon",
              textAlign: TextAlign.center,
            ),
          ),

          /*child: Padding(
            padding: EdgeInsets.all(16.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                AppTextField(  showCursor: true,
                  cursorColor: kTitleColor,
                  textFieldType: TextFieldType.EMAIL,
                  decoration: kInputDecoration.copyWith(
                    labelText: 'Full Name'.tr,
                    labelStyle:
                    kTextStyle.copyWith(color: kTitleColor),
                    hintText: 'test',
                    hintStyle:
                    kTextStyle.copyWith(color: kGreyTextColor),
                    *//*suffixIcon: const Icon(
                      Icons.padding_sharp, *//**//*color: kGreyTextColor*//**//*
                    ),*//*
                  ),
                ),
                SizedBox(height: 10),
            AppTextField(  showCursor: true,
              cursorColor: kTitleColor,
              textFieldType: TextFieldType.PHONE,
              decoration: kInputDecoration.copyWith(
                labelText: 'Mobile Number'.tr,
                labelStyle:
                kTextStyle.copyWith(color: kTitleColor),
                hintText: '1234567890',
                hintStyle:
                kTextStyle.copyWith(color: kGreyTextColor),
                ),
            ),
                SizedBox(height: 10),
                AppTextField(
                  showCursor: true,
                  cursorColor: kTitleColor,
                  textFieldType: TextFieldType.NAME,
                  decoration: kInputDecoration.copyWith(
                    labelText: 'Weight of the package'.tr,
                    labelStyle:
                    kTextStyle.copyWith(color: kTitleColor),
                    hintText: '1 kg',
                    hintStyle:
                    kTextStyle.copyWith(color: kGreyTextColor),
                  ),
                ),
                SizedBox(height: 10),
                AppTextField(
              showCursor: true,
              cursorColor: kTitleColor,
              textFieldType: TextFieldType.NAME,
              decoration: kInputDecoration.copyWith(
                labelText: 'From'.tr,
                labelStyle:
                kTextStyle.copyWith(color: kTitleColor),
                hintText: 'Delhi',
                hintStyle:
                kTextStyle.copyWith(color: kGreyTextColor),
                ),
            ),

                SizedBox(height: 10),
                AppTextField(
                  showCursor: true,
                  cursorColor: kTitleColor,
                  textFieldType: TextFieldType.NAME,
                  decoration: kInputDecoration.copyWith(
                    labelText: 'To'.tr,
                    labelStyle:
                    kTextStyle.copyWith(color: kTitleColor),
                    hintText: 'Delhi',
                    hintStyle:
                    kTextStyle.copyWith(color: kGreyTextColor),
                  ),
                ),
                SizedBox(height: 20),
                ButtonGlobal(
                  onPressed: () {
                    // Navigate to Popup
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Success"),
                          content: Text("Your request successfully submitted. Our pickup agent will reach you shortly."),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  buttontext: 'Request for Pick Up'.tr,
                  buttonDecoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ],
            ),
          ),*/
        ),
      ),
    );
  }
}