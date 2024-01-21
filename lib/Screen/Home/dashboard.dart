import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  LanguageController languageController = Get.put(LanguageController());

  String googleApikey = "AIzaSyBc9NWl1xW1re3YptnoWklDPvbNvixWQ2E"/*"AIzaSyA59LKmwVl-gP4U58kSKFTdu89I72bC1hM"*/;
  GoogleMapController? mapController; //contrller for Google map
  CameraPosition? cameraPosition;
  late LatLng startLocation /*= LatLng(28.4222787, 79.4705642)*/;
  String locationAddress = "";
  String googleApikey_2 = "AIzaSyA59LKmwVl-gP4U58kSKFTdu89I72bC1hM";
  GoogleMapController? mapController_2; //contrller for Google map
  CameraPosition? cameraPosition_2;
  late LatLng startLocation_2 /*= LatLng(28.4222787, 79.4705642)*/;
  String fromlocation = "search designation";

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
    const Color(0xFFfafafb /*0xFFEFFBF8*/),
    const Color(0xFFfafafb /*0xFFFDF9EE*/),
    const Color(0xFFfafafb /*0xFFFBEBF1*/),
    const Color(0xFFfafafb /*0xFFEFF5FA*/),
  ];

  List<String> imageList = [
    Images.banner1,
    Images.banner2,
    Images.banner3,
  ];

  DashboardController dashboardController = DashboardController();
  GlobalController globalController = GlobalController();

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

  getLocation()async{
    LocationPermission permission  = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever){
      log("Location denied");
      LocationPermission ask = await Geolocator.requestPermission();
    }else{
     Position currentposition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      log("Lat ==> ${currentposition!.latitude.toString()}");
      log("Long ==> ${currentposition!.longitude.toString()}");
     startLocation = LatLng(currentposition.latitude as double, currentposition.longitude as double);
     startLocation_2 = LatLng(currentposition.latitude as double, currentposition.longitude as double);
     //----------get Address-------------------------

     List<Placemark> newPlace = await placemarkFromCoordinates(currentposition!.latitude , currentposition!.longitude);
     Placemark placeMark  = newPlace[0];
     String? name = placeMark.name;
     String? subLocality = placeMark.subLocality;
     String? locality = placeMark.locality;
     String? administrativeArea = placeMark.administrativeArea;
     String? postalCode = placeMark.postalCode;
     String? country = placeMark.country;
     locationAddress = "${name}, ${subLocality}, ${locality}, ${administrativeArea} ${postalCode}, ${country}";
     print(locationAddress); // do what you want with it
     log("address ==> ${locationAddress}");
    }
  }

  @override
  Widget build(BuildContext context) {
    selectedLang = languageController.languageList[languageController.languageList.indexWhere((i) => i.locale == Get.locale)];
    getLocation();
    return Scaffold(backgroundColor: kMainColor,
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
                        imageUrl: Get.find<GlobalController>().userImage == null
                            ? 'assets/images/profile.png'
                            : Get.find<GlobalController>().userImage.toString(),
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          radius: 25.0,
                          backgroundImage: imageProvider,
                          backgroundColor: Colors.transparent,
                        ),
                        placeholder: (context, url) => Shimmer.fromColors(
                          child: CircleAvatar(radius: 25.0),
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[400]!,
                        ),
                        errorWidget: (context, url, error) => Icon(
                          CupertinoIcons.person,
                          size: 30,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (Get.find<GlobalController>().userName != null)
                            Text(
                              Get.find<GlobalController>().userName.toString(),
                              style: kTextStyle.copyWith(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          if (Get.find<GlobalController>().userEmail != null)
                            Text(
                              Get.find<GlobalController>().userEmail.toString(),
                              style: kTextStyle.copyWith(color: Colors.white),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
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
                      shape: BoxShape.circle,
                    ),
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
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(FeatherIcons.chevronRight,
                        color: kTitleColor, size: 18),
                  ),
                ),

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
                      shape: BoxShape.circle,
                    ),
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
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
        backgroundColor: kMainColor,
        elevation: 0.0,
        title: Text(
          '${Get.find<GlobalController>().siteName}',
          style: kTextStyle.copyWith(
              color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: GetBuilder<DashboardController>(
          init: DashboardController(),
          builder: (dashboard) => SingleChildScrollView(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10.0),
                    dashboard.dashboardLoader ? DashboardShimmer() : Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: const BoxDecoration(
                              color: Color(0xFFf9f9fe),
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
                                  Positioned(
                                      child: InkWell(
                                          onTap: () async {
                                            var place = await PlacesAutocomplete.show(
                                                    context: context,
                                                    apiKey: googleApikey,
                                                    mode: Mode.overlay,
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
                                                locationAddress = place.description.toString();
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
                                              final lang =geometry.location.lng;
                                              var newlatlang =LatLng(lat, lang);

                                              //move map camera to selected place with animation
                                              mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 17)));
                                            }
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Card(
                                              child: Container(
                                                  padding: EdgeInsets.all(0),
                                                  width: MediaQuery.of(context).size.width - 30,
                                                  child: ListTile(
                                                    title: Text(locationAddress,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                    trailing:
                                                        Icon(Icons.search),
                                                    dense: true,
                                                  )),
                                            ),
                                          ))),

                                 Container(height: 250, width: 400,
                                   child: GoogleMap(
                                   zoomGesturesEnabled: true,
                                   initialCameraPosition: CameraPosition(
                                     target: startLocation,
                                     zoom: 14.0,
                                   ),
                                   mapType: MapType.normal,
                                   onMapCreated: (controller) {
                                     setState(() {
                                       mapController = controller;
                                     });
                                   },
                                 ),
                                 ),

                                  Positioned(
                                      child: InkWell(
                                          onTap: () async {
                                            var place = await PlacesAutocomplete.show(
                                                context: context,
                                                apiKey: googleApikey_2,
                                                mode: Mode.overlay,
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
                                                fromlocation = place.description.toString();
                                              });

                                              //form google_maps_webservice package
                                              final plist = GoogleMapsPlaces(
                                                apiKey: googleApikey_2,
                                                apiHeaders: await GoogleApiHeaders().getHeaders(),
                                                //from google_api_headers package
                                              );
                                              String placeid = place.placeId ?? "0";
                                              final detail = await plist.getDetailsByPlaceId(placeid);
                                              final geometry = detail.result.geometry!;
                                              final lat = geometry.location.lat;
                                              final lang =geometry.location.lng;
                                              var newlatlang =LatLng(lat, lang);

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
                                                    title: Text(
                                                      fromlocation,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                    trailing:
                                                    Icon(Icons.search),
                                                    dense: true,
                                                  )),
                                            ),
                                          ))),

                                  CarouselSlider.builder(
                                    options: CarouselOptions(
                                      height: 200,
                                      aspectRatio: 16 / 9,
                                      viewportFraction: 0.8,
                                      initialPage: 0,
                                      enableInfiniteScroll: true,
                                      reverse: false,
                                      autoPlay: true,
                                      autoPlayInterval:
                                          const Duration(seconds: 3),
                                      autoPlayAnimationDuration:
                                          const Duration(milliseconds: 800),
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      enlargeCenterPage: true,
                                      onPageChanged: null,
                                      scrollDirection: Axis.horizontal,
                                    ),
                                    // itemCount: imageList.length,
                                    itemCount: dashboard.offersList.isNotEmpty
                                        ? dashboard.offersList.length
                                        : imageList.length,
                                    itemBuilder: (BuildContext context,
                                        int index, int realIndex) {
                                      return dashboard.offersList.isNotEmpty
                                          ? CachedNetworkImage(
                                              imageUrl: dashboard
                                                  .offersList[index].image
                                                  .toString(),
                                              imageBuilder: (context,
                                                      imageProvider) =>
                                                  Container(
                                                      height: 150,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image:
                                                                imageProvider),
                                                      )),
                                              placeholder: (context, url) =>
                                                  Shimmer.fromColors(
                                                child:
                                                    CircleAvatar(radius: 50.0),
                                                baseColor: Colors.grey[300]!,
                                                highlightColor:
                                                    Colors.grey[400]!,
                                              ),
                                              errorWidget:
                                                  (context, url, error) => Icon(
                                                CupertinoIcons.person,
                                                size: 50,
                                              ),
                                            )
                                          : Container(
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
                                    'Customer Dashboard'.tr,
                                    style: kTextStyle.copyWith(
                                        color: kTitleColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),

                                  const SizedBox(height: 10),

                                  GridView.count(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10.0,
                                    childAspectRatio: 1.1,
                                    mainAxisSpacing: 10.0,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    children: List.generate(
                                      4,
                                      (i) {
                                        return Card(
                                          color: colorList[i],
                                          elevation: 10,
                                          shadowColor: kMainColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const SizedBox(height: 20),
                                                Icon(
                                                  iconList[i],
                                                  size: 40,
                                                  color:
                                                      kMainColor /*kTitleColor*/,
                                                ),
                                                const SizedBox(height: 10.0),
                                                Text(
                                                  reportList[i],
                                                  style: kTextStyle.copyWith(
                                                      color:
                                                          kMainColor /*kTitleColor*/,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(height: 10.0),
                                                Text(
                                                  i == 0
                                                      ? dashboard
                                                          .dashboardData.tParcel
                                                          .toString()
                                                      : i == 1
                                                          ? dashboard
                                                              .dashboardData
                                                              .tDelivered
                                                              .toString()
                                                          : i == 2
                                                              ? dashboard
                                                                  .dashboardData
                                                                  .tReturn
                                                                  .toString()
                                                              : i == 3
                                                                  ? "${dashboard.dashboardData.tParcel! - (dashboard.dashboardData.tDelivered! + dashboard.dashboardData.tReturn!)}"
                                                                  : '0',
                                                  style: kTextStyle.copyWith(
                                                      color:
                                                          kMainColor /*kTitleColor*/,
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              )),
    );
  }
}
