import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/orderfood_model.dart';
import 'package:flutter_rrs_app/model/payment_model.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/screen/payment_confirmation.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentDetail extends StatefulWidget {
  final ReadshopModel? readshopModel;
  final PaymentModel paymentModel;
  final OrderfoodModel orderfoodModel;
  final String total;
  PaymentDetail(
      {Key? key,
      this.readshopModel,
      required this.total,
      required this.paymentModel,
      required this.orderfoodModel})
      : super(key: key);
  @override
  _PaymentDetailState createState() => _PaymentDetailState();
}

class _PaymentDetailState extends State<PaymentDetail> {
  ReadshopModel? readshopModel;
  OrderfoodModel? orderfoodModel;
  PaymentModel? paymentModel;
  String? restaurantId, total, sum;
  @override
  void initState() {
    super.initState();
    readshopModel = widget.readshopModel;
    orderfoodModel = widget.orderfoodModel;
    paymentModel = widget.paymentModel;
    total = widget.total;
    print('is total ==>$total');
    sum = total.toString().substring(1, total!.length - 1);
    print('sum==> $sum');
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kprimary,
          title: Text('Payment information'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Container(
                  width: 350,
                  height: 250,
                  decoration: ShapeDecoration(
                      color: ksecondary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Transaction amount',
                                    style: GoogleFonts.lato(fontSize: 18)),
                                Text(sum!,
                                    style: GoogleFonts.lato(fontSize: 18))
                              ],
                            ),
                            SizedBox(
                              height: 100,
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(paymentModel!.nameBank!,
                                          style:
                                              GoogleFonts.lato(fontSize: 18)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          'Account name : ${paymentModel!.accountName!} ',
                                          style:
                                              GoogleFonts.lato(fontSize: 18)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          'Account number : ${paymentModel!.accountNumber!}',
                                          style:
                                              GoogleFonts.lato(fontSize: 18)),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [],
                      )
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PaymentConfirmation(
                                    orderfoodModel: orderfoodModel!,
                                  )));
                    },
                    child: Text('Upload patment')))
          ],
        ));
  }
}
