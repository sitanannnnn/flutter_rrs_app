import 'package:flutter/material.dart';

class MyStyle {
  Color darkColor = Colors.grey;
  Color primaryColor = Colors.yellow;
  Color secondonryColor = Colors.yellow.shade100;

  SizedBox mySizebox() => SizedBox(
        width: 10.0,
        height: 18.0,
      );
  Widget titleCenter(String string) {
    return Center(
      child: Text(
        string,
        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Text showTitle(String title) => Text(
  //       title,
  //       style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
  //     );
  Text showTitleH2(String title) => Text(
        title,
        style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
      );

  Container showLogo() {
    return Container(
      child: Image.asset('assets/images/1.jpg'),
    );
  }

  Widget showProgrsee() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Container showLogotable() {
    return Container(
      width: 200,
      height: 200,
      child: Image.asset('assets/images/table.png'),
    );
  }

  // TextStyle mainTitle =
  //     TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: kprimary);
  TextStyle mainH2Title =
      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: kprimary);
}

const kprimary = Color(0xffF1B739);
const ksecondary = Color(0xffF3E1B7);
