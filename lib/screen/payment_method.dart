import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/orderfood_model.dart';
import 'package:flutter_rrs_app/model/payment_model.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/screen/payment_detail.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentMethod extends StatefulWidget {
  final ReadshopModel? readshopModel;
  final OrderfoodModel orderfoodModel;
  final String totalInt;
  PaymentMethod(
      {Key? key,
      this.readshopModel,
      required this.totalInt,
      required this.orderfoodModel})
      : super(key: key);
  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  ReadshopModel? readshopModel;
  OrderfoodModel? orderfoodModel;
  String? restaurantId, total, sumPrice;
  List<PaymentModel> paymentModels = [];
  @override
  void initState() {
    super.initState();
    readshopModel = widget.readshopModel;
    orderfoodModel = widget.orderfoodModel;
    total = widget.totalInt;
    print('total==> $total');

    readPayment();
  }

  Future<Null> readPayment() async {
    restaurantId = readshopModel!.restaurantId;
    print('restautant id ==> $restaurantId');
    String url =
        '${Myconstant().domain}/my_login_rrs/getPaymentWhererestaurantId.php?isAdd=true&restaurantId=$restaurantId';
    Response response = await Dio().get(url);
    // print('res==> $response');
    var result = json.decode(response.data);
    // print('result= $result');
    for (var map in result) {
      PaymentModel paymentModel = PaymentModel.fromJson(map);
      setState(() {
        paymentModels.add(paymentModel);
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kprimary,
        title: Text('Payment method'),
      ),
      body: paymentModels.length == 0
          ? MyStyle().showProgrsee()
          : ListView.builder(
              itemCount: paymentModels.length,
              itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PaymentDetail(
                                    total: '$total',
                                    paymentModel: paymentModels[index],
                                    orderfoodModel: orderfoodModel!,
                                  )));
                      print('you choose');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 150,
                        decoration: ShapeDecoration(
                            color: ksecondary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: Row(
                          children: [
                            showFoodmenuImage(context, index),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: MediaQuery.of(context).size.width * 0.3,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        MyStyle()
                                            .showheadText('Account number ')
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4 -
                                                8.0,
                                            child: Text(
                                              paymentModels[index]
                                                  .accountNumber!,
                                              style: GoogleFonts.lato(
                                                  fontSize: 15),
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        MyStyle().showheadText('Account name ')
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4 -
                                                8.0,
                                            child: Text(
                                              paymentModels[index].accountName!,
                                              style: GoogleFonts.lato(
                                                  fontSize: 15),
                                            )),
                                      ],
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  )),
    );
  }

  Padding showFoodmenuImage(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.2,
        height: MediaQuery.of(context).size.width * 0.2,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(
              image: NetworkImage(
                '${Myconstant().domain}${paymentModels[index].accountPicture}',
              ),
              fit: BoxFit.cover,
            )),
      ),
    );
  }
}
