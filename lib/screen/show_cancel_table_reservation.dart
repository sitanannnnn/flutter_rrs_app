import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/model/reservation_model.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowCancelTableReservation extends StatefulWidget {
  ShowCancelTableReservation({
    Key? key,
  }) : super(key: key);
  @override
  _ShowCancelTableReservationState createState() =>
      _ShowCancelTableReservationState();
}

class _ShowCancelTableReservationState
    extends State<ShowCancelTableReservation> {
  List<ReservationModel> reservationModels = [];
  String? customerId;
  @override
  void initState() {
    super.initState();
    readReservation();
  }

//อ่านข้อมูลรายการจองโต๊ะจากฐานข้อมูล
  Future<Null> readReservation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? customerId = preferences.getString("customerId");
    String url =
        '${Myconstant().domain}/my_login_rrs/getReservationWherecustomerIdAndReservationStatusCancel.php?isAdd=true&customerId=$customerId&reservationStatus=cancel';
    Response response = await Dio().get(url);
    // print('res==> $response');
    var result = json.decode(response.data);
    // print('result= $result');
    for (var map in result) {
      ReservationModel reservationModel = ReservationModel.fromJson(map);
      setState(() {
        reservationModels.add(reservationModel);
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
                    print('onclick ==> $index');
                  },
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
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
                                                reservationModels[index]
                                                    .restaurantNameshop!,
                                                style: GoogleFonts.lato(
                                                    fontSize: 20),
                                              )
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                    reservationModels[index]
                                                        .reservationStatus!,
                                                    style: GoogleFonts.lato(
                                                        fontSize: 18,
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.bold))
                                              ],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.5 -
                                                            7.0,
                                                    child: Text(
                                                        reservationModels[index]
                                                            .reservationReasonCancelStatus!,
                                                        style: GoogleFonts.lato(
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
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
