import 'package:bottom_bar/bottom_bar.dart';
import 'package:we_courier_merchant_app/Screen/Parcel/create_parcel.dart';
import '/Screen/Home/dashboard.dart';
import '/Screen/Parcel/parcel_index.dart';
import '/Screen/Profile/profile.dart';
import '/Screen/delivery_charges.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../Widgets/constant.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSelected = true;
  int _currentPage = 0;
  bool clickedCentreFAB =
      false; //boolean used to handle container animation which expands from the FAB
  int selectedIndex =
      0; //to handle which item is currently selected in the bottom app bar
  String text = "Home";

  static List<Widget> _widgetOptions = <Widget>[
    DashBoard(),
    ParcelPage(height: 0.78),
    CreateParcel(),
    DeliveryChargeList(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
     extendBody: true,
     backgroundColor: kMainColor,
     body: _widgetOptions.elementAt(_currentPage),

     floatingActionButton: FloatingActionButton(
       backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateParcel()));
        },
        child: const Icon(Icons.add,color: Colors.white,),
      ),
      bottomNavigationBar: BottomAppBar(
          color: Colors.orange,
          shadowColor: Colors.black12,
        shape: CircularNotchedRectangle(),
       // padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 52,
        notchMargin: 1,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(icon: const Icon(FontAwesomeIcons.house, size: 16.0,color: Colors.white,),
              onPressed: () {
                setState(() => _currentPage );
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => DashBoard()));

              },
            ),

            IconButton(icon: const Icon(FontAwesomeIcons.cartShopping,size: 16.0,color: Colors.white,),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ParcelPage(height: 0.78)));

              },
            ),

            IconButton(icon: const Icon(FontAwesomeIcons.clipboardList,size: 16.0,color: Colors.white,),
              onPressed: () {
                setState(() => _currentPage );

                Navigator.of(context).push(MaterialPageRoute(builder: (context) => DeliveryChargeList()));

              },
            ),
            IconButton(icon: const Icon(FontAwesomeIcons.user, size: 16.0,color: Colors.white,),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Profile()));
              },
            ),
          ],
        ),
      ),
    );


   /* return Scaffold(

      backgroundColor: kBgColor,
      body: _widgetOptions.elementAt(_currentPage),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,
      //specify the location of the FAB
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
       // shape: const CircularNotchedRectangle(),
        onPressed: () {
          setState(() {
            clickedCentreFAB = !clickedCentreFAB;
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateParcel()));

//to update the animated container
          });
        },
        tooltip: "Centre FAB",
        child: Container(
          color: Colors.orange,
       //   margin: EdgeInsets.all(15.0),
          child: Icon(Icons.add,),
        ),
        elevation: 4.0,
      ),

      bottomNavigationBar: Container(
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
             *//*   topLeft: Radius.circular(5.0),
                topRight: Radius.circular(5.0),*//*
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -1))
              ]),
          child: BottomBar(
            backgroundColor: Color(0xFFFFFFFF),
            items: [
              /// Home
              BottomBarItem(
                icon: const Icon(FontAwesomeIcons.house, size: 16.0),
                title: Text(
                  "home".tr,
                  style: kTextStyle.copyWith(
                      color: kTitleColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w700),
                ),
                activeColor: kTitleColor,
                inactiveColor: kTitleColor,
              ),

              /// History

              /// Orders
              BottomBarItem(
                backgroundColorOpacity: 0.1,
                icon: const Icon(
                  FontAwesomeIcons.cartShopping,
                  size: 16.0,
                ),
                title: Text(
                  "parcel".tr,
                  style: kTextStyle.copyWith(
                      color: kTitleColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w700),
                ),
                activeColor: kTitleColor,
                inactiveColor: kTitleColor,
              ),

             *//* BottomBarItem(
                icon: const Icon(FontAwesomeIcons.plus, size: 16.0),
                title: Text(
                  "Add Parcel".tr,
                  style: kTextStyle.copyWith(
                      color: kTitleColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w700),
                ),
                activeColor: kTitleColor,
                inactiveColor: kTitleColor,
              ),*//*

              BottomBarItem(
                icon: const Icon(FontAwesomeIcons.clipboardList, size: 16.0),
                title: Text(
                  "delivery_charges".tr,
                  style: kTextStyle.copyWith(
                      color: kTitleColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w700),
                ),
                activeColor: kTitleColor,
                inactiveColor: kTitleColor,
              ),

              /// Profile
              BottomBarItem(
                icon: Icon(FontAwesomeIcons.user, size: 16.0),
                title: Text(
                  "profile".tr,
                  style: kTextStyle.copyWith(
                      color: kTitleColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w700),
                ),
                activeColor: kTitleColor,
                inactiveColor: kTitleColor,
              ),
            ],
            onTap: (int index) {
              setState(() => _currentPage = index);
            },
            selectedIndex: _currentPage,
          )),
    );*/
  }
}
