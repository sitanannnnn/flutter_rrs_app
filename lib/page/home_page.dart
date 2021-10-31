import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/dashboard/my_booking.dart';

import 'package:flutter_rrs_app/screen/profile.dart';
import 'package:flutter_rrs_app/model/user_model.dart';
import 'package:flutter_rrs_app/screen/homescreen.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPage = 0;
  GlobalKey bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    double wid = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: _getPage(currentPage),
        ),
      ),
      //เเสดง navigator bar Home,My booking,profile
      bottomNavigationBar: FancyBottomNavigation(
        barBackgroundColor: kprimary,
        circleColor: ksecondary,
        textColor: Colors.white,
        inactiveIconColor: Colors.white,
        tabs: [
          TabData(
              iconData: Icons.home,
              title: "Home",
              onclick: () {
                final FancyBottomNavigationState fState = bottomNavigationKey
                    .currentState as FancyBottomNavigationState;
                fState.setPage(2);
              }),
          TabData(
              iconData: Icons.list_alt,
              title: "My Booking",
              onclick: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => MyBooking()))),
          TabData(
              iconData: Icons.person,
              title: "Profile",
              onclick: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Profile(
                        userModel: UserModel(),
                      )))),
        ],
        initialSelection: 0,
        key: bottomNavigationKey,
        onTabChangedListener: (position) {
          setState(() {
            currentPage = position;
          });
        },
      ),
    );
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        return HomeScreen();
      case 1:
        return MyBooking();
      default:
        return Profile(
          userModel: UserModel(),
        );
    }
  }
}
