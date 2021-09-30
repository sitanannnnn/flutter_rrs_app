import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/dashboard/my_booking.dart';
import 'package:flutter_rrs_app/model/orderfood_model.dart';

import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/page/home_page.dart';
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
  File? file;
  @override
  void initState() {
    super.initState();
    pickerDate = DateTime.now();
    time = TimeOfDay.now();
    readshopModel = widget.readshopModel;
    orderfoodModel = widget.orderfoodModel;
    orderfoodId = orderfoodModel!.id;
    print('orderfood id======>$orderfoodId');
  }

  //เลือกรูปภาพที่ต้องการ
  Future<Null> chooseImage(ImageSource source) async {
    try {
      var result = await ImagePicker()
          .getImage(source: source, maxHeight: 100.0, maxWidth: 100.0);
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
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
  Future<Null> uploadImage() async {
    Random random = Random();
    int image = random.nextInt(1000000);
    String? nameImage = 'slip$image.jpg';
    // print('nameImage =$nameImage,pathImage =${file!.path}');
    String? url = '${Myconstant().domain}/saveSlip.php';

    try {
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameImage);
      FormData formData = FormData.fromMap(map);
      await Dio().post(url, data: formData).then((value) async {
        String picture = '/Slip/$nameImage';
        print('urlImage =${Myconstant().domain}$picture');
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String? customerId = preferences.getString('customerId');
        var url =
            '${Myconstant().domain}/addSlipPayment.php?isAdd=true&customerId=$customerId&id=$orderfoodId&paymentDate=$pickerDate&paymentTime=$time&picture=$picture';
        await Dio().get(url).then((value) => Fluttertoast.showToast(
            msg: 'Up load complete',
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: kprimary,
            textColor: Colors.white,
            fontSize: 16.0));
      });
    } catch (e) {}
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
                                                Text('Edit Profile Picture',
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.lato(
                                                        fontSize: 20)),
                                                Divider(
                                                  height: 5,
                                                  color: Colors.grey,
                                                ),
                                                TextButton(
                                                    onPressed: () =>
                                                        chooseImage(
                                                            ImageSource.camera),
                                                    child: Text('Camera',
                                                        style: GoogleFonts.lato(
                                                            fontSize: 20,
                                                            color:
                                                                Colors.black))),
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
                                    child: file == null
                                        ? Icon(
                                            Icons.add_photo_alternate_rounded,
                                            color: Colors.black,
                                            size: 60,
                                          )
                                        : Image.file(file!)),
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
                        primary: kprimary,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20)))),
                    onPressed: () {
                      if (file == null) {
                        normalDialog(context, 'Please select a picture');
                      } else {
                        uploadImage();
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
                                                onPressed: () =>
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                MyBooking())),
                                                child: Icon(
                                                  Icons.check_circle,
                                                  color: kprimary,
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
