import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/dashboard/my_booking.dart';
import 'package:flutter_rrs_app/model/orderfood_model.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/model/reservation_model.dart';
import 'package:flutter_rrs_app/model/table_model.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:flutter_rrs_app/utility/normal_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingTailTableOrderfood extends StatefulWidget {
  final ReadshopModel readshopModel;
  final TableModel tableModel;
  final String choosevalue;
  final String date;
  final String timeFormt, orderfoodDateTime;
  const BookingTailTableOrderfood({
    Key? key,
    required this.readshopModel,
    required this.date,
    required this.choosevalue,
    required this.timeFormt,
    required this.tableModel,
    required this.orderfoodDateTime,
  }) : super(key: key);
  @override
  _BookingTailTableOrderfoodState createState() =>
      _BookingTailTableOrderfoodState();
}

class _BookingTailTableOrderfoodState extends State<BookingTailTableOrderfood> {
  ReadshopModel? readshopModel;
  TableModel? tableModel;
  // bool statusOrder = true;
  List<ReservationModel> reservationModels = [];
  List<OrderfoodModel> orderfoodModels = [];
  List<List<String>> listMenufoods = [];
  List<String> menufoods = [];
  List<List<String>> listPrices = [];
  List<List<String>> listAmounts = [];
  List<List<String>> listnetPrices = [];
  String? name, email, phonenumber;
  String? customerId,
      restaurantNameshop,
      reservationId,
      numberOfGueste,
      reservationDate,
      reservationTime,
      dateof,
      timeof,
      table,
      orderfoodDateTime,
      orderfoodId;
  @override
  void initState() {
    super.initState();
    readshopModel = widget.readshopModel;
    tableModel = widget.tableModel;
    reservationDate = widget.date;
    reservationTime = widget.timeFormt;
    numberOfGueste = widget.choosevalue;
    orderfoodDateTime = widget.orderfoodDateTime;
    readOrderfood();
    readReservation();
    findUser();
    setState(() {
      dateof = reservationDate.toString().substring(0, 10);
    });
    setState(() {
      timeof = reservationTime.toString().substring(10, 15);
    });
  }

//function ค้นหาuser
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {});
    name = preferences.getString('name');
    email = preferences.getString('email');
    phonenumber = preferences.getString('phonenumber');
    customerId = preferences.getString('customerId');
  }

//function อ่านค่าของรายการสั่งอาหารล่วงหน้า ที่ customerId,orderfoodDateTime
  Future<Null> readOrderfood() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? customerId = preferences.getString("customerId");
    String? orderTime = orderfoodDateTime.toString().substring(0, 19);
    orderfoodDateTime = widget.orderfoodDateTime;
    String? url =
        '${Myconstant().domain}/my_login_rrs/getOrderfoodWherecustomerIdandDateTime.php?isAdd=true&customerId=$customerId&orderfoodDateTime=$orderTime';
    Response response = await Dio().get(url);
    // print('res==> $response');
    if (response.toString() != 'null') {
      var result = json.decode(response.data);

      for (var map in result) {
        print('result= $result');
        OrderfoodModel orderfoodModel = OrderfoodModel.fromJson(map);
        // print('orderfood ===> $orderfoodModel');
        // String orderfooddetail = jsonEncode(orderfoodModel.foodmenuName);
        // print('ordercode ==>${orderfooddetail.length}');
        menufoods = changeArray(orderfoodModel.foodmenuName!);
        List<String> prices = changeArray(orderfoodModel.foodmenuPrice!);
        List<String> amounts = changeArray(orderfoodModel.amount!);
        List<String> netPrices = changeArray(orderfoodModel.netPrice!);

        print(' lenght menu ==>${menufoods.length}');
        setState(() {
          orderfoodModels.add(orderfoodModel);
          print('menufood ====>$menufoods');
          orderfoodId = orderfoodModel.id;
          print('orderfood id ==> $orderfoodId');
          listMenufoods.add(menufoods);
          print(' list menu foos $listMenufoods');
          print('lenght menufood ==>${listMenufoods.length}');

          // listPrices.add(prices);
          listAmounts.add(amounts);
          listnetPrices.add(netPrices);
        });
      }
    }
  }

//function เปลี่ยนarray
  List<String> changeArray(String string) {
    List<String> list = [];
    String myString = string.substring(1, string.length - 1);
    print('myString =$myString');
    list = myString.split(',');
    int index = 0;
    for (String string in list) {
      list[index] = string.trim();
      index++;
    }
    return list;
  }

//function อ่านค่าของรายการจองจาก customerId,reservationDate ,reservationTime
  Future<Null> readReservation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? customerId = preferences.getString("customerId");
    var url =
        '${Myconstant().domain}/my_login_rrs/getReservation.php?isAdd=true&customerId=$customerId&reservationDate=$dateof&reservationTime=$reservationTime';
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
          reservationId = reservationModel.reservationId;
          print('reservationId ==> $reservationId');
        });
      }
    }
  }

//บันทึกค่า  reservationId ไปที่ table order_food
  Future<Null> editOrderfoodMySQL() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? customerId = preferences.getString("customerId");
    print('CustomerId is =$customerId');

    String? url =
        '${Myconstant().domain}/my_login_rrs/addReservationIdWhereOrder_food.php?isAdd=true&id=$orderfoodId&reservationId=$reservationId';
    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'failed try again');
      }
    });
  }

  //บันทึกค่า  id(orderfoodId) ไปที่ table table_reservation
  Future<Null> editTableRservationMySQL() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? customerId = preferences.getString("customerId");
    print('CustomerId is =$customerId');

    String? url =
        '${Myconstant().domain}/my_login_rrs/addOrderfoodIdWheretable_reservation.php?isAdd=true&reservationId=$reservationId&id=$orderfoodId';
    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'failed try again');
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kprimary,
          title: Text('Booking details'),
        ),
        body: buildContent());
  }

  Widget buildContent() => ListView.builder(
        padding: EdgeInsets.all(16),
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: orderfoodModels.length,
        itemBuilder: (context, index) => Column(
          children: [
            MyStyle().showheadText(orderfoodModels[index].restaurantNameshop!),
            SizedBox(
              height: 10,
            ),
            buildinformationCustomer(),
            SizedBox(
              height: 10,
            ),
            buildtableReservationinformation(),
            SizedBox(
              height: 10,
            ),
            buildfoodorder(index),
            buttomConfirm(context)
          ],
        ),
      );

  Container buildfoodorder(int index) {
    return Container(
      width: 350,
      decoration: ShapeDecoration(
          color: ksecondary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'food order',
                  style: GoogleFonts.lato(fontSize: 20),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildListViewMenuFood(index),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Container buildtableReservationinformation() {
    return Container(
      width: 350,
      height: 250,
      decoration: ShapeDecoration(
          color: ksecondary,
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
                    Text(
                      dateof!,
                      style: GoogleFonts.lato(fontSize: 15),
                    )
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_filled_outlined,
                      size: 35,
                    ),
                    Text(
                      timeof!,
                      style: GoogleFonts.lato(fontSize: 15),
                    )
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.people_alt_sharp,
                      size: 35,
                    ),
                    Text(
                      numberOfGueste!,
                      style: GoogleFonts.lato(fontSize: 15),
                    )
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_pin,
                      size: 35,
                    ),
                    Text(
                      '${readshopModel!.restaurantBranch}',
                      style: GoogleFonts.lato(fontSize: 15),
                    )
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.event_seat_rounded,
                      size: 35,
                    ),
                    Text(
                      'table No. ${tableModel!.tableResId} ',
                      style: GoogleFonts.lato(fontSize: 15),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildinformationCustomer() {
    return Container(
      width: 350,
      height: 120,
      decoration: ShapeDecoration(
          color: ksecondary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
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

  Container buttomConfirm(BuildContext context) {
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
                  primary: kprimary,
                  onPrimary: Colors.white,
                ),
                onPressed: () {
                  //เพิ่ม reservationId ไปที่ table order_food
                  editOrderfoodMySQL();
                  //เพิ่ม id(orderfoodId) ไปที่ table tacle_reservation
                  editTableRservationMySQL();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MyBooking()));
                },
                child: Text('Confirm')),
          ),
        ],
      ),
    );
  }

// //เเสดงรายละเอียดเมนูอาหารที่สั่ง
// //listviewอยู่ในlistview
  ListView buildListViewMenuFood(int index) => ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: menufoods.length,
      itemBuilder: (context, index2) => Row(
            children: [
              Expanded(flex: 3, child: Text(listMenufoods[index][index2])),
              Expanded(flex: 1, child: Text(listAmounts[index][index2])),
              // Expanded(flex: 1, child: Text(listPrices[index][index2])),
              Expanded(flex: 1, child: Text(listnetPrices[index][index2]))
            ],
          ));
}
