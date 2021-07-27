import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/user_model.dart';
import 'package:flutter_rrs_app/page/home_page.dart';
import 'package:flutter_rrs_app/screen/showOwner.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:flutter_rrs_app/utility/normal_dialog.dart';

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
        body: SingleChildScrollView(
      child: Form(
        key: formkey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyStyle().showLogo(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            userForm(),
            MyStyle().mySizebox(),
            passwordForm(),
            MyStyle().mySizebox(),
            loginButtom(),
            MyStyle().mySizebox(),
            MyStyle().showLogotable()
          ],
        ),
      ),
    ));
  }

  ElevatedButton loginButtom() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors., // background
          onPrimary: Colors.white, // foreground
        ),
        onPressed: () {
          if (user == null ||
              user!.isEmpty ||
              password == null ||
              password!.isEmpty) {
            normalDialog(context, 'มีช่องว่าง กรุณากรองข้อมูลให้ครบ ค่ะ');
          } else {
            checkAuthen();
          }
          MaterialPageRoute route =
              MaterialPageRoute(builder: (context) => MyHomePage());
        },
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20.0),
        ));
  }

  Future<Null> checkAuthen() async {
    var url =
        '${Myconstant().domain}/my_login_rrs/getUser.php?isAdd=true&user=$user';
    try {
      Response response = await Dio().get(url);
      print('res = $response');

      var result = json.decode(response.data);
      print('result = $result');
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
    preferences.setString('id', userModel.id.toString());
    preferences.setString('chooseType', userModel.chooseType.toString());
    preferences.setString('name', userModel.name.toString());

    preferences.setString('email', userModel.email.toString());
    preferences.setString('phonenumber', userModel.phonenumber.toString());

    MaterialPageRoute route = MaterialPageRoute(builder: (context) => myWidget);
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Widget userForm() => Container(
        width: 250.0,
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
  Widget passwordForm() => Container(
        width: 250.0,
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
  Widget myLogo() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyStyle().showLogo(),
        ],
      );
  Widget myLogotable() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyStyle().showLogotable(),
        ],
      );
}
