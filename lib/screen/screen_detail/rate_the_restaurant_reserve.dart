import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_rrs_app/dashboard/my_booking.dart';
import 'package:flutter_rrs_app/model/detail_reservation.dart';
import 'package:flutter_rrs_app/model/orderfood_model.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/model/reservation_model.dart';
import 'package:flutter_rrs_app/model/table_model.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:flutter_rrs_app/utility/normal_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RateTheRestaurantReserve extends StatefulWidget {
  final ReservationModel reservationModel;
  const RateTheRestaurantReserve({
    Key? key,
    required this.reservationModel,
  }) : super(key: key);
  @override
  _RateTheRestaurantReserveState createState() =>
      _RateTheRestaurantReserveState();
}

class _RateTheRestaurantReserveState extends State<RateTheRestaurantReserve> {
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
      table,
      opinion,
      restaurantId;
  double rating = 0;
  @override
  void initState() {
    super.initState();
    reservationModel = widget.reservationModel;
    reservationId = reservationModel!.reservationId!;
    orderfoodId = reservationModel!.orderfoodId;
    restaurantId = reservationModel!.restaurantId;
    restaurantNameshop = reservationModel!.restaurantNameshop;
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
        '${Myconstant().domain}/getOrderfoodWherecustomerIdandOrderfoodId.php?isAdd=true&id=$orderfoodId&customerId=$customerId';
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
        '${Myconstant().domain}/getReservationWherecustomerId.php?isAdd=true&customerId=$customerId&reservationId=$reservationId';
    Response response = await Dio().get(url);
    // print('res = $response');
    if (response.toString() != 'null') {
      var result = json.decode(response.data);
      print('result= $result');
      for (var map in result) {
        DetailReservationModel detailreservationModel =
            DetailReservationModel.fromJson(map);
        print("reservation==> $reservationModel ");
        setState(() {
          detailreservationModels.add(detailreservationModel);
        });
      }
    }
  }

  //function บันทึกการรีวิวร้านอาหาร orderfood
  Future<Null> recordReviewOrderfood() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? customerId = preferences.getString("customerId");
    var url =
        '${Myconstant().domain}/addReview_restaurant.php?isAdd=true&restaurantId=$restaurantId&restaurantNameshop=$restaurantNameshop&customerId=$customerId&reservationId=$reservationId&orderfoodId=$orderfoodId&rate=$rating&opinion=$opinion';
    try {
      Response response = await Dio().get(url);
      // print('res = $response');
      if (response.toString() == 'true') {
        Fluttertoast.showToast(
            msg: 'Rated',
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: kprimary,
            textColor: Colors.white,
            fontSize: 16.0);
        // Navigator.pop(context);x
      } else {
        normalDialog(context, 'Please try again');
      }
    } catch (e) {}
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kprimary,
          title: Text('table and order food detail'),
        ),
        body: buildcontext());
  }

  Widget buildcontext() => ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: detailreservationModels.length,
      itemBuilder: (context, index) => Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                detailreservationModels[index].restaurantNameshop!,
                style: GoogleFonts.lato(fontSize: 25),
              ),
              SizedBox(
                height: 20,
              ),
              buildinformationCustomer(),
              SizedBox(
                height: 20,
              ),
              buildReservationTable(index),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  detailreservationModels[index].orderfoodId == "0"
                      ? Text('')
                      : buildfoodorder(index),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              buildReviewRestaurant(),
              SizedBox(
                height: 10,
              ),
              Container(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: kprimary,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                      onPressed: () {
                        recordReviewOrderfood();
                        Navigator.pop(context);
                      },
                      child: Text('Submit')))
            ],
          ));
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

  Container buildReviewRestaurant() {
    return Container(
      width: 350,
      height: 280,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kprimary, width: 2)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Rate the restaurant',
                    style: GoogleFonts.lato(fontSize: 20)),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RatingBar.builder(
                updateOnDrag: true,
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star_rounded,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rate) {
                  setState(() {
                    rating = rate;
                    print('Rating is $rating');
                  });
                },
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Review the service the restaurant',
                    style: GoogleFonts.lato(fontSize: 20))
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter comments',
                labelText: 'Enter comments',
              ),
              onChanged: (val) => opinion = val,
            ),
          ),
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

//เเสดงข้อมูลการจองโต๊ะ
  Container buildReservationTable(int index) {
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
                    Text(detailreservationModels[index].reservationDate!,
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
                    Text(detailreservationModels[index].reservationTime!)
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
                    Text(detailreservationModels[index].numberOfGueste!,
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
                      'table No. ${detailreservationModels[index].tableResId} ',
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
}
