import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:we_courier_merchant_app/utils/image.dart';
import '../../MapAddress/flutter_google_places_web.dart';
import '../../Services/api-list.dart';
import '/Screen/Widgets/button_global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../Controllers/parcel_controller.dart';
import '../../Models/parcel_crate_model.dart';
import '../../utils/size_config.dart';
import '../Widgets/constant.dart';
import '../Widgets/loader.dart';
import 'dart:math';


class CreateParcel extends StatefulWidget {

  CreateParcel({Key? key}) : super(key: key);

  @override
  State<CreateParcel> createState() => _CreateParcelState();

}

class _CreateParcelState extends State<CreateParcel> {
  ParcelController parcelController = Get.put(ParcelController());

  final _formKey = GlobalKey<FormState>();

  String DestignationAddress = "";

  /* List<String> deliveryType = [
    'Same Day',
    'Next Day',
    'Sub City',
    'Outside City',
  ];*/
  String type = 'Same Day';

  var FromAddress;
  var PickupAddress;
  var DeliveryAddress;
  String? ToseepickupLat;
  String? ToseepickupLong;
  String? FromseedeliveryLat;
  String? FromseedeliveryLong;
  String? userID;
  String? Phone;

  double? cToseepickupLat;
  double? cToseepickupLong;


  // Initial Selected Value  for gst dropdown
  String dropdownvalue = 'GST';

  // List of items in our dropdown menu  for gst dropdown
  var items = ['GST', 'SGST', 'No GST',];
  bool _showTextFields = true;
  late double distance;


  int _counter = 1;
  String CategoryID = '';

/*  DropdownButton<String> selectType() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in deliveryType) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      items: dropDownItems,
      value: type,
      onChanged: (value) {
        setState(() {
          type = value!;
          Get.find<ParcelController>().deliveryTypID = type;
        });
      },
    );
  }*/

  @override
  void initState() {
    parcelController.crateParcel();
    super.initState();
  }

  Future<void> getLatLongFromAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    ToseepickupLat = prefs.getString('currentLati');
    ToseepickupLong = prefs.getString('currentLongi');

    FromseedeliveryLat= prefs.getString('fromLati');
    FromseedeliveryLong= prefs.getString('fromLongi');
    userID = prefs.getString('user-id');
    Phone =  prefs.getString("phone");

    print("Current ==> ${ToseepickupLat}, ${ToseepickupLong}");
    print("From ==> ${FromseedeliveryLat}, ${FromseedeliveryLong}");


    Location start = Location(double.parse(ToseepickupLat!), double.parse(ToseepickupLong!)); // Example New York City
    Location end = Location(double.parse(FromseedeliveryLat!), double.parse(FromseedeliveryLong!));

    distance = calculateNewDistance(start, end);
    print('Distance between New York City and Los Angeles: $distance km');

    cToseepickupLat = double.parse(ToseepickupLat!);
    cToseepickupLong = double.parse(ToseepickupLong!);



  }

  double calculateNewDistance(Location start, Location end) {
    const double earthRadius = 6371; // Radius of the earth in kilometers

    // Convert latitude and longitude from degrees to radians
    double startLatRadians = NewdegreesToRadians(start.latitude);
    double endLatRadians = NewdegreesToRadians(end.latitude);
    double deltaLatRadians = NewdegreesToRadians(end.latitude - start.latitude);
    double deltaLonRadians = NewdegreesToRadians(end.longitude - start.longitude);

    // Haversine formula
    double a = sin(deltaLatRadians / 2) * sin(deltaLatRadians / 2) +
        cos(startLatRadians) *
            cos(endLatRadians) *
            sin(deltaLonRadians / 2) *
            sin(deltaLonRadians / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    // Distance in kilometers
    double distance = earthRadius * c;
    return distance;
  }

  double NewdegreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfigCustom sizeConfig = SizeConfigCustom();
    sizeConfig.init(context);
    final Size size = MediaQuery.of(context).size;
    FromAddress = ModalRoute.of(context)!.settings.arguments;
    var parts = FromAddress.split('123');
    PickupAddress = parts[0].trim();
    DeliveryAddress = parts.sublist(1).join(',').trim();

    getLatLongFromAddress();

    return Scaffold(
        backgroundColor: kBgColor,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          titleSpacing: 0,
          backgroundColor: kBgColor,
          elevation: 0.0,
          title: Container(
            padding: EdgeInsets.only(bottom: 10,),
            height: 70,width: 300,
            child: Row(  mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(Images.appLogo, fit: BoxFit.cover),
              ],
            ),
          ),
        ),

        body:  GetBuilder<ParcelController>(
            init: ParcelController(),
            builder: (parcel) =>
                Stack(children: [
                  Center(
                    child:
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 20.0),
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            width: MediaQuery.of(context).size.width,
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
                            child:  Form(
                                key: _formKey,
                                child:
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 5),

                                    //  parcel.shopList.isEmpty?SizedBox():
                                    /*SizedBox(
                                      height: 60.0,
                                      child: FormField(
                                        builder: (FormFieldState<dynamic> field) {
                                          return InputDecorator(
                                              decoration: kInputDecoration.copyWith(
                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                labelText: 'Your name'.tr,
                                                hintText: 'Your name'.tr,
                                                labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(5.0),
                                                ),
                                              ),
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton<Shops>(
                                                  value: parcel.shopIndex.toString() == 'null'
                                                      ? null
                                                      : parcel.shopList[
                                                  parcel.shopIndex],

                                                  items: parcel.shopList
                                                      .map((Shops value) {
                                                    return new DropdownMenuItem<
                                                        Shops>(
                                                      value: value,
                                                      child: Text(value.name.toString()),
                                                    );
                                                  }).toList(),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      parcel.shopIndex = parcel.shopList.indexOf(newValue!);
                                                      parcel.shopID = newValue.id.toString();
                                                      parcel.pickupAddress = PickupAddress*//*newValue.address.toString()*//*;
                                                      parcel.pickupPhone = newValue.contactNo.toString();
                                                      parcel.pickupLate = ToseepickupLat.toString()*//*newValue.merchantLat.toString()*//*;
                                                      parcel.pickupLong = ToseepickupLong.toString()*//*newValue.merchantLong.toString()*//*;
                                                      parcel.merchantID = newValue.merchantId.toString();
                                                    });
                                                  },
                                                ),
                                              )
                                          );
                                        },
                                      ),
                                    ),*/
                                    AppTextField(
                                      onChanged: (value) {
                                        setState(() {
                                          parcel.pickupPhone = parcel.pickupPhoneController.text;
                                        });
                                      },
                                      controller: parcel.pickupPhoneController
                                        ..text = Phone.toString()/*parcel.pickupPhone.toString()*/
                                        ..selection = TextSelection.collapsed(
                                            offset: parcel.pickupPhoneController.text.length),
                                      showCursor: true,

                                      validator: (value) {
                                        if (parcel.pickupPhoneController.text.isEmpty) {
                                          return "this_field_can_t_be_empty".tr;
                                        }
                                        return null;
                                      },
                                      cursorColor: kTitleColor,
                                      textFieldType: TextFieldType.PHONE,
                                      decoration: kInputDecoration.copyWith(
                                        enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                          borderSide: BorderSide(color: kBorderColorTextField, width: 2),),
                                        labelText: 'Your phone'.tr,
                                        labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                        hintText: '017XXXXXXXX',
                                        hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                      ),
                                    ),
                                    const SizedBox(height: 20.0),
                                    AppTextField(
                                      onChanged: (value) {
                                        setState(() {
                                          parcel.pickupAddress = parcel.pickupAddressController.text;
                                        });
                                      },
                                      controller: parcel.pickupAddressController
                                        ..text = PickupAddress/*parcel.pickupAddress.toString()*/
                                        ..selection = TextSelection.collapsed(
                                            offset: parcel.pickupAddressController.text.length),
                                      showCursor: true,

                                      validator: (value) {
                                        if (parcel.pickupAddressController.text.isEmpty) {
                                          return "this_field_can_t_be_empty".tr;
                                        }
                                        return null;
                                      },
                                      cursorColor: kTitleColor,
                                      textFieldType: TextFieldType.NAME,
                                      decoration: kInputDecoration.copyWith(
                                        enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                          borderSide:
                                          BorderSide(color: kBorderColorTextField, width: 2),
                                        ),
                                        labelText: 'pickup_address'.tr,
                                        labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                        hintText: 'pickup_address'.tr,
                                        hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                      ),
                                    ),

                                    /* const SizedBox(height: 20.0),
                  AppTextField(
                    controller: parcel.cashCollectionController,
                    validator: (value) {
                      if (parcel.cashCollectionController.text.isEmpty) {
                        return "this_field_can_t_be_empty".tr;
                      }
                      return null;
                    },
                    cursorColor: kTitleColor,
                    textFieldType: TextFieldType.NAME,
                    decoration: kInputDecoration.copyWith(
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2.0)),
                        borderSide:
                            BorderSide(color: kBorderColorTextField, width: 2),
                      ),
                      labelText: 'cash_collection'.tr,
                      labelStyle: kTextStyle.copyWith(color: kTitleColor),
                      hintText: 'enter_amount'.tr,
                      hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  AppTextField(
                    controller: parcel.sellingPriceController,
                    cursorColor: kTitleColor,
                    textFieldType: TextFieldType.NAME,
                    decoration: kInputDecoration.copyWith(
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2.0)),
                        borderSide:
                            BorderSide(color: kBorderColorTextField, width: 2),
                      ),
                      labelText: 'selling_price'.tr,
                      labelStyle: kTextStyle.copyWith(color: kTitleColor),
                      hintText: 'selling_price_of_parcel'.tr,
                      hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  AppTextField(
                    controller: parcel.invoiceController,
                    cursorColor: kTitleColor,
                    isValidationRequired: false,
                    textFieldType: TextFieldType.NAME,
                    decoration: kInputDecoration.copyWith(
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2.0)),
                        borderSide:
                            BorderSide(color: kBorderColorTextField, width: 2),
                      ),
                      labelText: 'invoice'.tr+'#',
                      labelStyle: kTextStyle.copyWith(color: kTitleColor),
                      hintText: 'enter_invoice_number'.tr,
                      hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                    ),
                  ),*/

                                    const SizedBox(height: 20.0),
                                    parcel.deliveryChargesList.isEmpty?SizedBox():   SizedBox(height: 64.0,
                                      child: FormField(builder: (FormFieldState<dynamic> field) {
                                          return InputDecorator(
                                            decoration: kInputDecoration.copyWith(
                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                              labelText: 'Select category'.tr+'*',
                                              hintText: 'select_category'.tr,
                                              labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(5.0),
                                              ),
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<DeliveryCharges>(
                                                value: parcel.deliveryChargesIndex.toString() == 'null'
                                                    ? null : parcel.deliveryChargesList[parcel.deliveryChargesIndex],

                                                items: parcel.deliveryChargesList.map((DeliveryCharges value) {
                                                  return new DropdownMenuItem<DeliveryCharges>(
                                                    value: value,
                                                    child:/*value.id == 0 ?*/Text('${value.weight.toString()}')

                                                    //  child:value.id == 0 ?Text(value.category.toString()): value.weight == '0'? Text(value.category.toString()): Text(value.category.toString() +' (${value.weight.toString()})'),
                                                  );
                                                }).toList(),
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    parcel.deliveryChargesIndex = parcel.deliveryChargesList.indexOf(newValue!);
                                                    parcel.deliveryChargesID = newValue.id.toString();
                                                    parcel.deliveryChargesValue = newValue;
                                                    CategoryID = parcel.deliveryChargesID.toString();

                                                  });
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    /*  SizedBox(height: 20.0),
                  SizedBox(
                    height: 60.0,
                    child: FormField(
                      builder: (FormFieldState<dynamic> field) {
                        return InputDecorator(
                          decoration: kInputDecoration.copyWith(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Delivery in'.tr+'*',
                            hintText: 'Delivery in'.tr,
                            labelStyle: kTextStyle.copyWith(color: kTitleColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: selectType(),
                          ),
                        );
                      },
                    ),
                  ),*/

                                    const SizedBox(height: 10.0),

                                    Text('Quantity'.tr,
                                      style: kTextStyle.copyWith(
                                          color: kTitleColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),

                                    const SizedBox(height: 10.0),

                                    Container(width: 400,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: Colors.white,
                                            border: Border.all(color: Colors.black12)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            FloatingActionButton(
                                              elevation: 0.0,
                                              backgroundColor: Colors.white,
                                              onPressed: _decrementCounter,
                                              tooltip: 'Decrement',
                                              child: Icon(Icons.remove),
                                            ),
                                            const SizedBox(width: 120.0),

                                            Text(/*'$_counter',*/ '${max(0, _counter)/*_counter < 0 ? 0 : _counter*/}',
                                              style:kTextStyle.copyWith(
                                                color: kTitleColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.0),
                                            ),
                                            const SizedBox(width:120.0),

                                            FloatingActionButton(
                                              elevation: 0.0,
                                              backgroundColor: Colors.white,
                                              onPressed: _incrementCounter,
                                              tooltip: 'Increment',
                                              child: Icon(Icons.add),
                                            ),
                                          ],
                                        ),
                                    ),

                                    const SizedBox(height: 15.0),

                                    Container(height: 60,width: 400,
                                      padding: EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.white,
                                          border: Border.all(color: Colors.black12)),
                                      child: new DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          value: dropdownvalue,
                                          icon: const Icon(Icons.keyboard_arrow_down),
                                          items: items.map((String items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              dropdownvalue = newValue!;
                                              if(dropdownvalue =='GST' || dropdownvalue =='SGST'){
                                                _showTextFields = true/*!_showTextFields*/;
                                              }else if(dropdownvalue =='No GST'){
                                                _showTextFields = false;
                                                print("DropDownValue ==> ${dropdownvalue}");
                                              }

                                            });
                                          },
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 10.0),
                                    if (_showTextFields)
                                      TextFormField(
                                        controller: parcel.gstController,
                                        cursorColor: kTitleColor,
                                        keyboardType: TextInputType.text,
                                        decoration: kInputDecoration.copyWith(
                                          isDense: true,
                                          enabledBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                            borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                                          ),
                                          labelText: 'Enter GST Number'.tr+'*',
                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                          hintText: 'GST12345'.tr,
                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                        ),
                                      ),

                                    const SizedBox(height: 10.0),

                                    AppTextField(
                                      controller: parcel.customerController,
                                      validator: (value) {
                                        if (parcel.customerController.text.isEmpty) {
                                          return "this_field_can_t_be_empty".tr;
                                        }
                                        return null;
                                      },
                                      cursorColor: kTitleColor,
                                      textFieldType: TextFieldType.NAME,
                                      decoration: kInputDecoration.copyWith(
                                        enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                          borderSide:
                                          BorderSide(color: kBorderColorTextField, width: 2),
                                        ),
                                        labelText: 'Recipient name'.tr+'*',
                                        labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                        hintText: 'Recipient name'.tr,
                                        hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                      ),
                                    ),
                                    const SizedBox(height: 20.0),
                                    AppTextField(
                                      controller: parcel.customerPhoneController,
                                      validator: (value) {
                                        if (parcel.customerPhoneController.text.isEmpty) {
                                          return "this_field_can_t_be_empty".tr;
                                        }
                                        return null;
                                      },
                                      cursorColor: kTitleColor,
                                      textFieldType: TextFieldType.PHONE,
                                      decoration: kInputDecoration.copyWith(
                                        enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                          borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                                        ),
                                        labelText: 'Recipient phone'.tr+'*',
                                        labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                        hintText: 'Recipient phone'.tr,
                                        hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                      ),
                                    ),
                                    const SizedBox(height: 20.0),
                                    TextFormField(
                                      controller:TextEditingController()..text = DeliveryAddress /*parcel.noteController*/,
                                      cursorColor: kTitleColor,
                                      textAlign: TextAlign.start,
                                      decoration: kInputDecoration.copyWith(
                                        labelText: 'Delivery Address'.tr,
                                        hintText: 'Delivery Address'.tr,
                                        labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                        contentPadding: const EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 10.0),
                                      ),
                                    ),

                                    const SizedBox(height: 20.0),
                                    TextFormField(
                                      controller:parcel.fulladdressController,
                                      cursorColor: kTitleColor,
                                      textAlign: TextAlign.start,
                                      decoration: kInputDecoration.copyWith(
                                        labelText: 'Full Address'.tr,
                                        hintText: 'full address'.tr,
                                        labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                        contentPadding: const EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 10.0),
                                      ),
                                    ),
                                    const SizedBox(height: 20.0),
                                    TextFormField(
                                      controller:parcel.pincodeController,
                                      cursorColor: kTitleColor,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.start,
                                      decoration: kInputDecoration.copyWith(
                                        labelText: 'Pin Code'.tr,
                                        hintText: 'pin code'.tr,
                                        labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                        contentPadding: const EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 10.0),
                                      ),
                                    ), const SizedBox(height: 20.0),
                                    TextFormField(
                                      controller: parcel.noteController,
                                      cursorColor: kTitleColor,
                                      textAlign: TextAlign.start,
                                      decoration: kInputDecoration.copyWith(
                                        labelText: 'note'.tr,
                                        labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                        contentPadding: const EdgeInsets.symmetric(
                                            vertical: 30, horizontal: 10.0),
                                      ),
                                    ),
                                    const SizedBox(height: 20.0),
                                    Text(
                                      'choose_which_needed_for_parcel'.tr,
                                      style: kTextStyle.copyWith(
                                          color: kTitleColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),

                                    const SizedBox(height: 20.0),
                                    parcel.packagingList.isEmpty?SizedBox():  SizedBox(
                                      height: 64.0,
                                      child: FormField(
                                        builder: (FormFieldState<dynamic> field) {
                                          return InputDecorator(
                                            decoration: kInputDecoration.copyWith(
                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                              labelText: 'packaging'.tr,
                                              hintText: 'select_packaging'.tr,
                                              labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(5.0),
                                              ),
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child:
                                              DropdownButton<Packagings>(
                                                value: parcel.packagingIndex.toString() == 'null'
                                                    ? null
                                                    : parcel.packagingList[
                                                parcel.packagingIndex],

                                                items: parcel.packagingList
                                                    .map((Packagings value) {
                                                  return new DropdownMenuItem<
                                                      Packagings>(
                                                    value: value,
                                                    child:value.id == 0 ?Text(value.name.toString()): Text(value.name.toString() +' (${value.price.toString()})'),
                                                  );
                                                }).toList(),
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    parcel.packagingIndex = parcel.packagingList.indexOf(newValue!);
                                                    parcel.packagingID = newValue.id.toString();
                                                    parcel.packagingPrice = newValue.price.toString();
                                                    print("Price ==> ${parcel.packagingPrice}");

                                                    var  _packagingPrice = parcel.packagingPrice.toString();
                                                    parcelController.getDistanceCharges(CategoryID,distance,dropdownvalue,_counter,DeliveryAddress,_packagingPrice );



                                                  });
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 20.0),

                                    ButtonGlobal(
                                        buttontext: 'submit'.tr,
                                        buttonDecoration: kButtonDecoration,
                                        onPressed: () {
                                          setState(() {
                                            FocusScope.of(context).requestFocus(new FocusNode());
                                            if (_formKey.currentState!.validate()) {
                                              if(parcel.deliveryChargesID != ''/* && parcel.deliveryTypID != ''*/){
                                                /* parcel.customerAddressController.text = FlutterGooglePlacesWeb.value['name']??''*/;
                                                parcel.customerAddressLatController.text  = FromseedeliveryLat!/*FlutterGooglePlacesWeb.value['lat']??''*/;
                                                parcel.customerAddressLongController.text= FromseedeliveryLong!/*FlutterGooglePlacesWeb.value['long']??''*/;

                                                parcel.calculateTotal(context,PickupAddress,DeliveryAddress,dropdownvalue,userID!,distance,_counter,FromseedeliveryLat,FromseedeliveryLong
                                                );
                                              }else if(parcel.deliveryChargesID == ''){
                                                Get.rawSnackbar(
                                                    message: "Please select category",
                                                    backgroundColor: Colors.red,
                                                    snackPosition: SnackPosition.TOP);
                                              }
                                              /*else if(parcel.deliveryTypID == ''){
                            Get.rawSnackbar(
                                message: "Please select delivery type",
                                backgroundColor: Colors.red,
                                snackPosition: SnackPosition.TOP);
                          }*/else {
                                                Get.rawSnackbar(
                                                    message: "Please check information",
                                                    backgroundColor: Colors.red,
                                                    snackPosition: SnackPosition.TOP);
                                              }
                                            }
                                          });
                                        })
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  parcel.loaderParcel
                      ? Positioned(
                    child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white60,
                        child: const Center(child: LoaderCircle())),
                  )
                      : const SizedBox.shrink(),
                ])
        ));
  }

}

class Location {
  final double latitude;
  final double longitude;

  Location(this.latitude, this.longitude);

}
