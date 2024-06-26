import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Parcel/create_parcel.dart';
import '../Parcel/parcel_all_staus.dart';
import '../Payment/AccTransaction/acc_transaction.dart';
import '../Payment/PaymentRequest/invoice_list.dart';
import '../Payment/PaymentRequest/payment_request.dart';
import '../Payment/Statement/date_to_date_statement.dart';
import '../Payment/balance_details.dart';
import '../Payment/payment_acc.dart';
import '../Support/support.dart';
import '../Widgets/button_global.dart';
import '/Controllers/dashboard_controller.dart';
import '/Screen/Frauds/frauds.dart';
import '/Screen/Home/home.dart';
import '/Screen/Parcel/parcel_index.dart';
import '/Screen/Shops/shops.dart';
import '/Screen/delivery_charges.dart';
import '/utils/image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';

import '../../Controllers/global-controller.dart';
import '../../Controllers/language_controller.dart';
import '../../Models/language_model.dart';
import '../../utils/style.dart';
import '../Widgets/constant.dart';
import '../Widgets/shimmer/dashboard_shimmer.dart';
import '../cod_charges.dart';
import 'dart:math';


class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  LanguageController languageController = Get.put(LanguageController());
  final box = GetStorage();
  Language? selectedLang;
  List<String> reportList = [
    'total_parcel'.tr,
    'total_delivered'.tr,
    'total_return'.tr,
    'total_transit'.tr,
  ];

  final iconList = <IconData>[
    FontAwesomeIcons.boxOpen,
    MdiIcons.truckFast,
    FontAwesomeIcons.dna,
    FontAwesomeIcons.dolly,
  ];

  List<Color> colorList = [
    const Color(0xFFEFFBF8),
    const Color(0xFFFDF9EE),
    const Color(0xFFFBEBF1),
    const Color(0xFFEFF5FA),
  ];
  List<String> imageList = [
    Images.banner1,
    Images.banner2,
    Images.banner3,
  ];

  DashboardController dashboardController = DashboardController();
  GlobalController globalController = GlobalController();

  String googleApikey = "AIzaSyBc9NWl1xW1re3YptnoWklDPvbNvixWQ2E";

  // GoogleMapController? mapController; //contrller for Google map
  CameraPosition? cameraPosition;
  String locationAddress ='';
  String googleApikey_2 = "AIzaSyA59LKmwVl-gP4U58kSKFTdu89I72bC1hM";
  GoogleMapController? mapController_2; //contrller for Google map
  CameraPosition? cameraPosition_2;
  late LatLng startLocation_2;

  String fromlocation = "search designation";
  late LatLng startLocation;

  var Current_Latitude;
  var Current_Longitude;

  GoogleMapController? mapController;

  var fromlocationdata ;
  double? lat;
  double? long;


@override
  void initState() {
  FirebaseMessaging.instance
      .getInitialMessage()
      .then((RemoteMessage? message) {});

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    Get.rawSnackbar(
      snackPosition: SnackPosition.TOP,
      title: message.notification?.title,
      message: message.notification?.body,
      backgroundColor: kMainColor.withOpacity(.9),
      maxWidth: ScreenSize(context).mainWidth / 1.007,
      margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
    );
  });
  // TODO: implement initState
    super.initState();
  }

  getStackFlowLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(lat, long);

    setState(() {
      LatLng _currentPosition = location;
      if(_currentPosition!=null){
        setup(_currentPosition);

      }
    });
  }

  void setup(LatLng? currentPosition) {
    lat = currentPosition?.latitude;
    long = currentPosition?.longitude;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      LocationPermission ask = await Geolocator.requestPermission();
    } else {
      Position currentposition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      startLocation = LatLng(currentposition.latitude as double, currentposition.longitude as double);
      startLocation_2 = LatLng(currentposition.latitude as double, currentposition.longitude as double);
      Current_Latitude = currentposition.latitude.toString();
      Current_Longitude = currentposition.longitude.toString();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('currentLati', Current_Latitude);
      prefs.setString('currentLongi', Current_Longitude);
     // print("Currect ==> ${Current_Latitude+","+Current_Longitude}");


      //----------get Address-------------------------

      List<Placemark> newPlace = await placemarkFromCoordinates(currentposition!.latitude, currentposition!.longitude);
      Placemark placeMark = newPlace[0];
      String? name = placeMark.name;
      String? subLocality = placeMark.subLocality;
      String? locality = placeMark.locality;
      String? administrativeArea = placeMark.administrativeArea;
      String? postalCode = placeMark.postalCode;
      String? country = placeMark.country;
      locationAddress = "${name}, ${subLocality}, ${locality}, ${administrativeArea} ${postalCode}, ${country}";


    }
  }
  @override
  Widget build(BuildContext context) {
  Future.delayed(const Duration(milliseconds: 500), () {
    setState(() {
    getLocation();
  //  checkDistance();
    });
    });

    selectedLang = languageController.languageList[languageController.languageList.indexWhere((i) => i.locale == Get.locale)];

    return Scaffold(backgroundColor: kBgColor,
      drawer: Drawer(
        backgroundColor: kBgColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50.0),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: kMainColor,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CachedNetworkImage(
                        imageUrl:Get.find<GlobalController>().userImage ==null?'assets/images/profile.png':Get.find<GlobalController>().userImage.toString(),
                        imageBuilder: (context, imageProvider) =>
                            CircleAvatar(
                              radius: 25.0,
                              backgroundImage: imageProvider,
                              backgroundColor: Colors.transparent,
                            ),
                        placeholder: (context, url) => Shimmer.fromColors(
                          child: CircleAvatar(radius: 25.0),
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[400]!,
                        ),
                        errorWidget: (context, url, error) =>
                            Icon(CupertinoIcons.person,size: 30,),
                      ),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(Get.find<GlobalController>().userName != null) Text(
                            Get.find<GlobalController>().userName.toString(),
                            style: kTextStyle.copyWith(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          if(Get.find<GlobalController>().userEmail != null)Text(
                            Get.find<GlobalController>().userEmail.toString(),
                            style: kTextStyle.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15,),

                ListTile(
                  onTap: (() => const Home().launch(context)),
                  contentPadding: EdgeInsets.zero,
                  horizontalTitleGap: 0,
                  leading: const Icon(
                    FontAwesomeIcons.house,
                    color: kTitleColor,
                    size: 18.0,
                  ),
                  title: Text(
                    'dashboard'.tr,
                    style: kTextStyle.copyWith(
                        color: kTitleColor, fontWeight: FontWeight.bold),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,),
                    child: const Icon(FeatherIcons.chevronRight,
                        color: kTitleColor, size: 18),
                  ),
                ),


              /*  ListTile(
                  contentPadding: EdgeInsets.zero,
                  horizontalTitleGap: 0,
                  leading: const Icon(
                    FontAwesomeIcons.users,
                    color: kTitleColor,
                    size: 18.0,
                  ),
                  onTap: (() => const ShopsPage().launch(context)),
                  title: Text(
                    'shop'.tr,
                    style: kTextStyle.copyWith(
                        color: kTitleColor, fontWeight: FontWeight.bold),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,),
                    child: const Icon(FeatherIcons.chevronRight,
                        color: kTitleColor, size: 18),
                  ),
                ),

                ListTileTheme(
                  iconColor: kTitleColor,
                  contentPadding: const EdgeInsets.all(0),
                  dense: true,
                  horizontalTitleGap: 30,
                  minLeadingWidth: 0,
                  child: ExpansionTile(
                    leading: const Icon(FontAwesomeIcons.solidFileLines,
                        size: 14.0, color: kTitleColor),
                    title: Text(
                      'parcels'.tr,
                      style: kTextStyle.copyWith(
                          color: kTitleColor, fontWeight: FontWeight.bold),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(FeatherIcons.chevronDown,
                          color: kTitleColor, size: 18),
                    ),
                    children: [
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(left:20.0),
                          child: Text(
                            'parcels'.tr,
                            style: kTextStyle.copyWith(color: kGreyTextColor,fontWeight: FontWeight.w600),
                          ),
                        ),
                        onTap: (() =>  ParcelPage(height: 0.85,).launch(context)),
                      ),
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(left:20.0),
                          child: Text(
                            'Parcel Categories'.tr,
                            style: kTextStyle.copyWith(color: kGreyTextColor,fontWeight: FontWeight.w600),
                          ),
                        ),
                        onTap: (() => const ParcelAllStatus().launch(context)),
                      ),
                    ],
                  ),
                ),

                ListTile(
                  onTap: (() => const Frauds().launch(context)),
                  contentPadding: EdgeInsets.zero,
                  horizontalTitleGap: 0,
                  leading: const Icon(
                    FontAwesomeIcons.boxArchive,
                    color: kTitleColor,
                    size: 18.0,
                  ),
                  title: Text(
                    'fraud_check'.tr,
                    style: kTextStyle.copyWith(
                        color: kTitleColor, fontWeight: FontWeight.bold),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,),
                    child: const Icon(FeatherIcons.chevronRight,
                        color: kTitleColor, size: 18),
                  ),
                ),
                ListTile(
                  onTap: (() => const Support().launch(context)),
                  contentPadding: EdgeInsets.zero,
                  horizontalTitleGap: 0,
                  leading: const Icon(
                    FontAwesomeIcons.paperPlane,
                    color: kTitleColor,
                    size: 18.0,
                  ),
                  title: Text(
                    'support'.tr,
                    style: kTextStyle.copyWith(
                        color: kTitleColor, fontWeight: FontWeight.bold),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,),
                    child: const Icon(FeatherIcons.chevronRight,
                        color: kTitleColor, size: 18),
                  ),
                ),
                ListTileTheme(
                    iconColor: kTitleColor,
                    contentPadding: const EdgeInsets.all(0),
                    dense: true,
                    horizontalTitleGap: 30,
                    minLeadingWidth: 0,
                    child: ExpansionTile(
                      leading: const Icon(FontAwesomeIcons.users,
                          size: 14.0, color: kTitleColor),
                      title: Text(
                        'Payments'.tr,
                        style: kTextStyle.copyWith(
                            color: kTitleColor, fontWeight: FontWeight.bold),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(FeatherIcons.chevronDown,
                            color: kTitleColor, size: 18),
                      ),
                      children: [
                        ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(left:20.0),
                            child: Text(
                              'payment_account'.tr,
                              style: kTextStyle.copyWith(color: kGreyTextColor,fontWeight: FontWeight.w600),
                            ),
                          ),
                          onTap: (() => const PaymentAcc().launch(context)),
                        ),
                        ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(left:20.0),
                            child: Text(
                              'payment_request'.tr,
                              style: kTextStyle.copyWith(color: kGreyTextColor,fontWeight: FontWeight.w600),
                            ),
                          ),
                          onTap: (() => const PaymentReq().launch(context)),
                        ),
                        ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(left:20.0),
                            child: Text(
                              'Payments/Invoices'.tr,
                              style: kTextStyle.copyWith(color: kGreyTextColor,fontWeight: FontWeight.w600),
                            ),
                          ),
                          onTap: (() => const InvoiceList().launch(context)),
                        ),
                      ],
                    )),

                ListTileTheme(
                  iconColor: kTitleColor,
                  contentPadding: const EdgeInsets.all(0),
                  dense: true,
                  horizontalTitleGap: 30,
                  minLeadingWidth: 0,
                  child: ExpansionTile(
                    leading: const Icon(FontAwesomeIcons.solidFileLines,
                        size: 14.0, color: kTitleColor),
                    title: Text(
                      'reports'.tr,
                      style: kTextStyle.copyWith(
                          color: kTitleColor, fontWeight: FontWeight.bold),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(FeatherIcons.chevronDown,
                          color: kTitleColor, size: 18),
                    ),
                    children: [
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(left:20.0),
                          child: Text(
                            'account_transaction'.tr,
                            style: kTextStyle.copyWith(color: kGreyTextColor,fontWeight: FontWeight.w600),
                          ),
                        ),
                        onTap: (() => const AccTransaction().launch(context)),
                      ),
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(left:20.0),
                          child: Text(
                            'statements'.tr,
                            style: kTextStyle.copyWith(color: kGreyTextColor,fontWeight: FontWeight.w600),
                          ),
                        ),
                        onTap: (() => const DateToDateStatement().launch(context)),
                      ),
                    ],
                  ),
                ),
                ListTileTheme(
                    iconColor: kTitleColor,
                    contentPadding: const EdgeInsets.all(0),
                    dense: true,
                    horizontalTitleGap: 30,
                    minLeadingWidth: 0,
                    child: ExpansionTile(
                      leading: const Icon(FontAwesomeIcons.gears,
                          size: 14.0, color: kTitleColor),
                      title: Text(
                        'setting'.tr,
                        style: kTextStyle.copyWith(
                            color: kTitleColor, fontWeight: FontWeight.bold),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(FeatherIcons.chevronDown,
                            color: kTitleColor, size: 18),
                      ),
                      children: [
                        ListTile(
                          onTap: (() => const CodChargeList().launch(context)),
                          title: Text(
                            'cod_charges'.tr,
                            style: kTextStyle.copyWith(color: kGreyTextColor),
                          ),
                        ),
                        ListTile(
                          onTap: (() => const DeliveryChargeList().launch(context)),
                          title: Text(
                            'delivery_charges'.tr,
                            style: kTextStyle.copyWith(color: kGreyTextColor),
                          ),
                        ),

                      ],
                    )),*/

                ListTile(
                  onTap: () => {
                    Get.find<GlobalController>().userLogout(),
                    Navigator.of(context).pop()
                  },
                  contentPadding: EdgeInsets.zero,
                  horizontalTitleGap: 0,
                  leading: const Icon(
                    Icons.exit_to_app,
                    color: kTitleColor,
                    size: 18.0,
                  ),
                  title: Text(
                    'log_out'.tr,
                    style: kTextStyle.copyWith(
                        color: kTitleColor, fontWeight: FontWeight.bold),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,),
                    child: const Icon(FeatherIcons.chevronRight,
                        color: kTitleColor, size: 18),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),

      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        titleSpacing: 0,
        elevation: 0.0,
        title: Container(
          padding: EdgeInsets.only(bottom: 5,),
          height: 70,width: 275,
          child: Row(  mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(Images.appLogo, fit: BoxFit.fill),
            ],
          ),
        ),
      ),

      body:  GetBuilder<DashboardController>(
          init: DashboardController(),
          builder: (dashboard) =>
              SingleChildScrollView(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10.0),
                    dashboard.dashboardLoader
                        ? DashboardShimmer()
                        : Container(
                      padding: const EdgeInsets.all(10.0),
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
                      child: SingleChildScrollView(
                        controller: ScrollController(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //search autoconplete input
                           Container(
                                child: InkWell(
                                    onTap: () async {
                                      var place = await PlacesAutocomplete.show(
                                          context: context,
                                          apiKey: googleApikey,
                                          mode: Mode.overlay,
                                          logo: Text(""),
                                          types: [],
                                          radius: 10000000,
                                          strictbounds: false,
                                          components: [Component(Component.country, 'IN')],
                                          //google_map_webservice package
                                          onError: (err) {
                                            print(err);
                                          });

                                      if (place != null) {
                                        setState((){
                                          locationAddress = place.description.toString();
                                          print("Locationobject ==> ${locationAddress}");
                                        });

                                        //form google_maps_webservice package
                                        final plist = GoogleMapsPlaces(
                                          apiKey: googleApikey,
                                          apiHeaders: await GoogleApiHeaders().getHeaders(),
                                          //from google_api_headers package
                                        );
                                        String placeid = place.placeId ?? "0";
                                        final detail = await plist.getDetailsByPlaceId(placeid);
                                        final geometry = detail.result.geometry!;
                                        final lat = geometry.location.lat;
                                        final lang = geometry.location.lng;

                                        var newlatlang = LatLng(lat, lang);

                                        //move map camera to selected place with animation
                                        mapController?.animateCamera(CameraUpdate.newCameraPosition(
                                        CameraPosition(target: newlatlang, zoom: 17)));
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Card(
                                        child: Container(
                                            padding: EdgeInsets.all(0),
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width -
                                                30,
                                            child: ListTile(
                                              title: Text(
                                                locationAddress.toString(),
                                                overflow:
                                                TextOverflow.ellipsis,
                                                style:
                                                TextStyle(fontSize: 14),
                                              ),
                                              trailing: Icon(Icons.search),
                                              dense: true,
                                            )),
                                      ),
                                    ))),

                            const SizedBox(height: 5),

                            //search autoconplete input

                            Container(
                                child: InkWell(
                                    onTap: () async {
                                      var place = await PlacesAutocomplete.show(
                                          context: context,
                                          apiKey: googleApikey_2,
                                          mode: Mode.overlay,
                                          logo: Text(""),
                                          types: [],
                                          strictbounds: false,
                                          components: [
                                            Component(Component.country, 'IN')
                                          ],
                                          //google_map_webservice package
                                          onError: (err) {
                                            print(err);
                                          });

                                      if (place != null) {
                                        setState(() {
                                          fromlocation =place.description.toString();
                                          log("fromlocation ==> ${fromlocation.toString()}");
                                        });

                                        //form google_maps_webservice package
                                        final plist = GoogleMapsPlaces(
                                          apiKey: googleApikey_2,
                                          apiHeaders: await GoogleApiHeaders().getHeaders(),
                                          //from google_api_headers package
                                        );
                                        String placeid = place.placeId ?? "0";
                                        final detail = await plist.getDetailsByPlaceId(placeid);
                                        final geometry =
                                        detail.result.geometry!;
                                        final lat = geometry.location.lat;
                                        final lang = geometry.location.lng;

                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        prefs.setString('fromLati', lat.toString());
                                        prefs.setString('fromLongi', lang.toString());
                                        print("Target ==> ${lat.toString()+","+lang.toString()}");


                                        var newlatlang = LatLng(lat, lang);

                                        //move map camera to selected place with animation
                                        mapController_2?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 17)));
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Card(
                                        child: Container(
                                            padding: EdgeInsets.all(0),
                                            width: MediaQuery.of(context).size.width - 30,
                                            child: ListTile(
                                              title: Text(fromlocation, overflow:
                                              TextOverflow.ellipsis, style: TextStyle(fontSize: 14),

                                              ),
                                              //  subtitle: Text(fromlocation),
                                              trailing: Icon(Icons.search),
                                              dense: true,
                                            )),
                                      ),
                                    ))),

                            const SizedBox(height: 10),

                            Container(height: 30, width: 150,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left: 120),
                              child: ElevatedButton(
                                onPressed: () {
                                  if(fromlocation =='search designation'){
                                    Get.rawSnackbar(message: "Enter Valid location address", backgroundColor: Colors.red, snackPosition: SnackPosition.BOTTOM);
                                  }else{
                                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  CreateParcel(),
                                      settings: RouteSettings(arguments: locationAddress.toString()+"123"+fromlocation,
                                      ),
                                    ),
                                    );
                                  }
                                },

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  elevation: 2,
                                ),
                                child: const Text(
                                  'Create Parcel',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            CarouselSlider.builder(
                              options: CarouselOptions(
                                height: 200,
                                aspectRatio: 16 / 9,
                                viewportFraction: 0.8,
                                initialPage: 0,
                                enableInfiniteScroll: true,
                                reverse: false,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 3),
                                autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enlargeCenterPage: true,
                                onPageChanged: null,
                                scrollDirection: Axis.horizontal,
                              ),
                              // itemCount: imageList.length,
                              itemCount:  dashboard.offersList.isNotEmpty?dashboard.offersList.length:imageList.length,
                              itemBuilder: (BuildContext context, int index, int realIndex) {
                                return dashboard.offersList.isNotEmpty?
                                  CachedNetworkImage(
                                        imageUrl:dashboard.offersList[index].image.toString(),
                                        imageBuilder: (context, imageProvider) =>
                                            Container(
                                              height: 150,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image:imageProvider
                                                  ),
                                              )),
                                            placeholder: (context, url) => Shimmer.fromColors(
                                             child: CircleAvatar(radius: 50.0),
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[400]!,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(CupertinoIcons.person,size: 50,),
                                      )
                                    :Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        imageList[index],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),


                            const SizedBox(height: 20),
                            Text(
                              'Business Dashboard'.tr,
                              style: kTextStyle.copyWith(
                                  color: kTitleColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                            const SizedBox(height: 10),
                            GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              childAspectRatio: 1,
                              mainAxisSpacing: 10.0,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: List.generate(4, (i) {
                                  return Card(
                                      color: colorList[i],
                                      elevation: 10,
                                      shadowColor: kMainColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const SizedBox(height: 20),
                                            Icon(
                                              iconList[i],
                                              size: 40,
                                              color: kTitleColor,
                                            ),
                                            const SizedBox(height: 10.0),
                                            Text(reportList[i],
                                              style: kTextStyle.copyWith(
                                                  color: kTitleColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 10.0),
                                            Text(
                                              i == 0? dashboard.dashboardData.tParcel.toString(): i==1?dashboard.dashboardData.tDelivered.toString():i==2?dashboard.dashboardData.tReturn.toString():i==3? "${dashboard.dashboardData.tParcel! - (dashboard.dashboardData.tDelivered! + dashboard.dashboardData.tReturn!)}" :'0',
                                              style: kTextStyle.copyWith(
                                                  color: kTitleColor,
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            /*   Card(
                              elevation: 10,
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: Colors.white),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: kGreyTextColor.withOpacity(0.2),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'total_cash_collection'.tr,
                                                style: kTextStyle.copyWith(
                                                    color: kTitleColor),
                                              ),
                                              const Spacer(),
                                              Text(
                                                '${Get.find<GlobalController>()
                                                    .currency!} ${dashboard.dashboardData.tCashCollection.toString()}',
                                                style: kTextStyle.copyWith(
                                                    color: kTitleColor),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'total_selling_price'.tr,
                                                style: kTextStyle.copyWith(
                                                    color: kTitleColor),
                                              ),
                                              const Spacer(),
                                              Text(
                                                '${Get.find<GlobalController>()
                                                    .currency!} ${dashboard.dashboardData.tSellingPrice.toString()}',
                                                style: kTextStyle.copyWith(
                                                    color: kTitleColor),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'net_profit_amount'.tr,
                                                style: kTextStyle.copyWith(
                                                    color: kTitleColor),
                                              ),
                                              const Spacer(),
                                              Text(
                                                "${Get.find<GlobalController>()
                                                    .currency!} ${dashboard.dashboardData.tCashCollection! - dashboard.dashboardData.tSellingPrice!}",
                                                style: kTextStyle.copyWith(
                                                    color: kTitleColor),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: kGreyTextColor.withOpacity(0.2),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'total_liquid_fragile_amount'.tr,
                                                style: kTextStyle.copyWith(
                                                    color: kTitleColor),
                                              ),
                                              const Spacer(),
                                              Text(
                                                "${Get.find<GlobalController>()
                                                    .currency!} ${dashboard.dashboardData.tLiquidFragile.toString()}",
                                                style: kTextStyle.copyWith(
                                                    color: kTitleColor),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'total_packing_amount'.tr,
                                                style: kTextStyle.copyWith(
                                                    color: kTitleColor),
                                              ),
                                              const Spacer(),
                                              Text(
                                               "${Get.find<GlobalController>()
                                                   .currency!} ${dashboard.dashboardData.tPackaging.toString()}",
                                                style: kTextStyle.copyWith(
                                                    color: kTitleColor),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'total_vat_amount'.tr,
                                                style: kTextStyle.copyWith(
                                                    color: kTitleColor),
                                              ),
                                              const Spacer(),
                                              Text(
                                                '${Get.find<GlobalController>()
                                                    .currency!} ${dashboard.dashboardData.tVatAmount.toString()}',
                                                style: kTextStyle.copyWith(
                                                    color: kTitleColor),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'total_delivery_charge'.tr,
                                                style: kTextStyle.copyWith(
                                                    color: kTitleColor),
                                              ),
                                              const Spacer(),
                                              Text(
                                                '${Get.find<GlobalController>()
                                                    .currency!} ${dashboard.dashboardData.tDeliveryCharge.toString()}',
                                                style: kTextStyle.copyWith(
                                                    color: kTitleColor),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'total_cod_amount'.tr,
                                                style: kTextStyle.copyWith(
                                                    color: kTitleColor),
                                              ),
                                              const Spacer(),
                                              Text(
                                                '${Get.find<GlobalController>()
                                                    .currency!} ${dashboard.dashboardData.tCodAmount.toString()}',
                                                style: kTextStyle.copyWith(
                                                    color: kTitleColor),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: kGreyTextColor.withOpacity(0.2),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'total_delivery_amount'.tr,
                                                style: kTextStyle.copyWith(
                                                    color: kTitleColor),
                                              ),
                                              const Spacer(),
                                              Text(
                                                '${Get.find<GlobalController>()
                                                    .currency!} ${dashboard.dashboardData.tDeliveryAmount.toString()}',
                                                style: kTextStyle.copyWith(
                                                    color: kTitleColor),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'total_current_payable_amount'.tr,
                                                style: kTextStyle.copyWith(
                                                    color: kTitleColor),
                                              ),
                                              const Spacer(),
                                              Text(
                                                '${Get.find<GlobalController>()
                                                    .currency!} ${dashboard.dashboardData.tCurrentPayable.toString()}',
                                                style: kTextStyle.copyWith(
                                                    color: kTitleColor),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                         Text(
                              'all_reports'.tr,
                              style: kTextStyle.copyWith(
                                  color: kGreyTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const Icon(
                                    FontAwesomeIcons.handHoldingDollar,
                                    color: kTitleColor,
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'total_sales_amount'.tr,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                      const SizedBox(height: 5.0),
                                      Text(
                                        '${Get.find<GlobalController>()
                                            .currency!} ${dashboard.dashboardData.tSale.toString()}',
                                        style: kTextStyle.copyWith(
                                            color: kTitleColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const Icon(
                                    FontAwesomeIcons.handshakeAngle,
                                    color: kTitleColor,
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'total_delivery_fees_paid'.tr,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                      const SizedBox(height: 5.0),
                                      Text(
                                        '${Get.find<GlobalController>()
                                            .currency!} ${dashboard.dashboardData.tDeliveryFee.toString()}',
                                        style: kTextStyle.copyWith(
                                            color: kTitleColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const Icon(
                                    FontAwesomeIcons.coins,
                                    color: kTitleColor,
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'net_profit_amount'.tr,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                      const SizedBox(height: 5.0),
                                      Text(
                                        "${Get.find<GlobalController>()
                                            .currency!} ${double.parse(dashboard.dashboardData.tSale.toString()) - double.parse(dashboard.dashboardData.tDeliveryFee.toString())}",
                                        style: kTextStyle.copyWith(
                                            color: kTitleColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const Icon(
                                    FontAwesomeIcons.creditCard,
                                    color: kTitleColor,
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'current_balance'.tr,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                      const SizedBox(height: 5.0),
                                      Text(
                                        '${Get.find<GlobalController>()
                                            .currency!} ${dashboard.dashboardData.merchant!.currentBalance.toString()}',
                                        style: kTextStyle.copyWith(
                                            color: kTitleColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const Icon(
                                    FontAwesomeIcons.circleDollarToSlot,
                                    color: kTitleColor,
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'opening_balance'.tr,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                      const SizedBox(height: 5.0),
                                      Text(
                                        '${Get.find<GlobalController>()
                                            .currency!} ${dashboard.dashboardData.merchant!.openingBalance.toString()}',
                                        style: kTextStyle.copyWith(
                                            color: kTitleColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const Icon(
                                    FontAwesomeIcons.dna,
                                    color: kTitleColor,
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'vat'.tr,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                      const SizedBox(height: 5.0),
                                      Text(
                                        '${Get.find<GlobalController>()
                                            .currency!} ${dashboard.dashboardData.merchant!.vat.toString()}',
                                        style: kTextStyle.copyWith(
                                            color: kTitleColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const Icon(
                                    FontAwesomeIcons.hourglass,
                                    color: kTitleColor,
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'payment_processing'.tr,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                      const SizedBox(height: 5.0),
                                      Text(
                                        '${Get.find<GlobalController>()
                                            .currency!} ${dashboard.dashboardData.tBalanceProc.toString()}',
                                        style: kTextStyle.copyWith(
                                            color: kTitleColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const Icon(
                                    FontAwesomeIcons.database,
                                    color: kTitleColor,
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'paid_amount'.tr,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                      const SizedBox(height: 5.0),
                                      Text(
                                        '${Get.find<GlobalController>()
                                            .currency!} ${dashboard.dashboardData.tBalancePaid.toString()}',
                                        style: kTextStyle.copyWith(
                                            color: kTitleColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const Icon(
                                    FontAwesomeIcons.houseChimney,
                                    color: kTitleColor,
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'total_shop'.tr,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                      const SizedBox(height: 5.0),
                                      Text(
                                        '${dashboard.dashboardData.tShop.toString()}',
                                        style: kTextStyle.copyWith(
                                            color: kTitleColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const Icon(
                                    FontAwesomeIcons.boxesStacked,
                                    color: kTitleColor,
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'total_parcel_bank_item'.tr,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                      const SizedBox(height: 5.0),
                                      Text(
                                        dashboard.dashboardData.tParcelBank.toString(),
                                        style: kTextStyle.copyWith(
                                            color: kTitleColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const Icon(
                                    FontAwesomeIcons.clockRotateLeft,
                                    color: kTitleColor,
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'total_payment_request'.tr,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                      const SizedBox(height: 5.0),
                                      Text(
                                        dashboard.dashboardData.tRequest.toString(),
                                        style: kTextStyle.copyWith(
                                            color: kTitleColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const Icon(
                                    FontAwesomeIcons.users,
                                    color: kTitleColor,
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'total_fraud_customer'.tr,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                      const SizedBox(height: 5.0),
                                      Text(
                                        dashboard.dashboardData.tFraud.toString(),
                                        style: kTextStyle.copyWith(
                                            color: kTitleColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),*/
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
    );
  }

  void checkDistance() {
  /* LatLng point1 = LatLng(28.4012825, 79.4790013);
    LatLng point2 = LatLng(28.644512, 77.2215346); */

    LatLng point1 = LatLng(17.4615812,78.3454611);
    LatLng point2 = LatLng(16.491775,76.544115);
    double distance = calculateDistance(point1, point2);
   print('Distancead ==> ${distance.toStringAsFixed(2)}');


  }

// Function to calculate distance between two LatLng points using Haversine formula
  double calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371; // Radius of the earth in kilometers

    // Convert latitude and longitude from degrees to radians
    double startLatRadians = degreesToRadians(start.latitude);
    double startLongRadians = degreesToRadians(start.longitude);
    double endLatRadians = degreesToRadians(end.latitude);
    double endLongRadians = degreesToRadians(end.longitude);

    // Calculate the change in coordinates
    double latDiff = endLatRadians - startLatRadians;
    double longDiff = endLongRadians - startLongRadians;

    // Calculate the distance using Haversine formula
    double a = pow(sin(latDiff / 2), 2) +
        cos(startLatRadians) * cos(endLatRadians) * pow(sin(longDiff / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;

    return distance;
  }

// Function to convert degrees to radians
  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }}
