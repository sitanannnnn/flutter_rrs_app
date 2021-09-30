import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:flutter_rrs_app/utility/normal_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  void validate;
  String? chooseType, name, user, email, phonenumber, password, confirmpassword;
  double? lat, lng;
  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  //function ว่าเราได้มีการเปิดเเชร์ตำเเหน่งที่ตั้งของเราหรือไม่
  Future<Null> checkPermission() async {
    bool locationService;
    LocationPermission locationPermission;

    locationService = await Geolocator.isLocationServiceEnabled();
    if (locationService) {
      print('Service Location Open');

      locationPermission = await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.deniedForever) {
          locationnormalDialog(context, 'please open my location');
        } else {
          // Find LatLang
          findLatLng();
        }
      } else {
        if (locationPermission == LocationPermission.deniedForever) {
          locationnormalDialog(context, 'please open my location');
        } else {
          // Find LatLng
          findLatLng();
        }
      }
    } else {
      print('Service Location Close');
      locationnormalDialog(context, 'please open my location');
    }
  }

  //function ค้นหา latitude longitude
  Future<Null> findLatLng() async {
    print('findLatLan ==> Work');
    Position? position = await findPostion();
    setState(() {
      lat = position!.latitude;
      lng = position.longitude;
      print('lat = $lat, lng = $lng');
    });
  }

//function หา position
  Future<Position?> findPostion() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      return null;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kprimary,
        title: Text(
          "Sign up",
          style: GoogleFonts.lato(fontSize: 20, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: formkey,
            child: Center(
              child: Column(
                children: [
                  // MyStyle().showLogo(),
                  MyStyle().mySizebox(),
                  MyStyle().mySizebox(),
                  MyStyle().showLogotable(),
                  MyStyle().mySizebox(),
                  nameForm(),
                  MyStyle().mySizebox(),
                  userForm(),
                  MyStyle().mySizebox(),
                  emailForm(),
                  MyStyle().mySizebox(),
                  phonenumberForm(),
                  MyStyle().mySizebox(),
                  passwordForm(),
                  MyStyle().mySizebox(),
                  confirmpasswordForm(),
                  MyStyle().mySizebox(),
                  chooseTypeuser(),
                  MyStyle().mySizebox(),
                  registerButtom(context),
                  // registerButtom(),
                  MyStyle().mySizebox(),
                ],
              ),
            )),
      ),
    );
  }

//show choose userRadio,shopRadio
  Container chooseTypeuser() {
    return Container(
      width: 300,
      height: 150,
      decoration: ShapeDecoration(
          color: ksecondary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyStyle().showTitleH2('Type of Users '),
          userRadio(),
          shopRadio(),
        ],
      ),
    );
  }

// form input confirmpassword
  Container confirmpasswordForm() {
    return Container(
      width: 300,
      height: 60,
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
        obscureText: true,
      ),
    );
  }

// form input password
  Container passwordForm() {
    return Container(
      width: 300,
      height: 60,
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
        obscureText: true,
      ),
    );
  }

  // form input phonenumberForm
  Container phonenumberForm() {
    return Container(
      width: 300,
      height: 60,
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

  // form input email
  Container emailForm() {
    return Container(
      width: 300,
      height: 60,
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

// form input user
  Container userForm() {
    return Container(
      width: 300,
      height: 60,
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

// form input name
  Container nameForm() {
    return Container(
      width: 300,
      height: 60,
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

//buttom register
  Container registerButtom(BuildContext context) {
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
          if (formkey.currentState!.validate()) {
            print(chooseType);
            switch (chooseType) {
              //choose =shop ใหhทำการ checkShop
              case 'Shop':
                checkShop();
                break;
              //choose =user ใหhทำการ checkuser
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
        child: Text(
          "Register",
          style: GoogleFonts.lato(fontSize: 20),
        ),
      ),
    );
  }

//function userRadio => ถ้าเลือกที่ userRadio  value=User
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
                Text('User', style: GoogleFonts.lato(fontSize: 15))
              ],
            ),
          ),
        ],
      );
  //function shopRadio => ถ้าเลือกที่ shopRadio  value=Shop
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
                Text('Restaurant', style: GoogleFonts.lato(fontSize: 15))
              ],
            ),
          ),
        ],
      );
//function checkUser จะตรวจสอบว่า user ที่กรอกเข้ามาซ้ำกับuserในฐานข้อมูลหรือไม่
  Future<Null> checkUser() async {
    String url = '${Myconstant().domain}/getUser.php?isAdd=true&user=$user';
    try {
      Response response = await Dio().get(url);
      print('res = $response');
      if (response.toString() == 'null') {
        registerThreadUser();
      } else {
        normalDialog(context, ' $user someone already used please change User');
      }
    } catch (e) {}
  }

//function checkshop จะตรวจสอบว่า user ที่กรอกเข้ามาซ้ำกับuserในฐานข้อมูลหรือไม่
  Future<Null> checkShop() async {
    String url =
        '${Myconstant().domain}/getRestaurant.php?isAdd=true&user=$user';
    try {
      Response response = await Dio().get(url);
      print('res = $response');
      if (response.toString() == 'null') {
        registerThreadShop();
      } else {
        normalDialog(context, ' $user someone already used please change User');
      }
    } catch (e) {}
  }

//function บันทึกข้อมูลของ customerลงในฐานข้อมูล
  Future<Null> registerThreadUser() async {
    var url =
        '${Myconstant().domain}/addUser.php?isAdd=true&chooseType=$chooseType&name=$name&user=$user&email=$email&phonenumber=$phonenumber&password=$password&confirmpassword=$confirmpassword';
    try {
      Response response = await Dio().get(url);
      print('res = $response');
      if (response.toString() == 'true') {
        Fluttertoast.showToast(
            msg: 'Signup complect',
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: kprimary,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pop(context);
      } else {
        normalDialog(context, 'Unable to apply please try again');
      }
    } catch (e) {}
  }

//function บันทึกข้อมูลของ restaurant ลงในฐานข้อมูล
  Future<Null> registerThreadShop() async {
    var url =
        '${Myconstant().domain}/addRestaurant.php?isAdd=true&chooseType=$chooseType&name=$name&user=$user&email=$email&phonenumber=$phonenumber&password=$password&confirmpassword=$confirmpassword';
    try {
      Response response = await Dio().get(url);
      print('res = $response');
      if (response.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'Unable to apply please try again');
      }
    } catch (e) {}
  }

//function show image
  Widget myLogo() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyStyle().showLogo(),
        ],
      );
  //function show image
  Widget myLogotable() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyStyle().showLogotable(),
        ],
      );
}
