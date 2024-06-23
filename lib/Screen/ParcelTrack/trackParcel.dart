import 'package:timeline_tile/timeline_tile.dart';

import '../../Controllers/parcel_controller.dart';
import '../../utils/image.dart';
import '../Home/home.dart';
import '../Widgets/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class TrackParcel extends StatefulWidget {
  @override
  _TrackParcelPageState createState() => _TrackParcelPageState();
}
class _TrackParcelPageState extends State<TrackParcel> {
  final TextEditingController _trackingIDController = TextEditingController();
  final ParcelController parcelController = Get.put(ParcelController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(titleSpacing: 0,
        title:Container(padding: EdgeInsets.only(bottom: 10,),
          height: 70,width: 300,
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
              },
            icon: Icon(Icons.arrow_back, color: Colors.black,)),
        backgroundColor: kBgColor,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 55,
                        child: TextField(
                          showCursor: true,
                          controller: _trackingIDController,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Search with tracking id',
                            labelStyle: kTextStyle.copyWith(color: kTitleColor),
                            hintText: 'AR4363C2',
                            hintStyle: kTextStyle.copyWith(
                                color: kGreyTextColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10.0)),
                            ),
                          ),
                          onChanged: (value) {},
                        ),
                      ),
                    ),

                    SizedBox(width: 12,),

                    FloatingActionButton(backgroundColor: Colors.white,
                      child: Icon(Icons.search, color: Colors.orange,),
                      onPressed: () {
                        parcelController.CallParcelTrackingIDApi(_trackingIDController.text.toString());
                      },
                    )
                  ],
                ),

                SizedBox(height: 10,),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                      color: Colors.white,
                    ),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.844,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(padding: const EdgeInsets.all(0),
                                child: ListView.builder(
                                  itemCount: parcelController.parcelLogsList
                                      .length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (_, i) {
                                    return TimelineTile(
                                      alignment: TimelineAlign.manual,
                                      lineXY: 0.35,
                                      indicatorStyle: IndicatorStyle(
                                          indicator: Icon(
                                            Icons.check_circle,
                                            color: kMainColor,
                                          ),
                                          color: kMainColor,
                                          padding: const EdgeInsets.only(
                                              bottom: 4.0)),
                                      startChild: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20.0, left: 10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${parcelController
                                                  .parcelcreatedDate} ',
                                              style: kTextStyle.copyWith(
                                                  color: kTitleColor),
                                            ),
                                            Text(
                                              '${parcelController
                                                  .parcelLogsList[i]
                                                  .timeDate} ',
                                              style: kTextStyle.copyWith(
                                                  color: kGreyTextColor,
                                                  fontSize: 14.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                      endChild: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20.0, left: 10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${parcelController
                                                  .parcelstausname}',
                                              style: kTextStyle.copyWith(
                                                  color: Colors.green),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            parcelController.parcelLogsList[i]
                                                .hubName ==
                                                ''
                                                ? SizedBox()
                                                : Text(
                                              'hub_name'.tr +
                                                  ': ${parcelController
                                                      .parcelLogsList[i]
                                                      .hubName} ',
                                              style: kTextStyle.copyWith(
                                                  color: kGreyTextColor),
                                            ),
                                            parcelController.parcelLogsList[i]
                                                .hubPhone ==
                                                ''
                                                ? SizedBox()
                                                : Text(
                                              'hub_phone'.tr +
                                                  ': ${parcelController
                                                      .parcelLogsList[i]
                                                      .hubPhone} ',
                                              style: kTextStyle.copyWith(
                                                  color: kGreyTextColor),
                                            ),
                                            parcelController.parcelLogsList[i]
                                                .deliveryMan ==
                                                ''
                                                ? SizedBox()
                                                : Text(
                                              'delivery_man'.tr +
                                                  ': ${parcelController
                                                      .parcelLogsList[i]
                                                      .deliveryMan} ',
                                              style: kTextStyle.copyWith(
                                                  color: kGreyTextColor),
                                            ),
                                            parcelController.parcelLogsList[i]
                                                .deliveryPhone ==
                                                ''
                                                ? SizedBox()
                                                : Text(
                                              'delivery_phone'.tr +
                                                  ': ${parcelController
                                                      .parcelLogsList[i]
                                                      .deliveryPhone} ',
                                              style: kTextStyle.copyWith(
                                                  color: kGreyTextColor),
                                            ),
                                            parcelController.parcelLogsList[i]
                                                .transferDeliveryMan ==
                                                ''
                                                ? SizedBox()
                                                : Text(
                                              'delivery_man'.tr +
                                                  ': ${parcelController
                                                      .parcelLogsList[i]
                                                      .transferDeliveryMan} ',
                                              style: kTextStyle.copyWith(
                                                  color: kGreyTextColor),
                                            ),
                                            parcelController.parcelLogsList[i]
                                                .transferDeliveryPhone ==
                                                ''
                                                ? SizedBox()
                                                : Text(
                                              'delivery_phone'.tr +
                                                  ': ${parcelController
                                                      .parcelLogsList[i]
                                                      .transferDeliveryPhone} ',
                                              style: kTextStyle.copyWith(
                                                  color: kGreyTextColor),
                                            ),
                                            parcelController.parcelLogsList[i]
                                                .pickupMan ==
                                                ''
                                                ? SizedBox()
                                                : Text(
                                              'pickup_man'.tr +
                                                  ': ${parcelController
                                                      .parcelLogsList[i]
                                                      .pickupMan} ',
                                              style: kTextStyle.copyWith(
                                                  color: kGreyTextColor),
                                            ),
                                            parcelController.parcelLogsList[i]
                                                .pickupPhone ==
                                                ''
                                                ? SizedBox()
                                                : Text(
                                              'pickup_phone'.tr +
                                                  ': ${parcelController
                                                      .parcelLogsList[i]
                                                      .pickupPhone} ',
                                              style: kTextStyle.copyWith(
                                                  color: kGreyTextColor),
                                            ),
                                            parcelController.parcelLogsList[i]
                                                .description ==
                                                ''
                                                ? SizedBox()
                                                : Text(
                                              'note'.tr +
                                                  ': ${parcelController
                                                      .parcelLogsList[i]
                                                      .description} ',
                                              style: kTextStyle.copyWith(
                                                  color: kGreyTextColor),
                                            ),
                                            const SizedBox(
                                              height: 40.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                      beforeLineStyle: const LineStyle(
                                        color: kMainColor,
                                      ),
                                    );

                                    // TimelineTile(
                                    //   alignment: TimelineAlign.manual,
                                    //   lineXY: 0.35,
                                    //   isFirst: true,
                                    //   indicatorStyle: const IndicatorStyle(
                                    //       indicator: Icon(
                                    //         Icons.check_circle,
                                    //         color: kMainColor,
                                    //       ),
                                    //       color: kMainColor,
                                    //       padding: EdgeInsets.only(bottom: 4.0)),
                                    //   startChild: Padding(
                                    //     padding: const EdgeInsets.only(
                                    //         top: 20.0, left: 10.0),
                                    //     child: Column(
                                    //       crossAxisAlignment: CrossAxisAlignment.end,
                                    //       children: [
                                    //         Text(
                                    //           '21 July, 2022',
                                    //           style: kTextStyle.copyWith(color: kTitleColor),
                                    //         ),
                                    //         Text(
                                    //           '10:21 am',
                                    //           style: kTextStyle.copyWith(
                                    //               color: kGreyTextColor,
                                    //               fontSize: 14.0),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    //   endChild: Padding(
                                    //     padding: const EdgeInsets.only(
                                    //         top: 20.0, left: 10.0),
                                    //     child: Column(
                                    //       crossAxisAlignment: CrossAxisAlignment.start,
                                    //       children: [
                                    //         Text(
                                    //           'confirmed'.tr,
                                    //           style: kTextStyle.copyWith(
                                    //               color: kTitleColor),
                                    //         ),
                                    //         Text(
                                    //           'we_got_your_parcel_here'.tr,
                                    //           style: kTextStyle.copyWith(
                                    //               color: kGreyTextColor),
                                    //         ),
                                    //         const SizedBox(
                                    //           height: 20.0,
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    //   beforeLineStyle: const LineStyle(
                                    //     color: kMainColor,
                                    //   ),
                                    // );
                                  },
                                )),
                            TimelineTile(
                              alignment: TimelineAlign.manual,
                              lineXY: 0.35,
                              indicatorStyle: IndicatorStyle(
                                  indicator: Icon(
                                    Icons.check_circle,
                                    color: kMainColor,
                                  ),
                                  color: kMainColor,
                                  padding: const EdgeInsets.only(bottom: 4.0)),
                              startChild: Padding(
                                padding: const EdgeInsets.only(
                                    top: 20.0, left: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${parcelController.parcelcreatedDate} ',
                                      style: kTextStyle.copyWith(
                                          color: kTitleColor),
                                    ),
                                  ],
                                ),
                              ),
                              endChild: Padding(
                                padding: const EdgeInsets.only(
                                    top: 20.0, left: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'parcel_create'.tr,
                                      style: kTextStyle.copyWith(
                                          color: Colors.green),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'name'.tr +
                                          ': ${parcelController
                                              .parcelmerchantName} ',
                                      style: kTextStyle.copyWith(
                                          color: kGreyTextColor),
                                    ),
                                    Text(
                                      'email'.tr +
                                          ': ${parcelController
                                              .parcelcustomerName} ',
                                      style: kTextStyle.copyWith(
                                          color: kGreyTextColor),
                                    ),
                                    Text(
                                      'mobile'.tr +
                                          ': ${parcelController
                                              .parcelmerchantMobile} ',
                                      style: kTextStyle.copyWith(
                                          color: kGreyTextColor),
                                    ),
                                    const SizedBox(
                                      height: 40.0,
                                    ),
                                  ],
                                ),
                              ),
                              beforeLineStyle: const LineStyle(
                                color: kMainColor,
                              ),
                            ),

                           /* SizedBox(height: 15,),


                            ElevatedButton(
                                onPressed: () {
                                  Razorpay razorpay = Razorpay();
                                  var options = {
                                    'key': 'rzp_test_1DP5mmOlF5G5ag',
                                    'amount': 100,
                                    'name': 'Arha Courier service',
                                    'description': 'Parcel',
                                    'retry': {'enabled': true, 'max_count': 1},
                                    'send_sms_hash': true,
                                    'prefill': {
                                      'contact': '8247361446',
                                      'email': 'courierpro23@gmail.com'
                                    },
                                    'external': {
                                      'wallets': ['paytm']
                                    }
                                  };
                                  razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
                                  razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
                                  razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
                                  razorpay.open(options);
                                },
                                child: const Text("Pay with Razorpay")),*/


                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
    );
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    showAlertDialog(context, "Payment Failed", "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    print(response.data.toString());
    showAlertDialog(context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    // show the dialog
    showDialog(context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}
