import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rrs_app/dashboard/my_booking.dart';
import 'package:flutter_rrs_app/model/orderfood_model.dart';

import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/page/home_page.dart';
import 'package:flutter_rrs_app/screen/save_profile_img.dart';
import 'package:flutter_rrs_app/screen/save_slip_img.dart';
import 'package:flutter_rrs_app/screen/show_unconfirmed_order_food.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';

import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:flutter_rrs_app/utility/normal_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentConfirmation extends StatefulWidget {
  final ReadshopModel? readshopModel;
  final OrderfoodModel orderfoodModel;
  PaymentConfirmation(
      {Key? key, this.readshopModel, required this.orderfoodModel})
      : super(key: key);
  @override
  _PaymentConfirmationState createState() => _PaymentConfirmationState();
}

class _PaymentConfirmationState extends State<PaymentConfirmation> {
  ReadshopModel? readshopModel;
  OrderfoodModel? orderfoodModel;
  String? restaurantId, orderfoodId;
  DateTime? pickerDate;
  TimeOfDay? time;
  File? _image;
  Uint8List? _imageBytes;
  final picker = ImagePicker();
  CloudApiSlipImg? api;
  String? _imageName;
  String? picture;
  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/credentials.json').then((json) {
      api = CloudApiSlipImg(json);
    });
    pickerDate = DateTime.now();
    time = TimeOfDay.now();
    readshopModel = widget.readshopModel;
    orderfoodModel = widget.orderfoodModel;
    orderfoodId = orderfoodModel!.id;
    print('orderfood id======>$orderfoodId');
  }

  // void _saveImage() async {
  //   // upload image to google cloud
  //   print('save image here');
  //   final response = await api!.save(_imageName!, _imageBytes!);
  //   print(response!.downloadLink);
  //   uploadImage();
  // }

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
        picture = _imageName;
        print('patg image = $_imageName');
      } else {
        print('No image selectd');
      }
    });
  }

  _pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
      initialDate: pickerDate!,
    );
    if (date != null) {
      setState(() {
        pickerDate = date;
        // print(date);
      });
    }
  }

  _pickTime() async {
    TimeOfDay? pickertime = await showTimePicker(
      context: context,
      initialTime: time!,
    );
    if (time != null) {
      setState(() {
        time = pickertime;
        time.toString().substring(10, 15);
        // print('time if ==> $time');
      });
    }
  }

// upload รูปภาพที่เราเลือกจะupload
  Future<Null> uploadSlip() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? customerId = preferences.getString('customerId');
    var url =
        '${Myconstant().domain_00webhost}/addSlipPayment.php?isAdd=true&customerId=$customerId&id=$orderfoodId&paymentDate=$pickerDate&paymentTime=$time&picture=$_imageName';
    await Dio().get(url).then((value) {
      if (value.statusCode == 200) {
        print(('completed slip'));
        //Navigator.pop(context);
      }
    });
  }

  uploadFileSlip() async {
    String uploadurl =
        "${Myconstant().domain_00webhostpic}/uploadslippayment.php"; //Edit path file upload_foodmenu_picture.php
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
      uploadSlip();
    } else {
      print("Error during connection to server.");
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kprimary,
          title: Text('Payment confirmation'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Container(
                  width: 350,
                  height: 370,
                  decoration: ShapeDecoration(
                      color: ksecondary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [MyStyle().showheadText('Upload Receipt')],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 120,
                        height: 150,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black, width: 4)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context) =>
                                            SingleChildScrollView(
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
                                                TextButton(
                                                  onPressed: () => chooseImage(
                                                      ImageSource.camera),
                                                  child: Text('Camera',
                                                      style: GoogleFonts.lato(
                                                          fontSize: 20,
                                                          color: Colors.black)),
                                                ),
                                                Divider(
                                                  height: 5,
                                                  color: Colors.grey,
                                                ),
                                                TextButton(
                                                  onPressed: () => chooseImage(
                                                      ImageSource.gallery),
                                                  child: Text('Photos',
                                                      style: GoogleFonts.lato(
                                                          fontSize: 20,
                                                          color: Colors.black)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                      );
                                    },
                                    child: _imageBytes == null
                                        ? Icon(
                                            Icons.add_photo_alternate_rounded,
                                            color: Colors.black,
                                            size: 60,
                                          )
                                        : Container(
                                            width: 80,
                                            height: 100,
                                            child: Image.memory(
                                              _imageBytes!,
                                              fit: BoxFit.cover,
                                            ),
                                          )),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black, width: 4)),
                        child: ListTile(
                          title: Text(
                              "Date  ${pickerDate!.day}/${pickerDate!.month}/${pickerDate!.year}"),
                          trailing: Icon(Icons.keyboard_arrow_down),
                          onTap: _pickDate,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black, width: 4)),
                        child: ListTile(
                          title: Text("Time  ${time!.hour}:${time!.minute}"),
                          trailing: Icon(Icons.keyboard_arrow_down),
                          onTap: _pickTime,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
                width: 200,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20)))),
                    onPressed: () {
                      if (_imageBytes == null) {
                        normalDialog(context, 'Please select a picture');
                      } else {
                        uploadFileSlip();
                        showDialog(
                            context: context,
                            builder: (context) => SimpleDialog(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text('Upload Receipt success'),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                              width: 80,
                                              height: 80,
                                              child: Image.asset(
                                                'assets/images/transfer.png',
                                                fit: BoxFit.cover,
                                              )),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextButton(
                                                onPressed: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MyBooking())),
                                                child: Icon(
                                                  Icons.check_circle,
                                                  color: Colors.green,
                                                  size: 30,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ));
                      }
                    },
                    child: Text('Submit')))
          ],
        ));
  }
}
