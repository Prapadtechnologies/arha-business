import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/image.dart';
import '/Models/parcels_model.dart';
import 'package:get/get.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../../Controllers/global-controller.dart';
import '../../Controllers/parcel_controller.dart';
import '../Widgets/constant.dart';
import '../Widgets/shimmer/parcel_log_shimmer.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:google_fonts/google_fonts.dart';


class ParcelDetails extends StatefulWidget {
  final Parcels parcel;
  final int? id;

  ParcelDetails({Key? key, required this.parcel, this.id}) : super(key: key);

  @override
  State<ParcelDetails> createState() => _ParcelDetailsState();
}

class _ParcelDetailsState extends State<ParcelDetails> {
  int statusActive = 1;
  ParcelController parcelController = Get.put(ParcelController());
  String? formatted_distance;

  @override
  void initState() {
    parcelController.getParcelLogs(widget.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String stringValue = parcelController.InvoiceDistance;
    double value = double.parse(stringValue);

    NumberFormat formatter = NumberFormat('#.##');
    formatted_distance = formatter.format(value);

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        titleSpacing: 0,
        title: Container(
          padding: EdgeInsets.only(
            bottom: 10,
          ),
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 60.0,
              ),
              Image.asset(Images.appLogo, fit: BoxFit.cover),
              const SizedBox(
                width: 70.0,
              ),
              FloatingActionButton(
                elevation: 0.0,
                backgroundColor: Colors.white,
                heroTag: 'uniqueTag',
                onPressed: () async {
                  // Generate and share invoice PDF
                  await generateAndShareInvoice();
                },
                child: const Icon(Icons.share),
              ),
            ],
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        backgroundColor: kBgColor,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GetBuilder<ParcelController>(
          init: ParcelController(),
          builder: (parcelLogs) => Container(
                padding: const EdgeInsets.all(10.0),
                margin: EdgeInsets.only(top: 10),
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
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  statusActive = 1;
                                });
                              },
                              child: Container(
                                height: 50,
                                width: 150,
                                decoration: statusActive == 1
                                    ? BoxDecoration(
                                        color: kMainColor,
                                        borderRadius: BorderRadius.circular(40),
                                      )
                                    : BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(40),
                                        border: Border.fromBorderSide(
                                          BorderSide(
                                            color: kMainColor,
                                          ),
                                        ),
                                      ),
                                child: Center(
                                    child: Text('details'.tr,
                                        style: TextStyle(
                                            color: statusActive == 1
                                                ? Colors.white
                                                : kMainColor))),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  statusActive = 2;
                                });
                              },
                              child: Container(
                                height: 50,
                                width: 150,
                                decoration: statusActive == 2
                                    ? BoxDecoration(
                                        color: kMainColor,
                                        borderRadius: BorderRadius.circular(40))
                                    : BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(40),
                                        border: Border.fromBorderSide(
                                          BorderSide(
                                            color: kMainColor,
                                          ),
                                        ),
                                      ),
                                child: Center(
                                  child: Text(
                                    'parcel_log'.tr,
                                    style: TextStyle(
                                      color: statusActive == 2
                                          ? Colors.white
                                          : kMainColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 7),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.76,
                        child: SingleChildScrollView(
                          child: statusActive == 1
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 7),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Card(
                                          elevation: 10,
                                          color: kSecondaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(2.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              'invoice'.tr +
                                                  ': #${widget.parcel.invoiceNO}',
                                              style: kTextStyle.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Card(
                                          elevation: 10,
                                          color: kSecondaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(2.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              widget.parcel.statusName
                                                  .toString(),
                                              style: kTextStyle.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10.0),
                                    Text(
                                      'parcel_info'.tr,
                                      style: kTextStyle.copyWith(
                                          color: kTitleColor,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Divider(
                                      thickness: 1.0,
                                      color: kGreyTextColor.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 10.0),
                                    Row(
                                      children: [
                                        Text(
                                          'tracking_id'.tr + ':',
                                          style: kTextStyle.copyWith(
                                              color: kTitleColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        Text(
                                          widget.parcel.trackingId.toString(),
                                          style: kTextStyle.copyWith(
                                              color: Colors.blue),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),
                                    Row(
                                      children: [
                                        Text(
                                          'weight'.tr + ':',
                                          style: kTextStyle.copyWith(
                                              color: kTitleColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        Text(
                                          widget.parcel.weight.toString(),
                                          style: kTextStyle.copyWith(
                                              color: kGreyTextColor),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),
                                    Row(
                                      children: [
                                        Text(
                                          'Distance'.tr + ':',
                                          style: kTextStyle.copyWith(
                                              color: kTitleColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '${formatted_distance}' + " km",
                                          style: kTextStyle.copyWith(
                                              color: kGreyTextColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),
                                    Row(
                                      children: [
                                        Text(
                                          'GST Type'.tr,
                                          style: kTextStyle.copyWith(
                                              color: kTitleColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '${widget.parcel.deliveryDate}',
                                          style: kTextStyle.copyWith(
                                              color: kGreyTextColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),
                                    Row(
                                      children: [
                                        Text(
                                          'GST Number'.tr,
                                          style: kTextStyle.copyWith(
                                              color: kTitleColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '${widget.parcel.pickupDate}',
                                          style: kTextStyle.copyWith(
                                              color: kGreyTextColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10.0),
                                    Text(
                                      'Charges Info'.tr,
                                      style: kTextStyle.copyWith(
                                          color: kTitleColor,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Divider(
                                      thickness: 1.0,
                                      color: kGreyTextColor.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 5.0),
                                    Row(
                                      children: [
                                        Text(
                                          'Delivery Charges (${widget.parcel.createdAt} x ${widget.parcel.updatedAt})',
                                          style: kTextStyle.copyWith(
                                              color: kTitleColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '${Get.find<GlobalController>().currency!}${widget.parcel.parcelTime}',
                                          style: kTextStyle.copyWith(
                                              color: kGreyTextColor),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),
                                    Row(
                                      children: [
                                        Text(
                                          'P.Charges',
                                          style: kTextStyle.copyWith(
                                              color: kTitleColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '${Get.find<GlobalController>().currency!}${widget.parcel.packagingamount}',
                                          style: kTextStyle.copyWith(
                                              color: kGreyTextColor),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),
                                    Row(
                                      children: [
                                        Text(
                                          'Vat (${widget.parcel.vat} %)',
                                          style: kTextStyle.copyWith(
                                              color: kTitleColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '${Get.find<GlobalController>().currency!}${widget.parcel.vatAmount}',
                                          style: kTextStyle.copyWith(
                                              color: kGreyTextColor),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),
                                    Row(
                                      children: [
                                        Text(
                                          'Total Charges',
                                          style: kTextStyle.copyWith(
                                              color: kTitleColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '${Get.find<GlobalController>().currency!}${widget.parcel.totalDeliveryAmount}',
                                          style: kTextStyle.copyWith(
                                              color: kGreyTextColor),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10.0),
                                    Text(
                                      'sender_info'.tr,
                                      style: kTextStyle.copyWith(
                                          color: kTitleColor,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Divider(
                                      thickness: 1.0,
                                      color: kGreyTextColor.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 10.0),
                                    Row(
                                      children: [
                                        Text(
                                          'Name'.tr + ':',
                                          style: kTextStyle.copyWith(
                                              color: kTitleColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        Text(
                                          widget.parcel.merchantUserName
                                              .toString(),
                                          style: kTextStyle.copyWith(
                                              color: kGreyTextColor),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),
                                    Row(
                                      children: [
                                        Text(
                                          'mobile'.tr + ':',
                                          style: kTextStyle.copyWith(
                                              color: kTitleColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        Text(
                                          widget.parcel.merchantMobile
                                              .toString(),
                                          style: kTextStyle.copyWith(
                                              color: kGreyTextColor),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),
                                    Row(
                                      children: [
                                        Text(
                                          'email'.tr + ':',
                                          style: kTextStyle.copyWith(
                                              color: kTitleColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        Text(
                                          widget.parcel.merchantUserEmail
                                              .toString(),
                                          style: kTextStyle.copyWith(
                                              color: kGreyTextColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 70,
                                          child: Text(
                                            'Address',
                                            style: kTextStyle.copyWith(
                                                color: kTitleColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Flexible(
                                            child: Text(
                                          widget.parcel.merchantAddress
                                              .toString(),
                                          style: kTextStyle.copyWith(
                                              color: kGreyTextColor,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ],
                                    ),
                                    const SizedBox(height: 10.0),
                                    Text(
                                      'recipient_info'.tr,
                                      style: kTextStyle.copyWith(
                                          color: kTitleColor,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Divider(
                                      thickness: 1.0,
                                      color: kGreyTextColor.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 10.0),
                                    Row(
                                      children: [
                                        Text(
                                          'name'.tr + ':',
                                          style: kTextStyle.copyWith(
                                              color: kTitleColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        Text(
                                          widget.parcel.customerName.toString(),
                                          style: kTextStyle.copyWith(
                                              color: kGreyTextColor),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),
                                    Row(
                                      children: [
                                        Text(
                                          'phone'.tr + ':',
                                          style: kTextStyle.copyWith(
                                              color: kTitleColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        Text(
                                          widget.parcel.customerPhone
                                              .toString(),
                                          style: kTextStyle.copyWith(
                                              color: kGreyTextColor),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 70,
                                          child: Text(
                                            'Pin Code'.tr,
                                            style: kTextStyle.copyWith(
                                                color: kTitleColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          widget.parcel.pinCode.toString(),
                                          style: kTextStyle.copyWith(
                                              color: kGreyTextColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 90,
                                          child: Text(
                                            'Full Address',
                                            style: kTextStyle.copyWith(
                                                color: kTitleColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          widget.parcel.customerfulladdress
                                              .toString(),
                                          style: kTextStyle.copyWith(
                                              color: kGreyTextColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 70,
                                          child: Text(
                                            'Address',
                                            style: kTextStyle.copyWith(
                                                color: kTitleColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Flexible(
                                            child: Text(
                                          widget.parcel.customerAddress
                                              .toString(),
                                          maxLines: 2,
                                          style: kTextStyle.copyWith(
                                              color: kGreyTextColor,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ],
                                    ),
                                    const SizedBox(height: 20.0),
                                  ],
                                )
                              : Column(
                                  children: [
                                    const SizedBox(height: 30.0),
                                    Container(
                                      padding: const EdgeInsets.all(10.0),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30.0),
                                          topRight: Radius.circular(30.0),
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.844,
                                            child: SingleChildScrollView(
                                                child: parcelLogs.loaderLogs
                                                    ? ParcelLogsShimmer()
                                                    : Column(
                                                        children: [
                                                          Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(0),
                                                              child:
                                                                  SingleChildScrollView(
                                                                      physics:
                                                                          NeverScrollableScrollPhysics(),
                                                                      child: ListView
                                                                          .builder(
                                                                        itemCount: parcelLogs
                                                                            .parcelLogsList
                                                                            .length,
                                                                        shrinkWrap:
                                                                            true,
                                                                        physics:
                                                                            const NeverScrollableScrollPhysics(),
                                                                        itemBuilder:
                                                                            (_, i) {
                                                                          return TimelineTile(
                                                                            alignment:
                                                                                TimelineAlign.manual,
                                                                            lineXY:
                                                                                0.35,
                                                                            indicatorStyle: IndicatorStyle(
                                                                                indicator: Icon(
                                                                                  Icons.check_circle,
                                                                                  color: kMainColor,
                                                                                ),
                                                                                color: kMainColor,
                                                                                padding: const EdgeInsets.only(bottom: 4.0)),
                                                                            startChild:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(top: 20.0, left: 10.0),
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                                children: [
                                                                                  Text(
                                                                                    '${parcelLogs.parcelLogsList[i].date} ',
                                                                                    style: kTextStyle.copyWith(color: kTitleColor),
                                                                                  ),
                                                                                  Text(
                                                                                    '${parcelLogs.parcelLogsList[i].timeDate} ',
                                                                                    style: kTextStyle.copyWith(color: kGreyTextColor, fontSize: 14.0),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            endChild:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(top: 20.0, left: 10.0),
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    '${parcelLogs.parcelLogsList[i].parcelStatusName}',
                                                                                    style: kTextStyle.copyWith(color: Colors.green),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 10,
                                                                                  ),
                                                                                  parcelLogs.parcelLogsList[i].hubName == ''
                                                                                      ? SizedBox()
                                                                                      : Text(
                                                                                          'hub_name'.tr + ': ${parcelLogs.parcelLogsList[i].hubName} ',
                                                                                          style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                                        ),
                                                                                  parcelLogs.parcelLogsList[i].hubPhone == ''
                                                                                      ? SizedBox()
                                                                                      : Text(
                                                                                          'hub_phone'.tr + ': ${parcelLogs.parcelLogsList[i].hubPhone} ',
                                                                                          style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                                        ),
                                                                                  parcelLogs.parcelLogsList[i].deliveryMan == ''
                                                                                      ? SizedBox()
                                                                                      : Text(
                                                                                          'delivery_man'.tr + ': ${parcelLogs.parcelLogsList[i].deliveryMan} ',
                                                                                          style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                                        ),
                                                                                  parcelLogs.parcelLogsList[i].deliveryPhone == ''
                                                                                      ? SizedBox()
                                                                                      : Text(
                                                                                          'delivery_phone'.tr + ': ${parcelLogs.parcelLogsList[i].deliveryPhone} ',
                                                                                          style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                                        ),
                                                                                  parcelLogs.parcelLogsList[i].transferDeliveryMan == ''
                                                                                      ? SizedBox()
                                                                                      : Text(
                                                                                          'delivery_man'.tr + ': ${parcelLogs.parcelLogsList[i].transferDeliveryMan} ',
                                                                                          style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                                        ),
                                                                                  parcelLogs.parcelLogsList[i].transferDeliveryPhone == ''
                                                                                      ? SizedBox()
                                                                                      : Text(
                                                                                          'delivery_phone'.tr + ': ${parcelLogs.parcelLogsList[i].transferDeliveryPhone} ',
                                                                                          style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                                        ),
                                                                                  parcelLogs.parcelLogsList[i].pickupMan == ''
                                                                                      ? SizedBox()
                                                                                      : Text(
                                                                                          'pickup_man'.tr + ': ${parcelLogs.parcelLogsList[i].pickupMan} ',
                                                                                          style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                                        ),
                                                                                  parcelLogs.parcelLogsList[i].pickupPhone == ''
                                                                                      ? SizedBox()
                                                                                      : Text(
                                                                                          'pickup_phone'.tr + ': ${parcelLogs.parcelLogsList[i].pickupPhone} ',
                                                                                          style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                                        ),
                                                                                  parcelLogs.parcelLogsList[i].description == ''
                                                                                      ? SizedBox()
                                                                                      : Text(
                                                                                          'note'.tr + ': ${parcelLogs.parcelLogsList[i].description} ',
                                                                                          style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                                        ),
                                                                                  Text(
                                                                                    '${parcelLogs.parcelLogsList[i].date} ',
                                                                                    style: kTextStyle.copyWith(color: kTitleColor),
                                                                                  ),
                                                                                  Text(
                                                                                    '${parcelLogs.parcelLogsList[i].timeDate} ',
                                                                                    style: kTextStyle.copyWith(color: kGreyTextColor, fontSize: 14.0),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    height: 40.0,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            beforeLineStyle:
                                                                                const LineStyle(
                                                                              color: kMainColor,
                                                                            ),
                                                                          );
                                                                        },
                                                                      ))),
                                                          TimelineTile(
                                                            alignment:
                                                                TimelineAlign
                                                                    .manual,
                                                            lineXY: 0.35,
                                                            indicatorStyle:
                                                                IndicatorStyle(
                                                                    indicator:
                                                                        Icon(
                                                                      Icons
                                                                          .check_circle,
                                                                      color:
                                                                          kMainColor,
                                                                    ),
                                                                    color:
                                                                        kMainColor,
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            4.0)),
                                                            startChild: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 20.0,
                                                                      left:
                                                                          10.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Text(
                                                                    '${parcelLogs.parcel.createdAt} ',
                                                                    style: kTextStyle
                                                                        .copyWith(
                                                                            color:
                                                                                kTitleColor),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            endChild: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 20.0,
                                                                      left:
                                                                          10.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    'parcel_create'
                                                                        .tr,
                                                                    style: kTextStyle
                                                                        .copyWith(
                                                                            color:
                                                                                Colors.green),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Text(
                                                                    'name'.tr +
                                                                        ': ${parcelLogs.parcel.merchantName} ',
                                                                    style: kTextStyle
                                                                        .copyWith(
                                                                            color:
                                                                                kGreyTextColor),
                                                                  ),
                                                                  Text(
                                                                    'email'.tr +
                                                                        ': ${parcelLogs.parcel.customerName} ',
                                                                    style: kTextStyle
                                                                        .copyWith(
                                                                            color:
                                                                                kGreyTextColor),
                                                                  ),
                                                                  Text(
                                                                    'mobile'.tr +
                                                                        ': ${parcelLogs.parcel.merchantMobile} ',
                                                                    style: kTextStyle
                                                                        .copyWith(
                                                                            color:
                                                                                kGreyTextColor),
                                                                  ),
                                                                  const SizedBox(
                                                                    height:
                                                                        40.0,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            beforeLineStyle:
                                                                const LineStyle(
                                                              color: kMainColor,
                                                            ),
                                                          )
                                                        ],
                                                      )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      )
                    ]),
              )),
    );
  }

  Future<void> generateAndShareInvoice() async {
    // Create a PDF document
    final pdf = pdfWidgets.Document();

    // Add content to the PDF
    addInvoiceContent(pdf);

    // Save the PDF to a file
    final String path = (await getTemporaryDirectory()).path;
    final String filePath = '$path/invoice.pdf';
    final File file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Share the PDF via WhatsApp
    Share.shareFiles([filePath], text: 'Arha Invoice', subject: 'Arha Invoice');
  }

  Future<void> addInvoiceContent(pdfWidgets.Document pdf) async {
    final Uint8List logoImageBytes = (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List();

    pdf.addPage(
      pdfWidgets.Page(
        build: (context) => pdfWidgets.Center(
          child: pdfWidgets.Column(
            mainAxisAlignment: pdfWidgets.MainAxisAlignment.center,
            crossAxisAlignment: pdfWidgets.CrossAxisAlignment.center,
            children: <pdfWidgets.Widget>[

              pdfWidgets.Image(
                pdfWidgets.MemoryImage(logoImageBytes),
                width: 300,
                height: 150,
              ),

              pdfWidgets.Row(children: [
                pdfWidgets.Text(
                  'Invoice No. ${widget.parcel.invoiceNO}',
                  style: pdfWidgets.TextStyle(
                    fontSize: 20.0,
                    fontWeight: pdfWidgets.FontWeight.bold,
                  ),
                ),
                pdfWidgets.Spacer(),
                pdfWidgets.Text(
                  '${widget.parcel.statusName}',
                ),
              ]),
              pdfWidgets.SizedBox(height: 15.0),
              pdfWidgets.Text(
                'Parcel Info'.tr,
                style: pdfWidgets.TextStyle(
                    fontSize: 18.0, fontWeight: pdfWidgets.FontWeight.bold),
              ),
              pdfWidgets.Divider(
                thickness: 1.0,
              ),
              pdfWidgets.SizedBox(height: 10.0),
              pdfWidgets.Row(
                children: [
                  pdfWidgets.Text(
                    'Tracking Id'.tr + ':',
                    style: pdfWidgets.TextStyle(
                        fontWeight: pdfWidgets.FontWeight.bold),
                  ),
                  pdfWidgets.Spacer(),
                  pdfWidgets.Text(
                    widget.parcel.trackingId.toString(),
                  ),
                ],
              ),
              pdfWidgets.SizedBox(height: 5.0),
              pdfWidgets.Row(
                children: [
                  pdfWidgets.Text(
                    'Weight'.tr + ':',
                    style: pdfWidgets.TextStyle(
                        fontWeight: pdfWidgets.FontWeight.bold),
                  ),
                  pdfWidgets.Spacer(),
                  pdfWidgets.Text(
                    widget.parcel.weight.toString(),
                  ),
                ],
              ),
              pdfWidgets.SizedBox(height: 5.0),
              pdfWidgets.Row(
                children: [
                  pdfWidgets.Text(
                    'Distance'.tr + ':',
                    style: pdfWidgets.TextStyle(
                        fontWeight: pdfWidgets.FontWeight.bold),
                  ),
                  pdfWidgets.Spacer(),
                  pdfWidgets.Text(
                    '${formatted_distance}' + " km",
                  ),
                ],
              ),
              pdfWidgets.SizedBox(height: 5.0),
              pdfWidgets.Row(
                children: [
                  pdfWidgets.Text(
                    'GST Type'.tr,
                    style: pdfWidgets.TextStyle(
                        fontWeight: pdfWidgets.FontWeight.bold),
                  ),
                  pdfWidgets.Spacer(),
                  pdfWidgets.Text(
                    '${widget.parcel.deliveryDate}',
                  ),
                ],
              ),
              pdfWidgets.SizedBox(height: 5.0),
              pdfWidgets.Row(
                children: [
                  pdfWidgets.Text(
                    'GST Number'.tr,
                    style: pdfWidgets.TextStyle(
                        fontWeight: pdfWidgets.FontWeight.bold),
                  ),
                  pdfWidgets.Spacer(),
                  pdfWidgets.Text(
                    '${widget.parcel.pickupDate}',
                  ),
                ],
              ),
              pdfWidgets.SizedBox(height: 10.0),
              pdfWidgets.Text(
                'Charges Info'.tr,
                style: pdfWidgets.TextStyle(
                    fontSize: 18.0, fontWeight: pdfWidgets.FontWeight.bold),
              ),
              pdfWidgets.Divider(
                thickness: 1.0,
              ),
              pdfWidgets.SizedBox(height: 5.0),
              pdfWidgets.Row(
                children: [
                  pdfWidgets.Text(
                    'Delivery Charges (${widget.parcel.createdAt} x ${widget.parcel.updatedAt})',
                    style: pdfWidgets.TextStyle(
                        fontWeight: pdfWidgets.FontWeight.bold),
                  ),
                  pdfWidgets.Spacer(),
                  pdfWidgets.Text(
                    'Rs.'+'${widget.parcel.parcelTime}',
                  ),
                ],
              ),
              pdfWidgets.SizedBox(height: 5.0),
              pdfWidgets.Row(
                children: [
                  pdfWidgets.Text(
                    'P.Charges',
                    style: pdfWidgets.TextStyle(
                        fontWeight: pdfWidgets.FontWeight.bold),
                  ),
                  pdfWidgets.Spacer(),
                  pdfWidgets.Text(
                    'Rs.'+'${widget.parcel.packagingamount}',
                  ),
                ],
              ),
              pdfWidgets.SizedBox(height: 5.0),
              pdfWidgets.Row(
                children: [
                  pdfWidgets.Text(
                    'Vat (${widget.parcel.vat} %)',
                    style: pdfWidgets.TextStyle(
                        fontWeight: pdfWidgets.FontWeight.bold),
                  ),
                  pdfWidgets.Spacer(),
                  pdfWidgets.Text(
                    'Rs.'+'${widget.parcel.vatAmount}',
                  ),
                ],
              ),
              pdfWidgets.SizedBox(height: 5.0),
              pdfWidgets.Row(
                children: [
                  pdfWidgets.Text(
                    'Total Charges',
                    style: pdfWidgets.TextStyle(
                        fontWeight: pdfWidgets.FontWeight.bold),
                  ),
                  pdfWidgets.Spacer(),
                  pdfWidgets.Text(
                    'Rs.'+'${widget.parcel.totalDeliveryAmount}',

                  ),
                ],
              ),
              pdfWidgets.SizedBox(height: 10.0),
              pdfWidgets.Text(
                'Sender Info'.tr,
                style: pdfWidgets.TextStyle(
                    fontSize: 18.0, fontWeight: pdfWidgets.FontWeight.bold),
              ),
              pdfWidgets.Divider(
                thickness: 1.0,
              ),
              pdfWidgets.SizedBox(height: 10.0),
              pdfWidgets.Row(
                children: [
                  pdfWidgets.Text(
                    'Name'.tr + ':',
                    style: pdfWidgets.TextStyle(
                        fontWeight: pdfWidgets.FontWeight.bold),
                  ),
                  pdfWidgets.Spacer(),
                  pdfWidgets.Text(
                    widget.parcel.merchantUserName.toString(),
                  ),
                ],
              ),
              pdfWidgets.SizedBox(height: 5.0),
              pdfWidgets.Row(
                children: [
                  pdfWidgets.Text(
                    'Mobile'.tr + ':',
                    style: pdfWidgets.TextStyle(
                        fontWeight: pdfWidgets.FontWeight.bold),
                  ),
                  pdfWidgets.Spacer(),
                  pdfWidgets.Text(
                    widget.parcel.merchantMobile.toString(),
                  ),
                ],
              ),
              pdfWidgets.SizedBox(height: 5.0),
              pdfWidgets.Row(
                children: [
                  pdfWidgets.Text(
                    'Email'.tr + ':',
                    style: pdfWidgets.TextStyle(
                        fontWeight: pdfWidgets.FontWeight.bold),
                  ),
                  pdfWidgets.Spacer(),
                  pdfWidgets.Text(
                    widget.parcel.merchantUserEmail.toString(),
                  ),
                ],
              ),
              pdfWidgets.SizedBox(height: 5.0),
              pdfWidgets.Row(
                children: [
                  pdfWidgets.SizedBox(
                    width: 70,
                    child: pdfWidgets.Text(
                      'Address',
                      style: pdfWidgets.TextStyle(
                          fontWeight: pdfWidgets.FontWeight.bold),
                    ),
                  ),
                  pdfWidgets.Flexible(
                      child: pdfWidgets.Text(
                    widget.parcel.merchantAddress.toString(),
                  )),
                ],
              ),
              pdfWidgets.SizedBox(height: 20.0),
              pdfWidgets.Text(
                'Recipient Info'.tr,
                style: pdfWidgets.TextStyle(
                    fontSize: 18.0,fontWeight: pdfWidgets.FontWeight.bold),
              ),
              pdfWidgets.Divider(
                thickness: 1.0,
              ),
              pdfWidgets.SizedBox(height: 10.0),
              pdfWidgets.Row(
                children: [
                  pdfWidgets.Text(
                    'Name'.tr + ':',
                    style: pdfWidgets.TextStyle(
                        fontWeight: pdfWidgets.FontWeight.bold),
                  ),
                  pdfWidgets.Spacer(),
                  pdfWidgets.Text(
                    widget.parcel.customerName.toString(),
                  ),
                ],
              ),
              pdfWidgets.SizedBox(height: 5.0),
              pdfWidgets.Row(
                children: [
                  pdfWidgets.Text(
                    'Phone'.tr + ':',
                    style: pdfWidgets.TextStyle(
                        fontWeight: pdfWidgets.FontWeight.bold),
                  ),
                  pdfWidgets.Spacer(),
                  pdfWidgets.Text(
                    widget.parcel.customerPhone.toString(),
                  ),
                ],
              ),
              pdfWidgets.SizedBox(height: 5.0),
              pdfWidgets.Row(
                children: [
                  pdfWidgets.SizedBox(
                    width: 70,
                    child: pdfWidgets.Text(
                      'Pin Code'.tr,
                      style: pdfWidgets.TextStyle(
                          fontWeight: pdfWidgets.FontWeight.bold),
                    ),
                  ),
                  pdfWidgets.Spacer(),
                  pdfWidgets.Text(
                    widget.parcel.pinCode.toString(),
                  ),
                ],
              ),
              pdfWidgets.SizedBox(height: 5.0),
              pdfWidgets.Row(
                children: [
                  pdfWidgets.SizedBox(
                    width: 90,
                    child: pdfWidgets.Text(
                      'Full Address',
                      style: pdfWidgets.TextStyle(
                          fontWeight: pdfWidgets.FontWeight.bold),
                    ),
                  ),
                  pdfWidgets.Spacer(),
                  pdfWidgets.Text(
                    widget.parcel.customerfulladdress.toString(),
                  ),
                ],
              ),
              pdfWidgets.SizedBox(height: 5.0),
              pdfWidgets.Row(
                children: [
                  pdfWidgets.SizedBox(
                    width: 70,
                    child: pdfWidgets.Text(
                      'Address',
                      style: pdfWidgets.TextStyle(
                          fontWeight: pdfWidgets.FontWeight.bold),
                    ),
                  ),
                  pdfWidgets.Flexible(
                      child: pdfWidgets.Text(
                    widget.parcel.customerAddress.toString(),
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
