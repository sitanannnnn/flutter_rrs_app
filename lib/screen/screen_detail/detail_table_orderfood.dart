import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/dashboard/my_booking.dart';
import 'package:flutter_rrs_app/model/detail_reservation.dart';
import 'package:flutter_rrs_app/model/orderfood_model.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/model/reservation_model.dart';
import 'package:flutter_rrs_app/model/table_model.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailTableOrderfood extends StatefulWidget {
  final ReservationModel reservationModel;
  const DetailTableOrderfood({
    Key? key,
    required this.reservationModel,
  }) : super(key: key);
  @override
  _DetailTableOrderfoodState createState() => _DetailTableOrderfoodState();
}

class _DetailTableOrderfoodState extends State<DetailTableOrderfood> {
  ReservationModel? reservationModel;
  List<DetailReservationModel> detailreservationModels = [];
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
      orderfoodId,
      dateof,
      timeof,
      table;
  @override
  void initState() {
    super.initState();
    reservationModel = widget.reservationModel;
    reservationId = reservationModel!.reservationId!;
    orderfoodId = reservationModel!.orderfoodId;
    print('orderfoods Id ===> $orderfoodId');
    findUser();
    readReservation();
    readOrderfood();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString('name');
      email = preferences.getString('email');
      phonenumber = preferences.getString('phonenumber');
    });
  }

//function อ่านค่าของรายการสั่งอาหารล่วงหน้า ที่ customerId,orderfoodDateTime
  Future<Null> readOrderfood() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? customerId = preferences.getString("customerId");
    String? url =
        '${Myconstant().domain_00webhost}/getOrderfoodWherecustomerIdandOrderfoodId.php?isAdd=true&id=$orderfoodId&customerId=$customerId';
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

//อ่านค่าจาก table table_reservation ผ่าน customerId
  Future<Null> readReservation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? customerId = preferences.getString("customerId");
    print('reservationId ==> $reservationId');
    var url =
        '${Myconstant().domain_00webhost}/getReservationWherecustomerId.php?isAdd=true&customerId=$customerId&reservationId=$reservationId';
    Response response = await Dio().get(url);
    // print('res = $response');
    if (response.statusCode == 200) {
      var result = json.decode(response.data);
      print('result= $result');
      for (var map in result) {
        DetailReservationModel detailreservationModel =
            DetailReservationModel.fromJson(map);
        setState(() {
          detailreservationModels.add(detailreservationModel);
        });
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kprimary,
          title: Text('table and order food detail'),
        ),
        body: detailreservationModels.length == 0
            ? MyStyle().showProgrsee()
            : buildcontext());
  }

  Widget buildcontext() => ListView.builder(
      padding: EdgeInsets.all(16),
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: 1,
      itemBuilder: (context, index) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
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
                  height: 10,
                ),
                Text(
                  detailreservationModels[index].restaurantNameshop!,
                  style: GoogleFonts.lato(fontSize: 25),
                ),
                Divider(
                  thickness: 3,
                  color: Colors.grey[200],
                ),
                buildinformationCustomer(),
                Divider(
                  thickness: 3,
                  color: Colors.grey[200],
                ),
                buildReservationTable(index),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    detailreservationModels[index].orderfoodId == 'null'
                        ? Text('')
                        : buildfoodorder(index),
                  ],
                )
              ],
            ),
          ));
  Container buildfoodorder(int index) {
    return Container(
      width: 350,
      decoration: ShapeDecoration(
          // color: Colors.white,
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

//เเสดงรายละเอียดเมนูอาหารที่สั่ง
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
//เเสดงข้อมูลของลูกค้า
  Container buildinformationCustomer() {
    return Container(
      width: 350,
      height: 120,
      decoration: ShapeDecoration(
          // color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.account_box),
                MyStyle().showheadText('Customer information'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'name-last name : ',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                Text('$name')
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('phonenumber : ',
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      color: Colors.grey[600],
                    )),
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
          // color: Colors.white,
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
                    Icon(Icons.chair),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.today_rounded,
                      size: 35,
                      color: Colors.grey[600],
                    ),
                    Text(detailreservationModels[index].reservationDate!,
                        style: GoogleFonts.lato(fontSize: 15))
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.access_time_filled_outlined,
                      color: Colors.grey[600],
                      size: 35,
                    ),
                    Text(detailreservationModels[index]
                        .reservationTime
                        .toString()
                        .substring(0, 5))
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.people_alt_sharp,
                      color: Colors.grey[600],
                      size: 35,
                    ),
                    Text(detailreservationModels[index].numberOfGueste!,
                        style: GoogleFonts.lato(fontSize: 15))
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.event_seat_rounded,
                      color: Colors.grey[600],
                      size: 35,
                    ),
                    Text(
                      'table No. ${detailreservationModels[index].tableResId} ',
                      style: GoogleFonts.lato(fontSize: 15),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 300,
                      height: 150,
                      child: Image.network(
                        '${Myconstant().domain_tablePic}${detailreservationModels[index].tablePicture!}',
                        fit: BoxFit.cover,
                      ),
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
}
