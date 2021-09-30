import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/dashboard/my_booking.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/model/reservation_model.dart';
import 'package:flutter_rrs_app/model/table_model.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingTailTable extends StatefulWidget {
  final ReadshopModel readshopModel;

  final TableModel tableModel;
  final String choosevalue;
  final String date;
  final String timeFormt;
  const BookingTailTable({
    Key? key,
    required this.readshopModel,
    required this.date,
    required this.choosevalue,
    required this.timeFormt,
    required this.tableModel,
  }) : super(key: key);
  @override
  _BookingTailTableState createState() => _BookingTailTableState();
}

class _BookingTailTableState extends State<BookingTailTable> {
  ReadshopModel? readshopModel;
  TableModel? tableModel;
  List<ReservationModel> reservationModels = [];
  String? name, email, phonenumber;
  String? customerId,
      restaurantNameshop,
      reservationId,
      numberOfGueste,
      reservationDate,
      reservationTime,
      dateof,
      timeof,
      table;
  @override
  void initState() {
    super.initState();
    readshopModel = widget.readshopModel;
    tableModel = widget.tableModel;
    reservationDate = widget.date;
    reservationTime = widget.timeFormt;
    numberOfGueste = widget.choosevalue;
    print('date ==> $reservationDate');
    print('time ==> $reservationTime');

    findUser();
    readReservation();
    setState(() {
      dateof = reservationDate.toString().substring(0, 10);
      // print('dateof ==> $dateof');
    });
    setState(() {
      timeof = reservationTime.toString().substring(10, 15);
      print('timeof ==> $timeof');
    });
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString('name');
      email = preferences.getString('email');
      phonenumber = preferences.getString('phonenumber');
    });
  }

//อ่านค่าจาก table table_reservation ผ่าน customerId reservationDate reservationTime
  Future<Null> readReservation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? customerId = preferences.getString("customerId");
    var url =
        '${Myconstant().domain}/getReservation.php?isAdd=true&customerId=$customerId&reservationDate=$dateof&reservationTime=$reservationTime';
    Response response = await Dio().get(url);
    // print('res = $response');
    if (response.toString() != 'null') {
      var result = json.decode(response.data);
      print('result= $result');
      for (var map in result) {
        ReservationModel reservationModel = ReservationModel.fromJson(map);
        print("reservation==> $reservationModel ");
        setState(() {
          reservationModels.add(reservationModel);
        });
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kprimary,
          title: Text('Booking details'),
        ),
        body: ListView.builder(
            itemCount: reservationModels.length,
            itemBuilder: (context, index) => Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 80,
                      height: 80,
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/restaurant.png',
                            fit: BoxFit.cover,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      reservationModels[index].restaurantNameshop!,
                      style: GoogleFonts.lato(fontSize: 25),
                    ),
                    Divider(
                      thickness: 3,
                      endIndent: 16,
                      indent: 16,
                    ),
                    buildinformationCustomer(),
                    Divider(
                      thickness: 3,
                      endIndent: 16,
                      indent: 16,
                    ),
                    buildReservationTable(index),
                    buildBottomConfirm(context)
                  ],
                )));
  }

//ปุ่มกด confirm
  Container buildBottomConfirm(BuildContext context) {
    return Container(
      width: 250,
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 300,
            height: 40,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MyBooking()));
                },
                child: Text('Confirm')),
          ),
        ],
      ),
    );
  }

//เเสดงข้อมูลของลูกค้า
  Container buildinformationCustomer() {
    return Container(
      width: 350,
      height: 120,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyStyle().showheadText('Customer information'),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                Text(
                  'name-last name : ',
                  style: GoogleFonts.lato(fontSize: 18),
                ),
                Text('$name')
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                Text('phonenumber : ', style: GoogleFonts.lato(fontSize: 18)),
                Text('$phonenumber')
              ],
            ),
          ),
        ],
      ),
    );
  }

//เเสดงข้อมูลการจองโต๊ะ
  Container buildReservationTable(int index) {
    return Container(
      width: 350,
      decoration: ShapeDecoration(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Table reservation information',
                      style: GoogleFonts.lato(fontSize: 20),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.today_rounded,
                      size: 35,
                    ),
                    Text(reservationModels[index].reservationDate!,
                        style: GoogleFonts.lato(fontSize: 15))
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_filled_outlined,
                      size: 35,
                    ),
                    Text(timeof!)
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.people_alt_sharp,
                      size: 35,
                    ),
                    Text(reservationModels[index].numberOfGueste!,
                        style: GoogleFonts.lato(fontSize: 15))
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.event_seat_rounded,
                      size: 35,
                    ),
                    Text(
                      'table No. ${reservationModels[index].tableResId} ',
                      style: GoogleFonts.lato(fontSize: 15),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 300,
                      height: 150,
                      child: Image.network(
                        '${Myconstant().domain}${reservationModels[index].tablePicture!}',
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
