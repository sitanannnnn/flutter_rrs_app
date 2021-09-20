import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/user_model.dart';
import 'package:flutter_rrs_app/page/home_page.dart';
import 'package:flutter_rrs_app/screen/showOwner.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:flutter_rrs_app/utility/normal_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String? user, password;
  void validate() {
    if (formkey.currentState!.validate()) {
      print("Ok");
    } else {
      print('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kprimary,
          title: Text(
            "Login",
            style: GoogleFonts.lato(fontSize: 20, color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyStyle().mySizebox(),
                  MyStyle().mySizebox(),
                  MyStyle().showLogotable(),
                  MyStyle().mySizebox(),
                  MyStyle().mySizebox(),
                  userForm(),
                  MyStyle().mySizebox(),
                  passwordForm(),
                  MyStyle().mySizebox(),
                  MyStyle().mySizebox(),
                  loginButtom(context),
                  MyStyle().mySizebox(),
                ],
              ),
            ),
          ),
        ));
  }

  //function show buttom login
  Container loginButtom(BuildContext context) {
    return Container(
      width: 300,
      height: 50,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: kprimary,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)))),
          onPressed: () {
            //check user,password ==null,isempty
            if (user == null ||
                user!.isEmpty ||
                password == null ||
                password!.isEmpty) {
              normalDialog(context, 'Please complete the information');
            } else {
              checkAuthen();
            }
            MaterialPageRoute route =
                MaterialPageRoute(builder: (context) => MyHomePage());
          },
          child: Text(
            'Login',
            style: GoogleFonts.lato(fontSize: 20),
          )),
    );
  }

//function check type user
  Future<Null> checkAuthen() async {
    var url = '${Myconstant().domain}/getUser.php?isAdd=true&user=$user';
    try {
      Response response = await Dio().get(url);
      // print('res = $response');

      var result = json.decode(response.data);
      // print('result = $result');
      for (var map in result) {
        UserModel userModel = UserModel.fromJson(map);
        if (password == userModel.password) {
          String? chooseType = userModel.chooseType;
          if (chooseType == 'User') {
            routeTuService(MyHomePage(), userModel);
          } else if (chooseType == 'Shop') {
            routeTuService(ShopOwner(), userModel);
          } else {
            normalDialog(context, 'Error');
          }
        } else {
          normalDialog(context, 'Password ผิด กรุณาลองใหม่อีกครั้ง');
        }
      }
    } catch (e) {}
  }

  Future<Null> routeTuService(Widget myWidget, UserModel userModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('customerId', userModel.customerId.toString());
    preferences.setString('chooseType', userModel.chooseType.toString());
    preferences.setString('name', userModel.name.toString());
    preferences.setString('user', userModel.user.toString());
    preferences.setString('email', userModel.email.toString());
    preferences.setString('phonenumber', userModel.phonenumber.toString());
    preferences.setString('password', userModel.password.toString());
    preferences.setString(
        'confirmpassword', userModel.confirmpassword.toString());
    preferences.setString('urlPicture', userModel.urlPicture.toString());

    MaterialPageRoute route = MaterialPageRoute(builder: (context) => myWidget);
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

//function form input user
  Widget userForm() => Container(
        width: 300,
        height: 60,
        child: TextField(
          onChanged: (value) => user = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_box,
              color: MyStyle().darkColor,
            ),
            labelStyle: TextStyle(color: MyStyle().darkColor),
            labelText: 'User :',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().darkColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().primaryColor)),
          ),
        ),
      );
  //function form input password
  Widget passwordForm() => Container(
        width: 300,
        height: 60,
        child: TextField(
          onChanged: (value) => password = value.trim(),
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: MyStyle().darkColor,
            ),
            labelStyle: TextStyle(color: MyStyle().darkColor),
            labelText: 'Password :',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().darkColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().primaryColor)),
          ),
        ),
      );
  //function show image
  Widget myLogo() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyStyle().showLogo(),
        ],
      );
  //function showimage
  Widget myLogotable() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyStyle().showLogotable(),
        ],
      );
}
