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
  const Home( {Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSelected = true;
  int _currentPage = 0;
  bool clickedCentreFAB =false; //boolean used to handle container animation which expands from the FAB
  int selectedIndex =0; //to handle which item is currently selected in the bottom app bar
  String text = "Home";

  static List<Widget> _widgetOptions = <Widget>[
    DashBoard(),
    ParcelPage(height: 0.78),
    DeliveryChargeList(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
  /* return Scaffold(
     floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
     extendBody: true,
     backgroundColor: kMainColor,
     body: _widgetOptions.elementAt(_currentPage),

     floatingActionButton: FloatingActionButton(
       backgroundColor: Colors.orange,
       elevation: 2.0,
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
        height: 55,
        notchMargin: 1,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(icon: const Icon(FontAwesomeIcons.house, size: 16.0,color: Colors.white,),
              onPressed: () {
             // setState(() => _currentPage);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => DashBoard()));
              },
            ),

            IconButton(icon: const Icon(FontAwesomeIcons.cartShopping,size: 16.0,color: Colors.white,),
              onPressed: () {
               // setState(() => _currentPage);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ParcelPage(height: 0.78)));

              },
            ),

            IconButton(icon: const Icon(FontAwesomeIcons.clipboardList,size: 16.0,color: Colors.white,),
              onPressed: () {
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
    );*/
    return Scaffold(
      backgroundColor: kBgColor,
      body: _widgetOptions.elementAt(_currentPage),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,
      //specify the location of the FAB
/*
      floatingActionButton: FloatingActionButton(
        autofocus: true,
        shape: CircleBorder(),
        backgroundColor: Colors.white,
      //  shape: RoundedRectangleBorder(),
        onPressed: () {
           // clickedCentreFAB = !clickedCentreFAB;
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateParcel()));
        },
        tooltip: "Centre FAB",
        child: Container(
          color: Colors.white,
          child: Icon(Icons.add,color: Colors.black),
        ),
       // elevation: 4.0,
      ),
*/

      bottomNavigationBar: Container(
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
               topLeft: Radius.circular(5.0),
                topRight: Radius.circular(5.0),
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10,
                    offset: Offset(0, -1))
              ]),
          child: BottomBar(
            backgroundColor: Colors.white,
            //Color(0xFFFFFFFF),
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
                activeColor: kMainColor,
                inactiveColor: grayColor,
              ),

              /// History

              /// Orders
              BottomBarItem(
                backgroundColorOpacity: 0.1,
                icon: const Icon(
                  FontAwesomeIcons.cartShopping,
                  size: 16.0),
                title: Text(
                  "parcel".tr,
                  style: kTextStyle.copyWith(
                      color: kTitleColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w700),
                ),
                activeColor: kMainColor,
                inactiveColor: grayColor,
              ),

              BottomBarItem(
                icon: const Icon(FontAwesomeIcons.clipboardList, size: 16.0),
                title: Text(
                  "delivery_charges".tr,
                  style: kTextStyle.copyWith(
                      color: kTitleColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w700),
                ),
                activeColor: kMainColor,
                inactiveColor: grayColor,
              ),

              /// Profile
              BottomBarItem(
                icon: ImageIcon(AssetImage("assets/images/user.png")/*FontAwesomeIcons.user*/,size: 16.0),
                title: Text(
                  "profile".tr,
                  style: kTextStyle.copyWith(
                      color: kTitleColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w700),
                ),
                activeColor: kMainColor,
                inactiveColor: grayColor,
              ),
            ],
            onTap: (int index) {
              setState(() => _currentPage = index);
            },
            selectedIndex: _currentPage,
          )
    ),
    );
  }
}
