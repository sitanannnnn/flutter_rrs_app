import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/dashboard/my_booking.dart';
import 'package:flutter_rrs_app/dashboard/profile.dart';
import 'package:flutter_rrs_app/screen/homescreen_logout.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';

class MyHomePageOut extends StatefulWidget {
  @override
  _MyHomePageOutState createState() => _MyHomePageOutState();
}

class _MyHomePageOutState extends State<MyHomePageOut> {
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
              onclick: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Profile()))),
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
        return HomeScreenOut();
      case 1:
        return MyBooking();
      default:
        return Profile();
    }
  }
}
