import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rrs_app/model/user_model.dart';
import 'package:flutter_rrs_app/screen/save_profile_img.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:flutter_rrs_app/utility/normal_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  File? _image;
  Uint8List? _imageBytes;
  final picker = ImagePicker();
  List<UserModel> userModels = [];
  CloudApiProfileImg? api;
  String? _imageName;
  String? name,
      email,
      phonenumber,
      user,
      password,
      confirmpassword,
      newpassword,
      oldpassword,
      urlPicture;
  final _formkey = GlobalKey<FormState>();

  @override
  //initstate จะทำงานก่อน build
  void initState() {
    super.initState();
    rootBundle.loadString('assets/credentials.json').then((json) {
      api = CloudApiProfileImg(json);
    });
    userModel = widget.userModel;
    urlPicture = userModel?.urlPicture;
    findUser();
    readcustomer();
    // readPicture();
  }

  void _saveImage() async {
    // upload image to google cloud
    print('save image here');
    final response = await api!.save(_imageName!, _imageBytes!);
    print(response!.downloadLink);
    editImageProfile();
  }

  Future<Null> editNameMySQL() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? customerId = preferences.getString("customerId");
    print('CustomerId is =$customerId');

    String? url =
        '${Myconstant().domain_00webhost}/editCustomerWhereName.php?isAdd=true&customerId=$customerId&name=$name';
    await Dio().get(url).then((value) {
      if (value.statusCode == 200) {
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
        '${Myconstant().domain_00webhost}/editCustomerWherePhonenumber.php?isAdd=true&customerId=$customerId&phonenumber=$phonenumber';
    await Dio().get(url).then((value) {
      if (value.statusCode == 200) {
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
        '${Myconstant().domain_00webhost}/editCustomerWherePassword.php?isAdd=true&customerId=$customerId&password=$confirmpassword&confirmpassword=$confirmpassword';
    await Dio().get(url).then((value) {
      if (value.statusCode == 200) {
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: 'changs password successfully',
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.red[100],
            textColor: Colors.white,
            fontSize: 16.0);
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
      urlPicture = preferences.getString('urlPicture');
      print('image===>$urlPicture');
    });
  }

  Future<Null> chooseImage(ImageSource imageSource) async {
    final pickedFile = await picker.pickImage(
      source: imageSource,
      maxHeight: 800.0,
      maxWidth: 800.0,
    );
    setState(() {
      if (pickedFile != null) {
        print(pickedFile.path);
        _image = File(pickedFile.path);
        _imageBytes = _image!.readAsBytesSync();
        _imageName = _image!.path.split('/').last;
        urlPicture = _imageName;
        print('patg image = $_imageName');
      } else {
        print('No image selectd');
      }
    });
  }

//อ่านข้อมูลลูกค้ามาเเสดง ผ่าน customerId
  Future<Null> readcustomer() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? customerId = preferences.getString('customerId');
    String url =
        '${Myconstant().domain_00webhost}/getcustomerWherecustomerId.php?isAdd=true&customerId=$customerId';
    Response response = await Dio().get(url);
    // print('res==> $response');
    var result = json.decode(response.data);
    print('result= $result');
    for (var map in result) {
      UserModel userModel = UserModel.fromJson(map);
      password = userModel.password;
      print('password aomam = $password');
      setState(() {
        userModels.add(userModel);
      });
    }
  }

  uploadFile() async {
    String uploadurl =
        "${Myconstant().domain_00webhostpic}/uploadprofilecustomer.php"; //Edit path file upload_foodmenu_picture.php
    FormData formdata = FormData.fromMap({
      "file": await MultipartFile.fromFile(_image!.path, filename: _imageName),
    });
    Response response = await Dio().post(
      uploadurl,
      data: formdata,
    );
    print('response upload iamge = ${response.statusCode}');
    if (response.statusCode == 200) {
      print(response.toString());
      editImageProfile();
      // addFoodMenuThread();
    } else {
      print("Error during connection to server.");
    }
  }

//edit รูปภาพของ profile
  Future<Null> editImageProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? customerId = preferences.getString('customerId');
    String url =
        '${Myconstant().domain_00webhost}/editCustomerWhereImage.php?isAdd=true&customerId=$customerId&urlPicture=$urlPicture';
    await Dio().get(url).then((value) {
      if (value.statusCode == 200) {
        Navigator.pop(context);
        print('completed');
      } else {
        normalDialog(context, 'Please try again');
      }
    });
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
                                showDialog(
                                    context: context,
                                    builder: (context) => SimpleDialog(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Form(
                                                key: _formkey,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: <Widget>[
                                                    Text('Old password',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: GoogleFonts.lato(
                                                            fontSize: 20)),
                                                    TextFormField(
                                                      validator: (value) {
                                                        if (value != password ||
                                                            value!.isEmpty)
                                                          return 'The old password is incorrect.';
                                                        return null;
                                                      },
                                                      autofocus: true,
                                                      textAlign:
                                                          TextAlign.center,
                                                      obscureText: true,
                                                    ),
                                                    Text('New password',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: GoogleFonts.lato(
                                                            fontSize: 20)),
                                                    TextFormField(
                                                      validator: (val) {
                                                        if (val!.isEmpty) {
                                                          return "please input Password";
                                                        } else if (val.length <
                                                            8) {
                                                          return "At Least 8 chars required";
                                                        } else {
                                                          return null;
                                                        }
                                                      },
                                                      onChanged: (val) =>
                                                          newpassword = val,
                                                      obscureText: true,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Text(' Confirmpassword',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: GoogleFonts.lato(
                                                            fontSize: 20)),
                                                    TextFormField(
                                                      validator: (val) {
                                                        if (val!.isEmpty) {
                                                          return "please input ConfirmPassword";
                                                        } else if (val.length <
                                                            8) {
                                                          return "At Least 8 chars required";
                                                        } else if (val !=
                                                            newpassword) {
                                                          return "password do not match";
                                                        } else {
                                                          return null;
                                                        }
                                                      },
                                                      onChanged: (value) =>
                                                          confirmpassword =
                                                              value,
                                                      obscureText: true,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          primary: kprimary,
                                                          onPrimary:
                                                              Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          15)))),
                                                      child: Text('Save',
                                                          style:
                                                              GoogleFonts.lato(
                                                                  fontSize:
                                                                      20)),
                                                      onPressed: () {
                                                        if (_formkey
                                                            .currentState!
                                                            .validate()) {
                                                          editPasswordMySQL();
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ));
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
          child: _imageBytes == null
              ? Image.asset(
                  'assets/images/user.png',
                  fit: BoxFit.cover,
                )
              : Stack(
                  children: [
                    Image.memory(_imageBytes!),
                  ],
                )),
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
                        if (_imageBytes == null) {
                          normalDialog(context, 'Please select a picture');
                        } else {
                          uploadFile();
                          Navigator.pop(context);
                        }
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
