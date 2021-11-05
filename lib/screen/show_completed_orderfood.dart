import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/orderfood_model.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/model/reservation_model.dart';
import 'package:flutter_rrs_app/screen/booking_detail_orderfood.dart';
import 'package:flutter_rrs_app/screen/order_food.dart';
import 'package:flutter_rrs_app/screen/screen_detail/detail_orderfood.dart';
import 'package:flutter_rrs_app/screen/screen_detail/rate_the_restaurant_orderfood.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowCompletedOrderFood extends StatefulWidget {
  ShowCompletedOrderFood({
    Key? key,
  }) : super(key: key);
  @override
  _ShowCompletedOrderFoodState createState() => _ShowCompletedOrderFoodState();
}

class _ShowCompletedOrderFoodState extends State<ShowCompletedOrderFood> {
  List<OrderfoodModel> orderfoodModels = [];
  String? customerId,
      name,
      phonenumber,
      orderfoodTime,
      orderfoodid,
      orderfoodStatus,
      reservationId;
  @override
  void initState() {
    super.initState();
    readOrderfood();
    findUser();
  }

  //function ค้นหาuser
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    name = preferences.getString('name');
    phonenumber = preferences.getString('phonenumber');
    customerId = preferences.getString('customerId');
    print('name: $name');
    print('phonenumber: $phonenumber');
  }

//อ่านค่ารยการอาหารที่เราสั่งจากฐานข้อมูล
  Future<Null> readOrderfood() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? customerId = preferences.getString("customerId");
    String url =
        '${Myconstant().domain_00webhost}/getOrderfoodWherecustomerIdAndCompletedStatusOrderfoodStatus.php?isAdd=true&customerId=$customerId';
    Response response = await Dio().get(url);
    if (response.statusCode == 200) {
      // print('res==> $response');
      var result = json.decode(response.data);
      print('resultcompleted= $result');
      for (var map in result) {
        OrderfoodModel orderfoodModel = OrderfoodModel.fromJson(map);
        setState(() {
          orderfoodModels.add(orderfoodModel);
          orderfoodid = orderfoodModel.id;
        });
      }
    }
  }

  Widget build(BuildContext context) {
    return orderfoodModels.length == 0
        ? Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/order-now.png'),
                  MyStyle().showheadText('not have order food'),
                ],
              ),
            ),
          )
        : ListView.builder(
            itemCount: orderfoodModels.length,
            itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    print('onclick ==> ${orderfoodModels[index].id}');
                  },
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.90,
                              height: MediaQuery.of(context).size.width * 0.35,
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
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              margin: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  showImage(context, index),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    height: MediaQuery.of(context).size.width *
                                        0.35,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                orderfoodModels[index]
                                                    .restaurantNameshop!,
                                                style: GoogleFonts.lato(
                                                    fontSize: 20),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                  orderfoodModels[index]
                                                      .orderfoodStatus!,
                                                  style: GoogleFonts.lato(
                                                      fontSize: 16,
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Order food (pick up at the restaurant)',
                                              style: GoogleFonts.lato(
                                                  fontSize: 12),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'date to order ${orderfoodModels[index].orderfoodDateTime.toString().substring(0, 10)}',
                                              style: GoogleFonts.lato(
                                                  fontSize: 12),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'time to order ${orderfoodModels[index].orderfoodDateTime.toString().substring(11, 16)}',
                                              style: GoogleFonts.lato(
                                                  fontSize: 12),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 100,
                                                height: 20,
                                                child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        primary: Colors.red,
                                                        onPrimary: Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        15)))),
                                                    onPressed: () {
                                                      orderfoodModels[index]
                                                                  .reviewId ==
                                                              null
                                                          ? Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => RateTheRestaurantOrderfood(
                                                                      orderfoodModel:
                                                                          orderfoodModels[
                                                                              index])))
                                                          : showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) =>
                                                                      SimpleDialog(
                                                                        children: [
                                                                          Column(
                                                                            children: [
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Text('you have successfully rate', style: GoogleFonts.lato(fontSize: 20, color: Colors.black))
                                                                                ],
                                                                              ),
                                                                              ElevatedButton(
                                                                                  style: ElevatedButton.styleFrom(primary: Colors.green, onPrimary: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15)))),
                                                                                  onPressed: () {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Text('OK'))
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ));
                                                    },
                                                    child:
                                                        orderfoodModels[index]
                                                                    .reviewId ==
                                                                null
                                                            ? Text('Rate')
                                                            : Text('Rated')),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                width: 105,
                                                height: 20,
                                                child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        primary: Colors.red,
                                                        onPrimary: Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        15)))),
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => OrderFood(
                                                                  readshopModel:
                                                                      ReadshopModel(
                                                                          restaurantId:
                                                                              orderfoodModels[index].restaurantId))));
                                                    },
                                                    child: Text('order again')),
                                              )
                                            ],
                                          ),
                                        )
                                        // orderfoodModels[index].reviewId == null
                                        //     ? Row(
                                        //         mainAxisAlignment:
                                        //             MainAxisAlignment.end,
                                        //         children: [
                                        //           Container(
                                        //             height: 20,
                                        //             child: ElevatedButton(
                                        //                 style: ElevatedButton.styleFrom(
                                        //                     primary:
                                        //                         Colors.orange,
                                        //                     onPrimary:
                                        //                         Colors.white,
                                        //                     shape: RoundedRectangleBorder(
                                        //                         borderRadius: BorderRadius
                                        //                             .all(Radius
                                        //                                 .circular(
                                        //                                     5)))),
                                        //                 onPressed: () {
                                        //                   Navigator.push(
                                        //                       context,
                                        //                       MaterialPageRoute(
                                        //                           builder: (context) =>
                                        //                               RateTheRestaurantOrderfood(
                                        //                                   orderfoodModel:
                                        //                                       orderfoodModels[index])));
                                        //                 },
                                        //                 child: Text('Rate')),
                                        //           )
                                        //         ],
                                        //       )
                                        //     : Row(
                                        //         mainAxisAlignment:
                                        //             MainAxisAlignment.end,
                                        //         children: [
                                        //           Container(
                                        //             height: 20,
                                        //             child: ElevatedButton(
                                        //                 style: ElevatedButton.styleFrom(
                                        //                     primary:
                                        //                         Colors.orange,
                                        //                     onPrimary:
                                        //                         Colors.white,
                                        //                     shape: RoundedRectangleBorder(
                                        //                         borderRadius: BorderRadius
                                        //                             .all(Radius
                                        //                                 .circular(
                                        //                                     5)))),
                                        //                 onPressed: () {
                                        //                   Navigator.push(
                                        //                       context,
                                        //                       MaterialPageRoute(
                                        //                           builder: (context) =>
                                        //                               OrderFood(
                                        //                                   readshopModel:
                                        //                                       ReadshopModel(restaurantId: orderfoodModels[index].restaurantId))));
                                        //                 },
                                        //                 child: Text(
                                        //                     'Order again')),
                                        //           )
                                        //         ],
                                        //       ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ));
  }

//เเสดงรูปภาพที่เรากำหนด
  Padding showImage(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.2,
        height: MediaQuery.of(context).size.width * 0.3,
        child: Image.asset(
          'assets/images/bell.png',
        ),
      ),
    );
  }
}
