import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:we_courier_merchant_app/ParcelRequest/filtershubsmodel.dart';
import '../Models/parcel_crate_model.dart';
import '../Models/parcel_logs_model.dart';
import '../Models/parcels_model.dart';
import '../Models/shop_model.dart';
import '../ParcelRequest/transfertohubModel.dart';
import '../Screen/Widgets/button_global.dart';
import '../Screen/Widgets/constant.dart';
import '/services/api-list.dart';
import '/services/server.dart';
import '/services/user-service.dart';
import 'package:get/get.dart';

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


  late String email ='';
  late String hubname = '';
  late String mobile = '';
  late String hubid = '';

  List<HubInc> hubIncList = <HubInc>[];
  List<dynamic> countriesList = [];
  List<dynamic> husbDataList = [];



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
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('trackingId', parcelData.data!.parcels!.first!.trackingId.toString());

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
    server.postRequest(endPoint: APIList.filtershub, body: jsonBody).then((response) {
      if (response != null && response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print(jsonResponse);
        var filterhubsData = FiltersHubsModel.fromJson(jsonResponse);

        hubIncList = <HubInc>[];
        hubIncList.addAll(filterhubsData.data!.hubInc!);

        if(filterhubsData.success!){
          countriesList.clear();
          for (var data in filterhubsData.data!.hubInc!) {
            countriesList.add(data.name);
          }
          Get.rawSnackbar(message: "${filterhubsData.message}", backgroundColor: Colors.green);
          return  countriesList.toList();
        }
        loader = false;
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
      }else if (response != null && response.statusCode == 422) {
        final jsonResponse = json.decode(response.body);
        print(jsonResponse);
        if (jsonResponse['data']['message']['mobile'] != null) {
          Get.rawSnackbar(message: jsonResponse['data']['message']['mobile'].toString(),backgroundColor: Colors.red,
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
    server.postRequest(endPoint: APIList.filtershub, body: jsonBody).then((response) {
      if (response != null && response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print(jsonResponse);
        var filterhubsData = FiltersHubsModel.fromJson(jsonResponse);

        hubIncList = <HubInc>[];
        hubIncList.addAll(filterhubsData.data!.hubInc!);

        if(filterhubsData.success!){
          hubname = filterhubsData.data!.hubInc!.first.name.toString();
          mobile = filterhubsData.data!.hubInc!.first.mobile.toString();
          email = filterhubsData.data!.hubInc!.first.email.toString();
          hubid = filterhubsData.data!.hubInc!.first.hubId.toString();

          print("againHit ==> ${hubname}");

          Get.rawSnackbar(message: "${filterhubsData.message}", backgroundColor: Colors.green);
        }
        loader = false;
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
      }else if (response != null && response.statusCode == 422) {
        final jsonResponse = json.decode(response.body);
        print(jsonResponse);
        if (jsonResponse['data']['message']['mobile'] != null) {
          Get.rawSnackbar(message: jsonResponse['data']['message']['mobile'].toString(),backgroundColor: Colors.red,
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

  TransferHubRequest(String hubId,String orderId )async{
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
      "request_status":0
    };

    String jsonBody = json.encode(myObject);
    print(jsonBody);
    server.postRequestWithToken(endPoint: APIList.HubTrabsferRequest, body: jsonBody).then((response) {
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
    server.getRequest(endPoint: APIList.parcelLogs!+id.toString()).then((response) {
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

  crateParcel() {
    server.getRequest(endPoint: APIList.parcelCreate).then((response) {
      if (response != null && response.statusCode == 200) {
        loader = false;
        final jsonResponse = json.decode(response.body);
        var data = ParcelCrateModel.fromJson(jsonResponse);
        fragileLiquidAmount = double.parse(data.data!.fragileLiquid.toString());
        print(fragileLiquidAmount);
        // merchantData = data.data!.merchant!;
        vatTax = double.parse('0.0'/*merchantData.vat.toString()*/);
        // shopList = <Shops>[];
        // shopList.addAll(data.data!.shops!);
        packagingList = <Packagings>[];
        packagingList.add(Packagings(id:0,name: 'select_packaging'.tr,price: '0',));
        packagingList.addAll(data.data!.packagings!);
        deliveryChargesList = <DeliveryCharges>[];
        // deliveryChargesList.add(DeliveryCharges(id:0,/*category: 'select_category'.toInt(),weight: '0',*/));
        deliveryChargesList.addAll(data.data!.deliveryCharges!);
        /* if(shopList.isNotEmpty){
          pickupPhone = shopList[shopIndex].contactNo.toString();
          pickupAddress = shopList[shopIndex].address.toString();
          pickupLate = shopList[shopIndex].merchantLat.toString();
          pickupLong = shopList[shopIndex].merchantLong.toString();
          merchantID = shopList[shopIndex].merchantId.toString();
          shopID = shopList[shopIndex].id.toString();
        }*/
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

  parcelPost(deliveryAddress, String dropdownvalue, String userID) {
    loaderParcel = true;
    Future.delayed(Duration(milliseconds: 10), () {
      update();
    });
    Map chargeDetails = {
      'vatTex': merchantData.vat,
      'VatAmount': vatAmount.toStringAsFixed(2),
      'deliveryChargeAmount': deliveryChargeAmount.toStringAsFixed(2),
      'codChargeAmount': codChargeAmount.toStringAsFixed(2),
      'totalDeliveryChargeAmount': totalDeliveryChargeAmount.toStringAsFixed(2),
      'currentPayable': currentPayable.toStringAsFixed(2),
      'packagingAmount': packagingAmount.toStringAsFixed(2),
      'liquidFragileAmount': fragileLiquidAmounts.toStringAsFixed(2),
    };

    Map body = {
      'chargeDetails': jsonEncode(chargeDetails),
      'shop_id': '0'/*shopID*/,
      'merchant_id': userID/*merchantID*/  /*need to user Id that form Login User*/ ,
      'weight': deliveryChargesValue.weight == '0'?'':deliveryChargesValue.weight,
      'pickup_phone': pickupPhoneController.text.toString(),
      'pickup_address': pickupAddressController.text.toString(),
      'pickup_lat': pickupLate,
      'pickup_long': pickupLong,
      'invoice_no': invoiceController.text.toString(),
      'cash_collection': "0.0"/*cashCollectionController.text.toString()*/,
      'selling_price': sellingPriceController.text.toString(),
      'category_id': deliveryChargesValue.categoryId.toString(),
      'delivery_type_id': "2"/*deliveryTypID == 'Next Day'? 1: deliveryTypID == 'Same Day'?2: deliveryTypID == 'Sub City'?3: deliveryTypID == 'Outside City'?4:''*/,
      'customer_name': customerController.text.toString(),
      'customer_address': deliveryAddress/*customerAddressController.text.toString()*/,
      'lat': customerAddressLatController.text.toString(),
      'long': customerAddressLongController.text.toString(),
      'customer_phone': customerPhoneController.text.toString(),
      'note': noteController.text.toString(),
      'parcel_bank': isParcelBankCheck ? 'on':'',
      'packaging_id': packagingID == '0'?'':packagingID,
      'fragileLiquid': isLiquidChecked ? 'on':'',
      'gst_type':dropdownvalue.toString(),
      'gst_number':gstController.text.toString(),
      'pin_code':pincodeController.text.toString(),
      'customer_fullAddress':fulladdressController.text.toString()
    };

    String jsonBody = json.encode(body);
    print(jsonBody);
    server.postRequestWithToken(endPoint: APIList.parcelStore, body: jsonBody).then((response) {
      final jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (response != null && response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print("PostParcel ==> ${jsonResponse.toString()}");
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

  void calculateTotal(context,PickupAddress, deliveryAddress, String dropdownvalue, String userID) {
    print("Address ==> ${PickupAddress+ ": "+deliveryAddress}");
    totalDeliveryChargeAmount   = 0;
    totalCashCollection = 0;
    codChargeAmount = 0;
    totalDeliveryChargeAmount = 0;
    vatAmount = 0;
    netPayable = 0;
    currentPayable = 0;

    merchantCodCharges = 0;
    packagingAmount = 0;
    fragileLiquidAmounts = 0;

    double deliveryChargeAmount =  0;
    double merchantCodCharge    = 0;

    if(deliveryTypID == 'Same Day'){
      deliveryChargeAmount = double.parse(deliveryChargesValue.sameDay.toString());
      merchantCodCharge = double.parse('0.0'/*merchantData.codCharges!.insideCity.toString()*/);
    }else if (deliveryTypID == 'Next Day') {
      deliveryChargeAmount = double.parse(deliveryChargesValue.nextDay.toString());
      merchantCodCharge = double.parse('0.0'/*merchantData.codCharges!.insideCity.toString()*/);

    } else if (deliveryTypID == 'Sub City') {
      deliveryChargeAmount = double.parse(deliveryChargesValue.subCity.toString());
      merchantCodCharge = double.parse('0.0'/*merchantData.codCharges!.subCity.toString()*/);

    }else if (deliveryTypID == 'Outside City') {
      deliveryChargeAmount = double.parse(deliveryChargesValue.outsideCity.toString());
      merchantCodCharge = double.parse('0.0'/*merchantData.codCharges!.outsideCity.toString()*/);

    }else {
      deliveryChargeAmount = 0;
      merchantCodCharge = 0;
    }
    packagingAmount = double.parse(packagingPrice.toString());
    totalCashCollection          =  double.parse("0.0"/*cashCollectionController.text.toString()*/);
    codChargeAmount              =  percentage(totalCashCollection, merchantCodCharge);
    if(isLiquidChecked){
      totalDeliveryChargeAmount    = (deliveryChargeAmount+codChargeAmount+fragileLiquidAmount+packagingAmount);
      fragileLiquidAmounts = fragileLiquidAmount;
    }else {
      totalDeliveryChargeAmount    = (deliveryChargeAmount+codChargeAmount+packagingAmount);
      fragileLiquidAmounts = 0;
    }

    vatAmount                    = percentage(totalDeliveryChargeAmount, vatTax);
    netPayable                   = (totalDeliveryChargeAmount + vatAmount);
    currentPayable               = (totalCashCollection - (totalDeliveryChargeAmount + vatAmount));
    merchantCodCharges           = merchantCodCharge;
    print('packagingAmount==> '+ '${packagingAmount}');
    print('deliveryChargeAmount==> '+ '${deliveryChargeAmount}');
    print('totalDeliveryChargeAmount==> '+ '${totalDeliveryChargeAmount}');
    print('totalCashCollection==> '+ '${totalCashCollection}');
    print('vatAmount==> '+ '${vatAmount}');
    print('codChargeAmount==> '+ '${codChargeAmount}');
    print('netPayable==> '+ '${netPayable}');
    print('currentPayable==> '+ '${currentPayable}');

    showPopUp(context, totalCashCollection,deliveryChargeAmount,codChargeAmount,fragileLiquidAmounts,packagingAmount,totalDeliveryChargeAmount,vatAmount,netPayable,currentPayable,deliveryAddress,dropdownvalue,userID);
    Future.delayed(Duration(milliseconds: 10), () {
      update();
    });
  }

  percentage(totalAmount,percentageAmount) {
    return totalAmount * (percentageAmount / 100);
  }

  void showPopUp(context, totalCashCollectionParcel,deliveryChargeAmountParcel,codChargeAmountParcel,fragileLiquidAmountsParcel,packagingAmountParcel,totalDeliveryChargeAmountParcel,vatAmountParcel,netPayableParcel,currentPayableParcel, deliveryAddress, String dropdownvalue, String userID) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child:  SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'charge_details'.tr,
                        style: kTextStyle.copyWith(
                            color: kSecondaryColor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                      ListTile(
                        title: Text(
                          'title'.tr,
                          style: kTextStyle.copyWith(
                              color: kTitleColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                        trailing: Text(
                          'amount_tk'.tr,
                          style: kTextStyle.copyWith(
                              color: kTitleColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                      ),
                      /*Card(
                    child: ListTile(
                      title: Text(
                        "Cash Collection",
                        style: kTextStyle.copyWith(
                            color: kTitleColor, fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        '${totalCashCollectionParcel.toStringAsFixed(2)}',
                        style: kTextStyle.copyWith(color: kTitleColor),
                      ),
                    ),
                  ),*/
                      Card(
                        child: ListTile(
                          title: Text(
                            'delivery_charges'.tr,
                            style: kTextStyle.copyWith(
                                color: kTitleColor, fontWeight: FontWeight.bold),
                          ),
                          trailing: Text(
                            '${deliveryChargeAmountParcel.toStringAsFixed(2)}',
                            style: kTextStyle.copyWith(color: kTitleColor),
                          ),
                        ),
                      ),
                      /* Card(
                    child: ListTile(
                      title: Text(
                        'cod_charge'.tr,
                        style: kTextStyle.copyWith(
                            color: kTitleColor, fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        '${codChargeAmountParcel.toStringAsFixed(2)}',
                        style: kTextStyle.copyWith(color: kTitleColor),
                      ),
                    ),
                  ),
                 Card(
                    child: ListTile(
                      title: Text(
                        'liquid_fragile_charge'.tr,
                        style: kTextStyle.copyWith(
                            color: kTitleColor, fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        '${fragileLiquidAmountsParcel.toStringAsFixed(2)}',
                        style: kTextStyle.copyWith(color: kTitleColor),
                      ),
                    ),
                  ),*/
                      Card(
                        child: ListTile(
                          title: Text(
                            'p_charge'.tr,
                            style: kTextStyle.copyWith(
                                color: kTitleColor, fontWeight: FontWeight.bold),
                          ),
                          trailing: Text(
                            '${packagingAmountParcel.toStringAsFixed(2)}',
                            style: kTextStyle.copyWith(color: kTitleColor),
                          ),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(
                            'total_charge'.tr,
                            style: kTextStyle.copyWith(
                                color: kTitleColor, fontWeight: FontWeight.bold),
                          ),
                          trailing: Text(
                            '${totalDeliveryChargeAmountParcel.toStringAsFixed(2)}',
                            style: kTextStyle.copyWith(color: kTitleColor),
                          ),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(
                            'vat'.tr,
                            style: kTextStyle.copyWith(
                                color: kTitleColor, fontWeight: FontWeight.bold),
                          ),
                          trailing: Text(
                            '${vatAmountParcel.toStringAsFixed(2)}',
                            style: kTextStyle.copyWith(color: kTitleColor),
                          ),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(
                            'net_payable'.tr,
                            style: kTextStyle.copyWith(
                                color: kTitleColor, fontWeight: FontWeight.bold),
                          ),
                          trailing: Text(
                            '${netPayableParcel.toStringAsFixed(2)}',
                            style: kTextStyle.copyWith(color: kTitleColor),
                          ),
                        ),
                      ),
                      /*Card(
                    child: ListTile(
                      title: Text(
                        'current_payable'.tr,
                        style: kTextStyle.copyWith(
                            color: kTitleColor, fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        '${currentPayableParcel.toStringAsFixed(2)}',
                        style: kTextStyle.copyWith(color: kTitleColor),
                      ),
                    ),
                  ),*/
                      const SizedBox(height: 30.0),
                      ButtonGlobal(buttontext: 'confirm'.tr, buttonDecoration: kButtonDecoration, onPressed: (){
                        FocusScope.of(context).requestFocus(new FocusNode());

                        parcelPost(deliveryAddress,dropdownvalue,userID);
                        Get.back();
                        // Get.off(ParcelPage());
                      })
                    ],
                  )),
            ),
          );
        });
  }

}
