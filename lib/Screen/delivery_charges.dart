import '../utils/image.dart';
import '/Screen/Widgets/shimmer/deliveryCharge_shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/deliveryCharge_controller.dart';
import 'Home/dashboard.dart';
import 'Home/home.dart';
import 'Widgets/constant.dart';

class DeliveryChargeList extends StatefulWidget {
  const DeliveryChargeList({Key? key}) : super(key: key);

  @override
  State<DeliveryChargeList> createState() => _DeliveryChargeListState();
}

class _DeliveryChargeListState extends State<DeliveryChargeList> {

  int count = 1;
  DeliveryChargeController deliveryChargeController = DeliveryChargeController();


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child:
      Scaffold(
        backgroundColor: kBgColor,
        appBar: AppBar(
          titleSpacing: 0,
          title:Container(
            padding: EdgeInsets.only(bottom: 5,),
            height:70,width: 275,
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
        ),
        body:  GetBuilder<DeliveryChargeController>(
            init: DeliveryChargeController(),
            builder: (deliveryCharge) =>
                Container(margin: EdgeInsets.only(top: 15),
                  clipBehavior: Clip.antiAlias,
                  width: MediaQuery.of(context).size.width,
                  decoration:const BoxDecoration(
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
                      bottomLeft: Radius.circular(0.0),
                      bottomRight:  Radius.circular(0.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Container(child:
                    deliveryCharge.loader
                        ? DeliveryChargeShimmer()
                        : Column(children: [
                        const SizedBox(height: 20.0),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
                              child:
                              ListView.builder(
                                itemCount: deliveryCharge.deliveryChargesList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (_, i) {
                                  return ( Card(
                                    color: Colors.white,
                                    elevation: 1,
                                    margin: EdgeInsets.symmetric(vertical: 3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(7.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [

                                              Row(
                                                children: [
                                                  // Text(
                                                  //   'weight'.tr+':',
                                                  //   style: kTextStyle.copyWith(
                                                  //       fontSize: 16.0,
                                                  //       color: kTitleColor),
                                                  // ),
                                                  Icon(CupertinoIcons.arrow_up_bin,size: 20,),
                                                  SizedBox(width: 5,),
                                                  Text(
                                                    deliveryCharge.deliveryChargesList[i].weight.toString(),
                                                    style: kTextStyle.copyWith(
                                                        color: kTitleColor,
                                                        fontSize: 16.0,
                                                        fontWeight: FontWeight.w900
                                                    ),
                                                  ),
                                                  Text(
                                                    "(${deliveryCharge.deliveryChargesList[i].category})",
                                                    style: kTextStyle.copyWith(
                                                        color: kGreyTextColor,
                                                        fontSize: 14.0,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                              const Spacer(),
                                              Container(
                                                padding:
                                                const EdgeInsets.symmetric(vertical: 3.0,horizontal: 10.0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(7.0),
                                                  color: Colors.green,
                                                ),
                                                child: Text(
                                                  deliveryCharge.deliveryChargesList[i].statusName.toString(),
                                                  style: kTextStyle.copyWith(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 13,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5.0),
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    deliveryCharge.deliveryChargesList[i].sameDay.toString(),
                                                    style: kTextStyle.copyWith(
                                                      fontWeight: FontWeight.w700,
                                                      color: kTitleColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    'same_day'.tr,
                                                    style: kTextStyle.copyWith(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w700,
                                                      color: kGreyTextColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Spacer(),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    deliveryCharge.deliveryChargesList[i].nextDay.toString(),
                                                    style: kTextStyle.copyWith(
                                                      fontWeight: FontWeight.w700,
                                                      color: kTitleColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    'next_day'.tr,
                                                    style: kTextStyle.copyWith(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w700,
                                                      color: kGreyTextColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10,),
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    deliveryCharge.deliveryChargesList[i].subCity.toString(),
                                                    style: kTextStyle.copyWith(
                                                      fontWeight: FontWeight.w700,
                                                      color: kTitleColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    'sub_city'.tr,
                                                    style: kTextStyle.copyWith(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w700,
                                                      color: kGreyTextColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Spacer(),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    deliveryCharge.deliveryChargesList[i].outsideCity.toString(),
                                                    style: kTextStyle.copyWith(
                                                      fontWeight: FontWeight.w700,
                                                      color: kTitleColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    'outside_city'.tr,
                                                    style: kTextStyle.copyWith(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w700,
                                                      color: kGreyTextColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));
                                },
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                    ),
                  ),
                )),
      ),
    );
  }
}