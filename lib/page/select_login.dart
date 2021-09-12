import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/page/login.dart';
import 'package:flutter_rrs_app/page/signup.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectLogin extends StatefulWidget {
  @override
  _SelectLoginState createState() => _SelectLoginState();
}

class _SelectLoginState extends State<SelectLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Column(
          children: [
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            MyStyle().showLogotable(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            selectLogin(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            selectSignup(),
          ],
        )
      ],
    ));
  }

// buttom selcet signup
  Container selectSignup() {
    return Container(
        width: 300,
        height: 50,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: kprimary,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)))),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Signup()));
            },
            child: Text("Sign up", style: GoogleFonts.lato(fontSize: 20))));
  }

  // buttom selcet Login
  Container selectLogin() {
    return Container(
        width: 300,
        height: 50,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: kprimary,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)))),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
            child: Text("Login", style: GoogleFonts.lato(fontSize: 20))));
  }
}
