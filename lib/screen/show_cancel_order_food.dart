import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/orderfood_model.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/model/reservation_model.dart';
import 'package:flutter_rrs_app/screen/booking_detail_orderfood.dart';
import 'package:flutter_rrs_app/screen/screen_detail/detail_orderfood.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowCancelOrderFood extends StatefulWidget {
  ShowCancelOrderFood({
    Key? key,
  }) : super(key: key);
  @override
  _ShowCancelOrderFoodState createState() => _ShowCancelOrderFoodState();
}

class _ShowCancelOrderFoodState extends State<ShowCancelOrderFood> {
  List<OrderfoodModel> orderfoodModels = [];
  String? customerId,
      name,
      reservationId,
      phonenumber,
      orderfoodTime,
      orderfoodid,
      orderfoodStatus,
      orderfoodReasonCancelStatus;
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
        '${Myconstant().domain}/my_login_rrs/getOrderfoodWherecustomerIdAndCancelOrderfoodStatus.php?isAdd=true&customerId=$customerId&reservationId=$reservationId&orderfoodStatus=$orderfoodStatus';
    Response response = await Dio().get(url);
    // print('res==> $response');
    var result = json.decode(response.data);
    // print('result= $result');
    for (var map in result) {
      OrderfoodModel orderfoodModel = OrderfoodModel.fromJson(map);
      setState(() {
        orderfoodModels.add(orderfoodModel);
        orderfoodid = orderfoodModel.id;
      });
    }
  }

  Widget build(BuildContext context) {
    return orderfoodModels.length == 0
        ? Center(child: MyStyle().showheadText('not have order food'))
        : ListView.builder(
            itemCount: orderfoodModels.length,
            itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    print('onclick ==> ${orderfoodModels[index].id}');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailOrderfood(
                                  orderfoodModel: orderfoodModels[index],
                                )));
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
                              height: MediaQuery.of(context).size.width * 0.4,
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
                                    height:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            // mainAxisAlignment:
                                            //     MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                orderfoodModels[index]
                                                    .restaurantNameshop!,
                                                style: GoogleFonts.lato(
                                                    fontSize: 20),
                                              )
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
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                                orderfoodModels[index]
                                                    .orderfoodStatus!,
                                                style: GoogleFonts.lato(
                                                    fontSize: 18,
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                                width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.5 -
                                                    7.0,
                                                child: Text(
                                                    orderfoodModels[index]
                                                        .orderfoodReasonCancelStatus!,
                                                    style: GoogleFonts.lato(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.bold))),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                        // showImage(context, index)
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
