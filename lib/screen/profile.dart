import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/user_model.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:flutter_rrs_app/utility/normal_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final UserModel userModel;
  const Profile({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserModel? userModel;
  File? file;
  String? name,
      email,
      phonenumber,
      user,
      password,
      confirmpassword,
      oldpassword,
      urlImage,
      urlPicture;
  final _formkey = GlobalKey<FormState>();

  @override
  //initstate จะทำงานก่อน build
  void initState() {
    super.initState();
    userModel = widget.userModel;
    urlPicture = userModel?.urlPicture;
    findUser();
    // readPicture();
  }

  Future<Null> editNameMySQL() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? customerId = preferences.getString("customerId");
    print('CustomerId is =$customerId');

    String? url =
        '${Myconstant().domain}/editCustomerWhereName.php?isAdd=true&customerId=$customerId&name=$name';
    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'failed try again');
      }
    });
  }

//edit email ที่ฐานข้อมูล
  Future<Null> editEmailMySQL() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? customerId = preferences.getString("customerId");
    print('CustomerId is =$customerId');

    String? url =
        '${Myconstant().domain}/editCustomerWhereEmail.php?isAdd=true&customerId=$customerId&email=$email';
    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'failed try again');
      }
    });
  }

//edit phonenumber ที่ฐานข้อมูล
  Future<Null> editPhonenumberMySQL() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? customerId = preferences.getString("customerId");
    print('CustomerId is =$customerId');

    String? url =
        '${Myconstant().domain}/editCustomerWherePhonenumber.php?isAdd=true&customerId=$customerId&phonenumber=$phonenumber';
    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'failed try again');
      }
    });
  }

//edit password ที่ฐานข้อมูล
  Future<Null> editPasswordMySQL() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? customerId = preferences.getString("customerId");
    print('CustomerId is =$customerId');

    String? url =
        '${Myconstant().domain}/editCustomerWherePassword.php?isAdd=true&customerId=$customerId&password=$password&confirmpassword=$confirmpassword';
    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'failed try again');
      }
    });
  }

//หาuser ที่ทำการlogin
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      String? customerId = preferences.getString('customerId');
      print('customerId =$customerId');
      user = preferences.getString('user');
      print('user =$user');
      name = preferences.getString('name');
      email = preferences.getString('email');
      phonenumber = preferences.getString('phonenumber');
      password = preferences.getString('password');
      confirmpassword = preferences.getString('confirmpassword');
      urlPicture = preferences.getString('urlPicture');
      print('image===>$urlPicture');
    });
  }

//เลือกรูปภาพที่ต้องการจะตั้งเป็นรูปprofile
  Future<Null> chooseImage(ImageSource source) async {
    try {
      var result = await ImagePicker()
          .getImage(source: source, maxHeight: 100.0, maxWidth: 100.0);
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

//edit รูปภาพของ profile
  Future<Null> editImageProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? customerId = preferences.getString('customerId');
    String url =
        '${Myconstant().domain}/editCustomerWhereImage.php?isAdd=true&customerId=$customerId&urlPicture=$urlImage';
    await Dio().get(url).then((value) {
      print('value ==>$value');
      if (value.toString() == 'true') {
      } else {
        normalDialog(context, 'Please try again');
      }
    });
  }

// upload รูปภาพที่เราเลือกจะตั้งเป็นรูป profile
  Future<Null> uploadImage() async {
    Random random = Random();
    int image = random.nextInt(1000000);
    String? nameImage = 'profile$image.jpg';
    print('nameImage =$nameImage,pathImage =${file!.path}');
    String? url = '${Myconstant().domain}/saveImageProfile.php';

    try {
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameImage);
      FormData formData = FormData.fromMap(map);
      await Dio().post(url, data: formData).then((value) {
        print('Response ===> $value');
        urlImage = '/Profile/$nameImage';
        print('urlImage =$urlImage');
        editImageProfile();
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    double wid = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kprimary,
        toolbarHeight: wid / 5,
        title: Center(child: Text("Account")),
        actions: [
          // IconButton(
          //     onPressed: () {
          //       // Navigator.push(context,
          //       //     MaterialPageRoute(builder: (context) => ()));
          //     },
          //     icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              editPicture(context),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    user == null ? 'Account' : '$user ',
                    style: TextStyle(fontSize: 25),
                  )),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 450,
                          height: 300,
                          decoration: ShapeDecoration(
                              color: ksecondary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Name',
                                    style: GoogleFonts.lato(fontSize: 20)),
                                SizedBox(
                                  height: 5,
                                ),
                                editName(context),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text('Email',
                                        style: GoogleFonts.lato(fontSize: 20)),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                editEmail(context),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('Phonenumber',
                                    style: GoogleFonts.lato(fontSize: 20)),
                                SizedBox(
                                  height: 5,
                                ),
                                editPhonenumber(context),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => Form(
                                    key: _formkey,
                                    child: SingleChildScrollView(
                                        child: Container(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      color: Color(0xff757575),
                                      child: Container(
                                        padding: EdgeInsets.all(20.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20.0),
                                            topRight: Radius.circular(20.0),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            Text('Old password',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.lato(
                                                    fontSize: 20)),
                                            TextFormField(
                                              validator: (value) {
                                                if (value !=
                                                        userModel!.password ||
                                                    value!.isEmpty)
                                                  return 'The old password is incorrect.';
                                                return null;
                                              },
                                              autofocus: true,
                                              textAlign: TextAlign.center,
                                            ),
                                            Text('New password',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.lato(
                                                    fontSize: 20)),
                                            TextFormField(
                                              validator: (val) {
                                                if (val!.isEmpty) {
                                                  return "please input Password";
                                                } else if (val.length < 8) {
                                                  return "At Least 8 chars required";
                                                } else {
                                                  return null;
                                                }
                                              },
                                              onChanged: (val) =>
                                                  password = val,
                                              obscureText: true,
                                            ),
                                            Text('Confirm password',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.lato(
                                                    fontSize: 20)),
                                            TextFormField(
                                              validator: (val) {
                                                if (val!.isEmpty) {
                                                  return "please input ConfirmPassword";
                                                } else if (val.length < 8) {
                                                  return "At Least 8 chars required";
                                                } else if (password !=
                                                    confirmpassword) {
                                                  return "password do not match";
                                                } else {
                                                  return null;
                                                }
                                              },
                                              onChanged: (value) =>
                                                  confirmpassword = value,
                                              obscureText: true,
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: kprimary,
                                                  onPrimary: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15)))),
                                              child: Text('Save',
                                                  style: GoogleFonts.lato(
                                                      fontSize: 20)),
                                              onPressed: () {
                                                if (_formkey.currentState!
                                                    .validate()) {
                                                  editPasswordMySQL();
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                                  ),
                                );
                              },
                              child: Text('Change Pasword',
                                  style: GoogleFonts.lato(
                                      fontSize: 20, color: Colors.red)),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector editPicture(BuildContext context) {
    return GestureDetector(
      child: Container(
          width: 100,
          height: 100,
          decoration: ShapeDecoration(shape: CircleBorder()),
          child: urlPicture == null
              ? Image.asset(
                  'assets/images/user.png',
                  fit: BoxFit.cover,
                )
              : Image.network('${Myconstant().domain}$urlPicture')),
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            color: Color(0xff757575),
            child: Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text('Edit Profile Picture',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(fontSize: 20)),
                  Divider(
                    height: 5,
                    color: Colors.grey,
                  ),
                  TextButton(
                      onPressed: () => chooseImage(ImageSource.camera),
                      child: Text('Camera',
                          style: GoogleFonts.lato(
                              fontSize: 20, color: Colors.grey))),
                  Divider(
                    height: 5,
                    color: Colors.grey,
                  ),
                  TextButton(
                    onPressed: () => chooseImage(ImageSource.gallery),
                    child: Text('Photos',
                        style:
                            GoogleFonts.lato(fontSize: 20, color: Colors.grey)),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        uploadImage();
                        editImageProfile();
                        // readPicture();
                        // checkAuthen();
                        // Navigator.pop(context);
                      },
                      child:
                          Text('Save', style: GoogleFonts.lato(fontSize: 20))),
                ],
              ),
            ),
          )),
        );
      },
    );
  }

//เเก้ไขชื่อ
  Center editName(BuildContext context) {
    return Center(
        child: Container(
      width: 350,
      height: 50,
      decoration: ShapeDecoration(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name == null ? 'Account' : '$name ',
                style: GoogleFonts.lato(fontSize: 20)),
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => SingleChildScrollView(
                      child: Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    color: Color(0xff757575),
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text('Name',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(fontSize: 20)),
                          TextField(
                            autofocus: true,
                            textAlign: TextAlign.center,
                            onChanged: (val) => name = val,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: kprimary,
                                onPrimary: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)))),
                            child: Text('Save',
                                style: GoogleFonts.lato(fontSize: 20)),
                            onPressed: () {
                              editNameMySQL();
                            },
                          ),
                        ],
                      ),
                    ),
                  )),
                );
              },
              icon: Icon(
                Icons.arrow_forward_ios_rounded,
                color: kprimary,
              ),
            )
          ],
        ),
      ),
    ));
  }

//เเก้ไขเบอร์โทรศัพท์
  Center editPhonenumber(BuildContext context) {
    return Center(
      child: Container(
        width: 350,
        height: 50,
        decoration: ShapeDecoration(
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(phonenumber == null ? 'phonenumber' : '$phonenumber ',
                  style: GoogleFonts.lato(fontSize: 20)),
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => SingleChildScrollView(
                        child: Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      color: Color(0xff757575),
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text('Phonenumber',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(fontSize: 20)),
                            TextField(
                              autofocus: true,
                              textAlign: TextAlign.center,
                              onChanged: (val) => phonenumber = val,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: kprimary,
                                  onPrimary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15)))),
                              child: Text('Save',
                                  style: GoogleFonts.lato(fontSize: 20)),
                              onPressed: () {
                                editPhonenumberMySQL();
                              },
                            ),
                          ],
                        ),
                      ),
                    )),
                  );
                },
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: kprimary,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

//เเก้ไขอีเมล
  Center editEmail(BuildContext context) {
    return Center(
        child: Container(
      width: 350,
      height: 50,
      decoration: ShapeDecoration(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(email == null ? 'email' : '$email ',
                style: GoogleFonts.lato(fontSize: 20, color: Colors.grey)),
            IconButton(
              onPressed: () {
                // showModalBottomSheet(
                //   context: context,
                //   isScrollControlled: true,
                //   builder: (context) => SingleChildScrollView(
                //       child: Container(
                //     padding: EdgeInsets.only(
                //         bottom: MediaQuery.of(context).viewInsets.bottom),
                //     color: Color(0xff757575),
                //     child: Container(
                //       padding: EdgeInsets.all(20.0),
                //       decoration: BoxDecoration(
                //         color: Colors.white,
                //         borderRadius: BorderRadius.only(
                //           topLeft: Radius.circular(20.0),
                //           topRight: Radius.circular(20.0),
                //         ),
                //       ),
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.stretch,
                //         children: <Widget>[
                //           Text('Email',
                //               textAlign: TextAlign.center,
                //               style: GoogleFonts.lato(fontSize: 20)),
                //           TextField(
                //             autofocus: true,
                //             textAlign: TextAlign.center,
                //             onChanged: (val) => email = val,
                //           ),
                //           ElevatedButton(
                //             style: ElevatedButton.styleFrom(
                //                 primary: kprimary,
                //                 onPrimary: Colors.white,
                //                 shape: RoundedRectangleBorder(
                //                     borderRadius:
                //                         BorderRadius.all(Radius.circular(15)))),
                //             child: Text('Save',
                //                 style: GoogleFonts.lato(fontSize: 20)),
                //             onPressed: () {
                //               editEmailMySQL();
                //             },
                //           ),
                //         ],
                //       ),
                //     ),
                //   )),
                // );
              },
              icon: Icon(
                Icons.arrow_forward_ios_rounded,
                color: kprimary,
              ),
            )
          ],
        ),
      ),
    ));
  }
}
