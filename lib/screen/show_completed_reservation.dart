import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/model/reservation_model.dart';
import 'package:flutter_rrs_app/model/review_model.dart';
import 'package:flutter_rrs_app/screen/screen_detail/detail_table_orderfood.dart';
import 'package:flutter_rrs_app/screen/screen_detail/rate_the_restaurant_reserve.dart';
import 'package:flutter_rrs_app/screen/show_restaurant.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:flutter_rrs_app/utility/normal_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowCompletedTableReservation extends StatefulWidget {
  final ReadshopModel readshopModel;
  ShowCompletedTableReservation({
    Key? key,
    required this.readshopModel,
  }) : super(key: key);
  @override
  _ShowCompletedTableReservationState createState() =>
      _ShowCompletedTableReservationState();
}

class _ShowCompletedTableReservationState
    extends State<ShowCompletedTableReservation> {
  ReadshopModel? readshopModel;
  List<ReservationModel> reservationModels = [];
  List<ReadshopModel> readshopModels = [];
  List<ReviewModel> reviewModels = [];
  String? customerId, restaurantId, reservationId, reviewId;
  @override
  void initState() {
    super.initState();
    readReservation().then((value) => readShop());
  }

//อ่านข้อมูลรายการจองโต๊ะจากฐานข้อมูล
  Future<Null> readReservation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? customerId = preferences.getString("customerId");
    String url =
        '${Myconstant().domain}/getReservationWherecustomerIdAndReservationStatusCompleted.php?isAdd=true&customerId=$customerId&reservationStatus=completed';
    Response response = await Dio().get(url);
    //print('res==> $response');
    var result = json.decode(response.data);
    //print('result= $result');
    for (var map in result) {
      ReservationModel reservationModel = ReservationModel.fromJson(map);
      setState(() {
        reservationModels.add(reservationModel);
        // print('lenght===>${reservationModels.length}');
      });
    }
  }

  //function อ่านค่าร้านอาหารที่มีอยูในฐานข้อมูล
  Future<Null> readShop() async {
    for (var index = 0; index < reservationModels.length; index++) {
      restaurantId = reservationModels[index].restaurantId;
      String url =
          '${Myconstant().domain}/getRestaurantCom.php?isAdd=true&chooseType=Shop&restaurantId=$restaurantId';
      await Dio().get(url).then((value) {
        //print('value=$value');
        var result = json.decode(value.data);

        for (var map in result) {
          ReadshopModel model = ReadshopModel.fromJson(map);

          String? NameShop = model.restaurantNameshop;
          if (NameShop!.isNotEmpty) {
            print('NameShop =${model.restaurantNameshop}');

            setState(() {
              readshopModels.add(model);
            });
          }
        }
      });
    }
  }

  Widget build(BuildContext context) {
    return reservationModels.length == 0
        ? Center(child: MyStyle().showheadText('not have reservation'))
        : ListView.builder(
            itemCount: reservationModels.length,
            itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    print(
                        'onclick ==> ${reservationModels[index].reservationId}');
                    reservationModels[index].reviewId == null
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RateTheRestaurantReserve(
                                    reservationModel:
                                        reservationModels[index])))
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShowRestaurant(
                                    readshopModel: readshopModels[index])));
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
                              height: MediaQuery.of(context).size.width * 0.42,
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
                                        0.45,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            // mainAxisAlignment:
                                            //     MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                reservationModels[index]
                                                    .restaurantNameshop!,
                                                style: GoogleFonts.lato(
                                                    fontSize: 20),
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Text(
                                                  reservationModels[index]
                                                      .reservationStatus!,
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
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.today_rounded,
                                                  color: kprimary,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                    reservationModels[index]
                                                        .reservationDate!,
                                                    style: GoogleFonts.lato())
                                              ],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons
                                                      .access_time_filled_outlined,
                                                  color: kprimary,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                    reservationModels[index]
                                                        .reservationTime
                                                        .toString()
                                                        .substring(10, 15),
                                                    style: GoogleFonts.lato())
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.people_alt_sharp,
                                                  color: kprimary,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                    reservationModels[index]
                                                        .numberOfGueste!,
                                                    style: GoogleFonts.lato())
                                              ],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.event_seat_rounded,
                                                  color: kprimary,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                    reservationModels[index]
                                                        .tableResId!,
                                                    style: GoogleFonts.lato())
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Row(
                                              children: [
                                                reservationModels[index]
                                                            .orderfoodId ==
                                                        'Null'
                                                    ? Text("")
                                                    : Row(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons.dining,
                                                                color: kprimary,
                                                              )
                                                            ],
                                                          ),
                                                          Text('Pre-order food',
                                                              style: GoogleFonts
                                                                  .lato()),
                                                        ],
                                                      )
                                              ],
                                            )
                                          ],
                                        ),
                                        reservationModels[index].reviewId ==
                                                null
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    height: 20,
                                                    child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                            primary:
                                                                Colors.orange,
                                                            onPrimary:
                                                                Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5)))),
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      RateTheRestaurantReserve(
                                                                          reservationModel:
                                                                              reservationModels[index])));
                                                        },
                                                        child: Text('Rate')),
                                                  )
                                                ],
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    height: 20,
                                                    child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                            primary:
                                                                Colors.orange,
                                                            onPrimary:
                                                                Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5)))),
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      ShowRestaurant(
                                                                          readshopModel:
                                                                              readshopModels[index])));
                                                        },
                                                        child: Text(
                                                            'Reserve again')),
                                                  )
                                                ],
                                              )
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

  Padding showImage(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.2,
        height: MediaQuery.of(context).size.width * 0.3,
        child: Image.asset('assets/images/dinner-table.png'),
      ),
    );
  }
}
