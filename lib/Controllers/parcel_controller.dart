import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:we_courier_merchant_app/ParcelRequest/filtershubsmodel.dart';
import 'package:we_courier_merchant_app/Screen/Parcel/parcelshopdatamodel.dart';
import 'package:we_courier_merchant_app/Screen/ParcelTrack/parcelTrackingModel.dart';
import '../Models/distanceChargesModel.dart';
import '../Models/parcel_crate_model.dart';
import '../Models/parcel_logs_model.dart';
import '../Models/parcels_model.dart';
import '../Models/shop_model.dart';
import '../Screen/Widgets/button_global.dart';
import '../Screen/Widgets/constant.dart';
import '/services/api-list.dart';
import '/services/server.dart';
import '/services/user-service.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:intl/intl.dart';




class ParcelController extends GetxController {
  UserService userService = UserService();
  Server server = Server();
  bool loader = true;
  bool loaderParcel = false;
  bool loaderLogs = true;
  List<Parcels> parcelList = <Parcels>[];

//  List<Shops> shopList = <Shops>[];
  List<Packagings> packagingList = <Packagings>[];
  List<DeliveryCharges> deliveryChargesList = <DeliveryCharges>[];
  List<DropdownMenuItem<ShopsData>> dropDownItems = [];

  late double fragileLiquidAmount = 0;
  late int shopIndex = 0;
  late int packagingIndex = 0;
  late int deliveryChargesIndex = 0;
  MerchantData merchantData = MerchantData();
  DeliveryCharges deliveryChargesValue = DeliveryCharges();
  String pickupPhone = '';
  String pickupLate = '';
  String pickupLong = '';
  String pickupAddress = '';
  String shopID = '';
  String merchantID = '';
  String packagingID = '';
  String packagingPrice = '0';
  String deliveryChargesID = '';
  String deliveryTypID = 'Same Day';
  String deliveryChargesPrice = '0';
  bool isLiquidChecked = false;
  bool isParcelBankCheck = false;
  double vatTax = 0;
  double vatAmount = 0;
  double merchantCodCharges = 0;
  double totalCashCollection = 0;
  double deliveryChargeAmount = 0;
  double codChargeAmount = 0;
  double packagingAmount = 0;
  double totalDeliveryChargeAmount = 0;
  double currentPayable = 0;
  double netPayable = 0;
  double fragileLiquidAmounts = 0;

  TextEditingController pickupPhoneController = TextEditingController();
  TextEditingController pickupAddressController = TextEditingController();
  TextEditingController pickupAddressLatController = TextEditingController();
  TextEditingController pickupAddressLongController = TextEditingController();
  TextEditingController cashCollectionController = TextEditingController();
  TextEditingController sellingPriceController = TextEditingController();
  TextEditingController invoiceController = TextEditingController();
  TextEditingController customerController = TextEditingController();
  TextEditingController customerPhoneController = TextEditingController();
  TextEditingController customerAddressController = TextEditingController();
  TextEditingController customerAddressLatController = TextEditingController();
  TextEditingController customerAddressLongController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  TextEditingController fulladdressController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController gstController = TextEditingController();

  List<ParcelEvents> parcelLogsList = <ParcelEvents>[];
  late Parcel parcel;

  late String email = '';
  late String hubname = '';
  late String mobile = '';
  late String hubid = '';

  List<HubInc> hubIncList = <HubInc>[];
  List<dynamic> countriesList = [];
  List<dynamic> husbDataList = [];

  var Nvat;
  var Nvat_amount;
  var Ndelivery_amount;
  var Ndistance_amount;
  var Ndistance_total;
  var Ndistance_id;
  var Nrazorpay_key;

  var Npacking_charges;
  var InvoiceDistance;

  var parcelstausname;
  var parcelcreatedDate;
  var parcelnane;
  var parcelPhone;
  var parcelemail;
  var parcelTrackingid;
  var parcelpickupaddress;
  var parceldeliverytype;
  var parcelpickupdate;
  var parceldeliveryDate;
  var parceltotalDeliveryAmount;
  var parcelVatAmount;
  var parcelcurrentPayable;
  var parcelcashCollection;
  var parcelmerchantName;
  var parcelmerchantMobile;
  var parcelcustomerName;

  String PaymentType = '';
  String razorpay_payment_id = '';
  String paymentResponse = '';
  String payment_status = '';

  @override
  void onInit() {
    getParcel();
    super.onInit();
  }

  getParcelList() async {
    loader = true;
    Future.delayed(Duration(milliseconds: 10), () {
      update();
    });
    getParcel();
  }

  getParcel() {
    server.getRequest(endPoint: APIList.parcelList).then((response) async {
      print(json.decode(response.body));
      if (response != null && response.statusCode == 200) {
        loader = false;
        final jsonResponse = json.decode(response.body);
        var parcelData = ParcelsModel.fromJson(jsonResponse);
        parcelList = <Parcels>[];
        parcelList.addAll(parcelData.data!.parcels!);

        InvoiceDistance = parcelData.data?.parcels?.first?.cashCollection;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('trackingId',
            parcelData.data!.parcels!.first!.trackingId.toString());

        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
      } else {
        loader = false;
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
      }
    });
  }

  searchFilterHubs(String mobileno) async {
    loader = true;
    Future.delayed(Duration(milliseconds: 10), () {
      update();
    });

    Map body = {'search_query': mobileno};
    String jsonBody = json.encode(body);
    print(jsonBody);
    server
        .postRequest(endPoint: APIList.filtershub, body: jsonBody)
        .then((response) {
      if (response != null && response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print(jsonResponse);
        var filterhubsData = FiltersHubsModel.fromJson(jsonResponse);

        hubIncList = <HubInc>[];
        hubIncList.addAll(filterhubsData.data!.hubInc!);

        if (filterhubsData.success!) {
          countriesList.clear();
          for (var data in filterhubsData.data!.hubInc!) {
            countriesList.add(data.name);
          }
          Get.rawSnackbar(
              message: "${filterhubsData.message}",
              backgroundColor: Colors.green);
          return countriesList.toList();
        }
        loader = false;
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
      } else if (response != null && response.statusCode == 422) {
        final jsonResponse = json.decode(response.body);
        print(jsonResponse);
        if (jsonResponse['data']['message']['mobile'] != null) {
          Get.rawSnackbar(
              message: jsonResponse['data']['message']['mobile'].toString(),
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.BOTTOM);
        }
        loader = false;
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
      } else {
        loader = false;
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
        Get.rawSnackbar(message: 'Please enter valid entry ');
      }
    });
  }

  FilterHubs(String hubdata) async {
    loader = true;
    Future.delayed(Duration(milliseconds: 10), () {
      update();
    });

    Map body = {'search_query': hubdata};
    String jsonBody = json.encode(body);
    print(jsonBody);
    server
        .postRequest(endPoint: APIList.filtershub, body: jsonBody)
        .then((response) {
      if (response != null && response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print(jsonResponse);
        var filterhubsData = FiltersHubsModel.fromJson(jsonResponse);

        hubIncList = <HubInc>[];
        hubIncList.addAll(filterhubsData.data!.hubInc!);

        if (filterhubsData.success!) {
          hubname = filterhubsData.data!.hubInc!.first.name.toString();
          mobile = filterhubsData.data!.hubInc!.first.mobile.toString();
          email = filterhubsData.data!.hubInc!.first.email.toString();
          hubid = filterhubsData.data!.hubInc!.first.hubId.toString();

          print("againHit ==> ${hubname}");

          Get.rawSnackbar(
              message: "${filterhubsData.message}",
              backgroundColor: Colors.green);
        }
        loader = false;
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
      } else if (response != null && response.statusCode == 422) {
        final jsonResponse = json.decode(response.body);
        print(jsonResponse);
        if (jsonResponse['data']['message']['mobile'] != null) {
          Get.rawSnackbar(
              message: jsonResponse['data']['message']['mobile'].toString(),
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.BOTTOM);
        }
        loader = false;
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
      } else {
        loader = false;
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
        Get.rawSnackbar(message: 'Please enter valid entry ');
      }
    });
  }

  TransferHubRequest(String hubId, String orderId) async {
    loader = true;
    Future.delayed(Duration(milliseconds: 10), () {
      update();
    });

    var myInt = int.parse(orderId);
    assert(myInt is int);
    print(myInt);

    Map<String, dynamic> myObject = {
      "hub_id": hubId,
      "parcel_ids": [myInt],
      "request_status": 0
    };

    String jsonBody = json.encode(myObject);
    print(jsonBody);
    server
        .postRequestWithToken(
            endPoint: APIList.HubTrabsferRequest, body: jsonBody)
        .then((response) {
      final jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (response != null && response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        loaderParcel = false;
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
        getParcelList();
        Get.back();
        Get.rawSnackbar(
            message: "${jsonResponse['message']}",
            backgroundColor: Colors.green,
            snackPosition: SnackPosition.BOTTOM);
      } else if (response != null && response.statusCode == 422) {
        loaderParcel = false;
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
      } else {
        loaderParcel = false;
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
        Get.rawSnackbar(message: 'Please enter valid input');
      }
    });
  }

  getParcelLogs(id) {
    loaderLogs = true;
    Future.delayed(Duration(milliseconds: 10), () {
      update();
    });
    parcelLogsList = <ParcelEvents>[];
    server
        .getRequest(endPoint: APIList.parcelLogs! + id.toString())
        .then((response) {
      if (response != null && response.statusCode == 200) {
        loaderLogs = false;

        final jsonResponse = json.decode(response.body);
        var parcelData = ParcelLogsModel.fromJson(jsonResponse);
        parcelLogsList = <ParcelEvents>[];
        parcelLogsList.addAll(parcelData.data!.parcelEvents!);
        parcel = parcelData.data!.parcel!;
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
      } else {
        loaderLogs = false;
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
      }
    });
  }

  getDistanceCharges(String categoryID, double distance, String dropdownvalue, int counter, String deliveryAddress, String packagingPrice) {
    Map<String, dynamic> myObject = {
      "category_id": categoryID,
      "distance": distance,
      "gst_type": dropdownvalue,
      "state": deliveryAddress,
      "quantity": counter,
      "packing_charges": packagingPrice
    };

    String jsonBody = json.encode(myObject);
    print("JsonBody ==> ${jsonBody}");
    server.postRequestWithToken(endPoint: APIList.distanceCharges, body: jsonBody)
        .then((response) {
      final jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (response != null && response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        var data = DistanceChargesModel.fromJson(jsonResponse);
        Nvat = data.data?.distanceCharges?.vat?.toString();
        Nvat_amount = data.data?.distanceCharges?.vatAmount?.toString();
        Ndelivery_amount = data.data?.distanceCharges?.deliveryAmount?.toString();
        Ndistance_amount = data.data?.distanceCharges?.distanceAmount?.toString();
        Ndistance_total = data.data?.distanceCharges?.distanceTotal?.toString();
        Ndistance_id = data.data?.distanceCharges?.id?.toString();
        Npacking_charges = data.data?.distanceCharges?.packingCharges?.toString();
        Nrazorpay_key = data.data?.distanceCharges?.razorpayKey?.toString();

        loaderParcel = false;
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
      } else if (response != null && response.statusCode == 422) {
        loaderParcel = false;
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
      } else {
        loaderParcel = false;
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
        Get.rawSnackbar(message: 'Please enter valid input');
      }
    });
  }

  crateParcel() {
    server.getRequest(endPoint: APIList.parcelCreate).then((response) {
      if (response != null && response.statusCode == 200) {
        loader = false;
        final jsonResponse = json.decode(response.body);
        var data = ParcelCrateModel.fromJson(jsonResponse);
        fragileLiquidAmount = double.parse(data.data!.fragileLiquid.toString());
        print(fragileLiquidAmount);
        vatTax = double.parse('0.0');
        packagingList = <Packagings>[];
        packagingList.add(Packagings(
          id: 0,
          name: 'select_packaging'.tr,
          price: '0',
        ));
        packagingList.addAll(data.data!.packagings!);
        deliveryChargesList = <DeliveryCharges>[];
        // deliveryChargesList.add(DeliveryCharges(id:0,/*category: 'select_category'.toInt(),weight: '0',*/));
        deliveryChargesList.addAll(data.data!.deliveryCharges!);

        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
      } else {
        loader = false;
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
      }
    });
  }


  clearAll() {
    fragileLiquidAmount = 0;
    fragileLiquidAmounts = 0;
    shopIndex = 0;
    packagingIndex = 0;
    deliveryChargesIndex = 0;
    deliveryChargesValue = DeliveryCharges();
    pickupPhone = '';
    pickupLate = '';
    pickupLong = '';
    pickupAddress = '';
    shopID = '';
    merchantID = '';
    packagingID = '';
    packagingPrice = '0';
    deliveryChargesID = '';
    deliveryTypID = 'Same Day';
    deliveryChargesPrice = '0';
    isLiquidChecked = false;
    isParcelBankCheck = false;
    pickupPhoneController.text = '';
    pickupAddressController.text = '';
    cashCollectionController.text = '';
    sellingPriceController.text = '';
    invoiceController.text = '';
    customerController.text = '';
    customerPhoneController.text = '';
    customerAddressController.text = '';
    customerAddressLatController.text = '';
    customerAddressLongController.text = '';
    noteController.text = '';
    vatTax = 0;
    vatAmount = 0;
    merchantCodCharges = 0;
    totalCashCollection = 0;
    deliveryChargeAmount = 0;
    codChargeAmount = 0;
    packagingAmount = 0;
    totalDeliveryChargeAmount = 0;
    currentPayable = 0;
    netPayable = 0;
    Future.delayed(Duration(milliseconds: 10), () {
      update();
    });
  }

  void calculateTotal(
      context,
      PickupAddress,
      deliveryAddress,
      String dropdownvalue,
      String userID,
      double distance,
      int counter,
      String? fromseedeliveryLat,
      String? fromseedeliveryLong) {
    totalDeliveryChargeAmount = 0;
    totalCashCollection = 0;
    codChargeAmount = 0;
    totalDeliveryChargeAmount = 0;
    vatAmount = 0;
    netPayable = 0;
    currentPayable = 0;

    merchantCodCharges = 0;
    packagingAmount = 0;
    fragileLiquidAmounts = 0;

    double deliveryChargeAmount = 0;
    double merchantCodCharge = 0;

    if (deliveryTypID == 'Same Day') {
      deliveryChargeAmount =
          double.parse(deliveryChargesValue.sameDay.toString());
      merchantCodCharge = double.parse(
          '0.0' /*merchantData.codCharges!.insideCity.toString()*/);
    } else if (deliveryTypID == 'Next Day') {
      deliveryChargeAmount =
          double.parse(deliveryChargesValue.nextDay.toString());
      merchantCodCharge = double.parse(
          '0.0' /*merchantData.codCharges!.insideCity.toString()*/);
    } else if (deliveryTypID == 'Sub City') {
      deliveryChargeAmount =
          double.parse(deliveryChargesValue.subCity.toString());
      merchantCodCharge =
          double.parse('0.0' /*merchantData.codCharges!.subCity.toString()*/);
    } else if (deliveryTypID == 'Outside City') {
      deliveryChargeAmount =
          double.parse(deliveryChargesValue.outsideCity.toString());
      merchantCodCharge = double.parse('0.0');
    } else {
      deliveryChargeAmount = 0;
      merchantCodCharge = 0;
    }
    packagingAmount = double.parse(packagingPrice.toString());
    totalCashCollection = double.parse("0.0");
    codChargeAmount = percentage(totalCashCollection, merchantCodCharge);
    if (isLiquidChecked) {
      totalDeliveryChargeAmount = (deliveryChargeAmount +
          codChargeAmount +
          fragileLiquidAmount +
          packagingAmount);
      fragileLiquidAmounts = fragileLiquidAmount;
    } else {
      totalDeliveryChargeAmount =
          (deliveryChargeAmount + codChargeAmount + packagingAmount);
      fragileLiquidAmounts = 0;
    }

    vatAmount = double.parse(Nvat);

    netPayable = (totalDeliveryChargeAmount + vatAmount);
    currentPayable = (totalCashCollection - (totalDeliveryChargeAmount + vatAmount));
    merchantCodCharges = merchantCodCharge;
    print('packagingAmount==> ' + '${packagingAmount}');
    print('deliveryChargeAmount==> ' + '${deliveryChargeAmount}');
    print('totalDeliveryChargeAmount==> ' + '${totalDeliveryChargeAmount}');
    print('totalCashCollection==> ' + '${totalCashCollection}');
    print('vatAmount==> ' + '${vatAmount}');
    print('codChargeAmount==> ' + '${codChargeAmount}');
    print('netPayable==> ' + '${netPayable}');
    print('currentPayable==> ' + '${currentPayable}');

    showPopUp(
        context,
        totalCashCollection,
        deliveryChargeAmount,
        codChargeAmount,
        fragileLiquidAmounts,
        packagingAmount,
        totalDeliveryChargeAmount,
        vatAmount,
        netPayable,
        currentPayable,
        deliveryAddress,
        dropdownvalue,
        userID,
        distance,
        counter,
        fromseedeliveryLat!,
        fromseedeliveryLong!);
    Future.delayed(Duration(milliseconds: 10), () {
      update();
    });
  }

  percentage(totalAmount, percentageAmount) {
    return totalAmount * (percentageAmount / 100);
  }

  void showPopUp(context, totalCashCollectionParcel, deliveryChargeAmountParcel,
      codChargeAmountParcel, fragileLiquidAmountsParcel, packagingAmountParcel,
      totalDeliveryChargeAmountParcel, vatAmountParcel, netPayableParcel,
      currentPayableParcel, deliveryAddress, String dropdownvalue, String userID, double distance, int counter,
      String fromseedeliveryLat,
      String fromseedeliveryLong) {
    // for chossing payment
    bool _cashOnDelivery = false;
    bool _onlinePayment = false;


    showDialog(barrierDismissible: false, context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('charge_details'.tr,
                        style: kTextStyle.copyWith(
                            color: kSecondaryColor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),

                      ListTile(
                        title: Text('title'.tr,
                          style: kTextStyle.copyWith(
                              color: kTitleColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                        trailing: Text('Amount'.tr,
                          style: kTextStyle.copyWith(
                              color: kTitleColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                      ),

                      Card(
                        child: ListTile(
                          title: Text('delivery_charges ($Ndistance_amount x $counter)'.tr,
                            style: kTextStyle.copyWith(color: kTitleColor,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: Text('${Ndistance_total}',
                            style: kTextStyle.copyWith(color: kTitleColor),
                          ),
                        ),
                      ),

                      Card(child: ListTile(
                          title: Text('p_charge'.tr,
                            style: kTextStyle.copyWith(
                                color: kTitleColor,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: Text(
                            '${packagingAmountParcel.toStringAsFixed(2)}',
                            style: kTextStyle.copyWith(color: kTitleColor),
                          ),
                        ),),

                      Card(
                        child: ListTile(
                          title: Text('Vat ($Nvat % ) '.tr, style: kTextStyle.copyWith(
                                color: kTitleColor,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: Text('${Nvat_amount}', style: kTextStyle.copyWith(color: kTitleColor),),
                        ),
                      ),

                      Card(
                        child: ListTile(
                          title: Text(
                            'total_charge'.tr,
                            style: kTextStyle.copyWith(
                                color: kTitleColor,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: Text(
                            '${Ndelivery_amount}',
                            style: kTextStyle.copyWith(color: kTitleColor),
                          ),
                        ),
                      ),

                      Row(
                        children: [
                          Checkbox(
                            value: _cashOnDelivery,
                            onChanged: (value) {
                              setState(() {
                                _cashOnDelivery = value!;
                                PaymentType = 'cod';
                                payment_status = 'Pending';
                              });
                            },
                          ),
                          Text('Cash on Delivery'),
                        ],
                      ),

                      Row(
                        children: [
                          Checkbox(
                            value: _onlinePayment,
                            onChanged: (value) {
                              setState(() {
                                _onlinePayment = value!;
                                PaymentType = 'Online Payment';
                                payment_status = 'Paid';

                                ImplementRazorPe(Nrazorpay_key,Ndelivery_amount);
                              });
                              },
                          ),
                          Text('Online Payment'),
                        ],
                      ),

                       const SizedBox(height: 30.0),

                       ButtonGlobal(buttontext: 'Confirm'.tr, buttonDecoration: kButtonDecoration,
                          onPressed: () {
                         if(_cashOnDelivery|| _onlinePayment){
                           FocusScope.of(context).requestFocus(new FocusNode());
                           parcelPost(deliveryAddress, dropdownvalue, userID, distance, counter, fromseedeliveryLat, fromseedeliveryLong,PaymentType,payment_status);
                           Get.back();
                           // Get.off(ParcelPage());
                         }else{
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please check for payment option')),);
                         }
                        })
                    ],
                  )),
                ),
              );
            },
          );
        });
  }



  void CallParcelTrackingIDApi(String parcelTrackingID) {
    loaderLogs = true;
    server.getwithoutHeadersRequest(endPoint: APIList.parceltrackingID! + parcelTrackingID.toString()).then((response) {
      loaderLogs = false;

      if (response != null && response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        var ParcelTrackingData = ParcelTrackingModel.fromJson(jsonResponse);
        CallGETParcelLogApi(
            ParcelTrackingData.data?.events?.first.parcelId.toString());

        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
      } else {
        loaderLogs = false;
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
      }
    });
  }

  void CallGETParcelLogApi(String? id) {
    loaderLogs = true;
    Future.delayed(Duration(milliseconds: 10), () {
      update();
    });
    parcelLogsList = <ParcelEvents>[];
    server.getRequest(endPoint: APIList.parcelLogs! + id.toString()).then((response) {
      if (response != null && response.statusCode == 200) {
        loaderLogs = false;

        final jsonResponse = json.decode(response.body);
        var parcelData = ParcelLogsModel.fromJson(jsonResponse);
        parcelLogsList = <ParcelEvents>[];
        parcelLogsList.addAll(parcelData.data!.parcelEvents!);
        parcel = parcelData.data!.parcel!;

        parcelcreatedDate = parcelData.data!.parcel!.createdAt!.toString();
        parcelstausname = parcelData.data!.parcel!.statusName!.toString();
        parcelpickupaddress = parcelData.data!.parcel!.merchantAddress!.toString();
        parceldeliverytype = parcelData.data!.parcel!.deliveryType!.toString();
        parcelcurrentPayable = parcelData.data!.parcel!.currentPayable!.toString();
        parcelcashCollection = parcelData.data!.parcel!.cashCollection!.toString();
        parcelmerchantName = parcelData.data!.parcel!.merchantName!.toString();
        parcelcustomerName = parcelData.data!.parcel!.customerName!.toString();
        parcelmerchantMobile = parcelData.data!.parcel!.merchantMobile!.toString();

        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
      } else {
        loaderLogs = false;
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
      }
    });
  }

  void ImplementRazorPe(nrazorpay_key, ndelivery_amount) {
    int myInt = int.parse(ndelivery_amount.split('.')[0]);

    print("onlneAmout ==> ${ndelivery_amount}");
    Razorpay razorpay = Razorpay();
    var options = {
      'key': nrazorpay_key,/*'rzp_test_1DP5mmOlF5G5ag',*/
      'amount': myInt*100,
      'name': 'Arha Courier service',
      'description': 'Parcel Creating',
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

  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    Get.rawSnackbar(message: "Payment Failed Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");

  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    razorpay_payment_id = response.paymentId.toString();
    paymentResponse = response.data.toString();

    print("paymentResponse ==>${response.data.toString()}");
    Get.rawSnackbar(message: "Payment Successful Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    Get.rawSnackbar(message: "External Wallet Selected ${response.walletName}");
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

  parcelPost(deliveryAddress, String dropdownvalue, String userID, double distance, int counter, String fromseedeliveryLat, String fromseedeliveryLong, String paymentType, String payment_status) {
    loaderParcel = true;
    Future.delayed(Duration(milliseconds: 10), () {
      update();
    });

    Map chargeDetails = {
      'vatTex': Nvat,
      'VatAmount': Nvat_amount,
      'deliveryChargeAmount': deliveryChargeAmount.toStringAsFixed(2),
      'codChargeAmount': codChargeAmount.toStringAsFixed(2),
      'totalDeliveryChargeAmount': Ndelivery_amount,
      'currentPayable': currentPayable.toStringAsFixed(2),
      'packagingAmount': packagingAmount.toStringAsFixed(2),
      'liquidFragileAmount': fragileLiquidAmounts.toStringAsFixed(2),
    };

    Map body = {
      'chargeDetails': jsonEncode(chargeDetails),
      'shop_id': '0',
      'merchant_id': userID,
      'weight': deliveryChargesValue.weight == '0' ? '' : deliveryChargesValue.weight,
      'pickup_phone': pickupPhoneController.text.toString(),
      'pickup_address': pickupAddressController.text.toString(),
      'pickup_lat': fromseedeliveryLat,
      'pickup_long': fromseedeliveryLong,
      'invoice_no': invoiceController.text.toString(),
      'cash_collection': "0.0",
      'selling_price': sellingPriceController.text.toString(),
      'category_id': deliveryChargesValue.categoryId.toString(),
      'delivery_type_id': "2" /*deliveryTypID == 'Next Day'? 1: deliveryTypID == 'Same Day'?2: deliveryTypID == 'Sub City'?3: deliveryTypID == 'Outside City'?4:''*/,
      'customer_name': customerController.text.toString(),
      'customer_address': deliveryAddress,
      'lat': customerAddressLatController.text.toString(),
      'long': customerAddressLongController.text.toString(),
      'customer_phone': customerPhoneController.text.toString(),
      'note': noteController.text.toString(),
      'parcel_bank': isParcelBankCheck ? 'on' : '',
      'packaging_id': packagingID == '0' ? '' : packagingID,
      'fragileLiquid': isLiquidChecked ? 'on' : '',
      'gst_type': dropdownvalue.toString(),
      'gst_number': gstController.text.toString(),
      'pin_code': pincodeController.text.toString(),
      'customer_fullAddress': fulladdressController.text.toString(),
      'quantity': counter,
      'distance_amount': Ndistance_amount,
      'distance': distance,
      'distance_id': Ndistance_id,
      'distance_total': Ndistance_total.toString(),
      'payment_type':paymentType,
      'payment_status':payment_status,
      'tranasction_id':razorpay_payment_id,
      'razorpay_payment_id':razorpay_payment_id,
      'payment_response':paymentResponse
    };

    String jsonBody = json.encode(body);
    print("Request ==> ${jsonBody}");
    server.postRequestWithToken(endPoint: APIList.parcelStore, body: jsonBody).then((response) {
      final jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (response != null && response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        var parceldata = ParcelShopDataModel.fromJson(jsonResponse);
        sendDatainPDF(parceldata);



        clearAll();
        loaderParcel = false;
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
        getParcelList();
        Get.back();
        Get.rawSnackbar(
            message: "${jsonResponse['message']}",
            backgroundColor: Colors.green,
            snackPosition: SnackPosition.TOP);
      } else if (response != null && response.statusCode == 422) {
        loaderParcel = false;
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
      } else {
        loaderParcel = false;
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
        Get.rawSnackbar(message: 'Please enter valid input');
      }
    });
  }

}

Future<void> sendDatainPDF(ParcelShopDataModel parceldata) async {
// Create a PDF document
  final pdf = pdfWidgets.Document();

  // Add content to the PDF
  addInvoiceContent(pdf,parceldata);

  // Save the PDF to a file
  final String path = (await getTemporaryDirectory()).path;
  final String filePath = '$path/invoice.pdf';
  final File file = File(filePath);
  await file.writeAsBytes(await pdf.save());
String Pdfbase64file = base64Encode(File(filePath).readAsBytesSync());
String pareclPdfid = parceldata.data!.parcelLogInvoice!.id.toString();
  sendPdfTOServer(pareclPdfid,Pdfbase64file);
  // Share the PDF via WhatsApp
 // Share.shareFiles([filePath], text: 'Arha Invoice', subject: 'Arha Invoice');
}

Future<void> addInvoiceContent(pdfWidgets.Document pdf, ParcelShopDataModel parceldata) async {
  final Uint8List logoImageBytes = (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List();
 /* String stringValue = parceldata.data!.parcelLogInvoice!.distanceTotal.toString();
  double value = double.parse(stringValue);

  NumberFormat formatter = NumberFormat('#.##');
  String formatted_distance = formatter.format(value);*/
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
                'Invoice No. ${parceldata.data?.parcelLogInvoice?.invoiceNo}',
                style: pdfWidgets.TextStyle(
                  fontSize: 20.0,
                  fontWeight: pdfWidgets.FontWeight.bold,
                ),
              ),
              pdfWidgets.Spacer(),
              pdfWidgets.Text(
                '${parceldata.data?.parcelLogInvoice?.statusName}',
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
                  parceldata.data!.parcelLogInvoice!.trackingId.toString(),
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
                  parceldata.data!.parcelLogInvoice!.weight.toString(),
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
                  '' + " km",
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
                  '${parceldata.data?.parcelLogInvoice?.deliveryDate}',
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
                  '${parceldata.data?.parcelLogInvoice?.pickupDate}',
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
                  'Delivery Charges (${parceldata.data?.parcelLogInvoice?.createdAt} x ${parceldata.data?.parcelLogInvoice?.updatedAt})',
                  style: pdfWidgets.TextStyle(
                      fontWeight: pdfWidgets.FontWeight.bold),
                ),
                pdfWidgets.Spacer(),
                pdfWidgets.Text(
                  'Rs.'+'${parceldata.data?.parcelLogInvoice?.parcelTime}',
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
                  'Rs.'+'${parceldata.data?.parcelLogInvoice?.packagingAmount}',
                ),
              ],
            ),
            pdfWidgets.SizedBox(height: 5.0),
            pdfWidgets.Row(
              children: [
                pdfWidgets.Text(
                  'Vat (${parceldata.data?.parcelLogInvoice?.vat} %)',
                  style: pdfWidgets.TextStyle(
                      fontWeight: pdfWidgets.FontWeight.bold),
                ),
                pdfWidgets.Spacer(),
                pdfWidgets.Text(
                  'Rs.'+'${parceldata.data?.parcelLogInvoice?.vatAmount}',
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
                  'Rs.'+'${parceldata.data?.parcelLogInvoice?.totalDeliveryAmount}',

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
                  // parceldata.data?.parcelLogInvoice?.merchantUserName.toString(),
                ''),
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
                //  parceldata.data!.parcelLogInvoice!.merchantMobile.toString(),
               '' ),
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
                 // parceldata.data!.parcelLogInvoice!.merchantUserEmail.toString(),
                  '',
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
                     // parceldata.data!.parcelLogInvoice!.merchantAddress.toString(),
                    '')),
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
                  parceldata.data!.parcelLogInvoice!.customerName.toString(),
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
                  parceldata.data!.parcelLogInvoice!.customerPhone.toString(),
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
                  parceldata.data!.parcelLogInvoice!.pinCode.toString(),
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
                  parceldata.data!.parcelLogInvoice!.customerFullAddress.toString(),
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
                      parceldata.data!.parcelLogInvoice!.customerAddress.toString(),
                    )),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

void sendPdfTOServer(String pareclPdfid, String pdfbase64file) {
  Server server = Server();

  Map body = {
    'parcel_id':pareclPdfid.toInt(),
    'invoice':pdfbase64file
  };
  String jsonBody = json.encode(body);
  print("PdfR ==> ${jsonBody}");

  server.postRequestWithToken(endPoint: APIList.parcelPdf, body: jsonBody).then((response) {
    final jsonResponse = json.decode(response.body);
    print(jsonResponse);
    if (response != null && response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print("PdfRes ==> ${jsonResponse.toString()}");

      Get.rawSnackbar(
          message: "${jsonResponse['message']}",
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.TOP);
    } else if (response != null && response.statusCode == 422) {
      Future.delayed(Duration(milliseconds: 10), () {
      });
    } else {
      Get.rawSnackbar(message: 'Please enter valid input');
    }

  });


}


