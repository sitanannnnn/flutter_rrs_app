import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/screen/homescreen.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:flutter_rrs_app/utility/normal_dialog.dart';
import 'package:form_field_validator/form_field_validator.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  void validate;
  String? chooseType, name, user, email, phonenumber, password, confirmpassword;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
            key: formkey,
            child: Column(
              children: [
                MyStyle().showLogo(),
                MyStyle().mySizebox(),
                nameForm(),
                userForm(),
                emailForm(),
                phonenumberForm(),
                passwordForm(),
                confirmpasswordForm(),
                MyStyle().mySizebox(),
                MyStyle().showTitleH2('ชนิดของสมาชิก :'),
                MyStyle().mySizebox(),
                userRadio(),
                shopRadio(),
                registerButtom(),
                MyStyle().mySizebox(),
                MyStyle().showLogotable()
              ],
            )),
      ),
    );
  }

  Widget userRadio() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 250.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Radio(
                  value: 'User',
                  groupValue: chooseType,
                  onChanged: (value) {
                    setState(() {
                      chooseType = value.toString();
                    });
                  },
                ),
                Text(
                  'ผู้ใช้งานทั่วไป',
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
          ),
        ],
      );
  Widget shopRadio() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 250.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Radio(
                  value: 'Shop',
                  groupValue: chooseType,
                  onChanged: (value) {
                    setState(() {
                      chooseType = value.toString();
                    });
                  },
                ),
                Text(
                  'ร้านอาหาร',
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
          ),
        ],
      );

  Padding registerButtom() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: kprimary,
          onPrimary: Colors.white,
        ),
        onPressed: () {
          if (formkey.currentState!.validate()) {
            print(chooseType);
            switch (chooseType) {
              case 'Shop':
                checkShop();
                break;
              case 'User':
                checkUser();
                break;
            }
          } else if (chooseType == null) {
            normalDialog(context, "Please select a usage type");
          } else {
            print('Error');
          }
          // registerThread();
        },
        child: Text("Register"),
      ),
    );
  }

  Future<Null> checkUser() async {
    String url =
        'http://b0b2195d2d06.ngrok.io/my_login_rrs/getUser.php?isAdd=true&user=$user';
    try {
      Response response = await Dio().get(url);
      print('res = $response');
      if (response.toString() == 'null') {
        registerThreadUser();
      } else {
        normalDialog(context, 'User นี้ $user มีคนใช้ไปแล้ว กรุณาเปลี่ยน User');
      }
    } catch (e) {}
  }

  Future<Null> checkShop() async {
    String url =
        'http://b0b2195d2d06.ngrok.io/my_login_rrs/getRestaurant.php?isAdd=true&user=$user';
    try {
      Response response = await Dio().get(url);
      print('res = $response');
      if (response.toString() == 'null') {
        registerThreadShop();
      } else {
        normalDialog(context, 'User นี้ $user มีคนใช้ไปแล้ว กรุณาเปลี่ยน User');
      }
    } catch (e) {}
  }

  Future<Null> registerThreadUser() async {
    var url =
        'http://b0b2195d2d06.ngrok.io/my_login_rrs/addUser.php?isAdd=true&chooseType=$chooseType&name=$name&user=$user&email=$email&phonenumber=$phonenumber&password=$password&confirmpassword=$confirmpassword';
    try {
      Response response = await Dio().get(url);
      print('res = $response');
      if (response.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'ไม่สามารถ สมัครได้ กรุณาลองใหม่อีกครั้ง ค่ะ');
      }
    } catch (e) {}
  }

  Future<Null> registerThreadShop() async {
    var url =
        'http://b0b2195d2d06.ngrok.io/my_login_rrs/addRestaurant.php?isAdd=true&chooseType=$chooseType&name=$name&user=$user&email=$email&phonenumber=$phonenumber&password=$password&confirmpassword=$confirmpassword';
    try {
      Response response = await Dio().get(url);
      print('res = $response');
      if (response.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'ไม่สามารถ สมัครได้ กรุณาลองใหม่อีกครั้ง ค่ะ');
      }
    } catch (e) {}
  }

  Padding nameForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.person,
              color: MyStyle().darkColor,
            ),
            labelText: "Name",
            border: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().darkColor),
            )),
        validator: (val) {
          if (val!.isEmpty) {
            return "please input Name";
          } else {
            return null;
          }
        },
        onChanged: (val) => name = val,
      ),
    );
  }

  Padding userForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_box,
              color: MyStyle().darkColor,
            ),
            labelText: "User",
            border: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().darkColor),
            )),
        validator: (val) {
          if (val!.isEmpty) {
            return "please input User";
          } else {
            return null;
          }
        },
        onChanged: (val) => user = val,
      ),
    );
  }

  Padding emailForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.email,
              color: MyStyle().darkColor,
            ),
            labelText: "Email",
            border: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().darkColor),
            )),
        validator: (val) {
          if (val!.isEmpty) {
            return "please input Email";
          } else if (!RegExp("^[a-zA-Z0-9_.-]+@[a-zA-Z0-9,-]+.[a-z]")
              .hasMatch(val)) {
            return "please enter valid email";
          }
        },
        onChanged: (val) => email = val,
      ),
    );
  }

  Padding phonenumberForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.phone,
              color: MyStyle().darkColor,
            ),
            labelText: "Phonenumber",
            border: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().darkColor),
            )),
        validator: (val) {
          if (val!.isEmpty) {
            return "please input Phonenumber";
          } else {
            return null;
          }
        },
        onChanged: (val) => phonenumber = val,
      ),
    );
  }

  Padding passwordForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: MyStyle().darkColor,
            ),
            labelText: "Password",
            border: OutlineInputBorder()),
        validator: (val) {
          if (val!.isEmpty) {
            return "please input Password";
          } else if (val.length < 8) {
            return "At Least 8 chars required";
          } else {
            return null;
          }
        },
        onChanged: (val) => password = val,
      ),
    );
  }

  Padding confirmpasswordForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: MyStyle().darkColor,
            ),
            labelText: "ConformPassword",
            border: OutlineInputBorder()),
        validator: (val) {
          if (val!.isEmpty) {
            return "please input ConfirmPassword";
          } else if (val.length < 8) {
            return "At Least 8 chars required";
          } else if (password != confirmpassword) {
            return "password do not match";
          } else {
            return null;
          }
        },
        onChanged: (val) => confirmpassword = val,
      ),
    );
  }

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
