import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  Text showTitleH2(String title) => Text(title,
      style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold));
  Text showheadText(String title) =>
      Text(title, style: GoogleFonts.lato(fontSize: 20));

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
      width: 350,
      height: 350,
      child: Image.asset('assets/images/tableres.png'),
    );
  }

  // TextStyle mainTitle =
  //     TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: kprimary);
  TextStyle mainH2Title =
      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: kprimary);
}

const kprimary = Color(0xffF1B739);
const ksecondary = Color(0xffF3E1B7);
