import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:flutter_rrs_app/model/orderfood_model.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/screen/payment_method.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class BookingTailOrderfood extends StatefulWidget {
  final ReadshopModel readshopModel;
  final String orderfoodDateTime;
  const BookingTailOrderfood({
    Key? key,
    required this.readshopModel,
    required this.orderfoodDateTime,
  }) : super(key: key);
  @override
  _BookingTailOrderfoodState createState() => _BookingTailOrderfoodState();
}

class _BookingTailOrderfoodState extends State<BookingTailOrderfood> {
  ReadshopModel? readshopModel;
  var myFormat = NumberFormat("#,##0.00", "en_US");
  bool loadstatus = true;
  String? name,
      phonenumber,
      customerId,
      orderfoodDateTime,
      orderTime,
      orderfoodId;
  List<OrderfoodModel> orderfoodModels = [];
  List<List<String>> listMenufoods = [];
  List<String> menufoods = [];
  List<List<String>> listPrices = [];
  List<List<String>> listAmounts = [];
  List<List<String>> listnetPrices = [];
  List<int> totalInt = [];
  List<double> discountAmount = [];
  List<double> totalPrice = [];
  double totaldiscount = 0;

  @override
  void initState() {
    super.initState();
    readshopModel = widget.readshopModel;
    orderfoodDateTime = widget.orderfoodDateTime;

    findUser();
    readOrderfood();
  }

  //function ค้นหาuser
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {});
    name = preferences.getString('name');
    phonenumber = preferences.getString('phonenumber');
    customerId = preferences.getString('customerId');
  }

//function อ่านค่าของรายการสั่งอาหารล่วงหน้า ที่ customerId,orderfoodDateTime
  Future<Null> readOrderfood() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? customerId = preferences.getString("customerId");
    //print('customerId========>$customerId');
    print('order time => $orderfoodDateTime');
    String? url =
        '${Myconstant().domain}/getOrderfoodWherecustomerIdandDateTime.php?isAdd=true&customerId=$customerId&orderfoodDateTime=$orderfoodDateTime';
    Response response = await Dio().get(url);
    print('res?==> $response');
    if (response.toString() != 'null') {
      var result = json.decode(response.data);

      for (var map in result) {
        OrderfoodModel orderfoodModel = OrderfoodModel.fromJson(map);
        menufoods = changeArray(orderfoodModel.foodmenuName!);
        List<String> amounts = changeArray(orderfoodModel.amount!);
        List<String> netPrices = changeArray(orderfoodModel.netPrice!);
        int total = 0;
        String? caldiscount = orderfoodModel.promotionDiscount;
        int discount;
        caldiscount == null ? discount = 0 : discount = int.parse(caldiscount);
        double netTotal = 0;
        for (var string in netPrices) {
          //หาราคารวมไม่มีส่วนลด
          total = total + int.parse(string.trim());
          //หาราคาส่วนลด
          totaldiscount = (total * (discount / 100));
          print('total ==> $totaldiscount');
          //ราคาหักส่วนลด
          netTotal = (total - totaldiscount);
        }
        print('total==> $total');
        print(' lenght menu ==>${menufoods.length}');
        setState(() {
          orderfoodModels.add(orderfoodModel);
          orderfoodId = orderfoodModel.id;
          print('orderfood id ==> $orderfoodId');
          print('menufood ====>$menufoods');
          listMenufoods.add(menufoods);
          print(' list menu foos $listMenufoods');
          print('lenght menufood ==>${listMenufoods.length}');
          listAmounts.add(amounts);
          listnetPrices.add(netPrices);
          totalInt.add(total);
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

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kprimary,
          title: Text('order food detail'),
        ),
        body: orderfoodModels.length == 0
            ? MyStyle().showProgrsee()
            : SingleChildScrollView(child: buildContent()));
  }

//เเสดงชื่อร้านอาหาร ข้อมูลลูกค้า
  Widget buildContent() => ListView.builder(
        padding: EdgeInsets.all(16),
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: orderfoodModels.length,
        itemBuilder: (context, index) => Column(
          children: [
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
            MyStyle().showheadText(orderfoodModels[index].restaurantNameshop!),
            Divider(
              thickness: 3,
            ),
            buildinformationCustomer(),
            Divider(
              thickness: 3,
            ),
            buildfoodorder(index),
            buildtotal(index),
            Container(
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaymentMethod(
                                        readshopModel: readshopModel!,
                                        totalInt: '$totalInt',
                                        orderfoodModel: orderfoodModels[index],
                                      )));
                        },
                        child: Text('Confirm')),
                  ),
                ],
              ),
            )
          ],
        ),
      );
//เเสดงยอดรวมของอาหาร
  Widget buildtotal(int index) => Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Container(
              width: 350,
              decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total food price  ', style: GoogleFonts.lato()),
                        Row(
                          children: [
                            Text(
                              '${myFormat.format(int.parse(totalInt[index].toString()))} ',
                            ),
                            Text('K',
                                style: GoogleFonts.lato(
                                    decoration: TextDecoration.lineThrough))
                          ],
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Discount ', style: GoogleFonts.lato()),
                        orderfoodModels[index].promotionDiscount == null
                            ? Text('0%')
                            : Text(
                                '${orderfoodModels[index].promotionDiscount} %')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Discount amount', style: GoogleFonts.lato()),
                        orderfoodModels[index].promotionDiscount == null
                            ? Row(
                                children: [
                                  Text(' 0 '),
                                  Text('K',
                                      style: GoogleFonts.lato(
                                          decoration:
                                              TextDecoration.lineThrough))
                                ],
                              )
                            : Row(
                                children: [
                                  Text(
                                      '${myFormat.format((discountAmount[index]))}'),
                                  Text('K',
                                      style: GoogleFonts.lato(
                                          decoration:
                                              TextDecoration.lineThrough))
                                ],
                              )
                      ],
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total ', style: GoogleFonts.lato(fontSize: 18)),
                        orderfoodModels[index].promotionDiscount == null
                            ? Row(
                                children: [
                                  Text('${myFormat.format((totalInt[index]))}'),
                                  Text('K',
                                      style: GoogleFonts.lato(
                                          decoration:
                                              TextDecoration.lineThrough))
                                ],
                              )
                            : Row(
                                children: [
                                  Text(
                                      '${myFormat.format((totalPrice[index]))}'),
                                  Text('K',
                                      style: GoogleFonts.lato(
                                          decoration:
                                              TextDecoration.lineThrough))
                                ],
                              )
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Container()
            // Text('total ', style: GoogleFonts.lato(fontSize: 25)),
            //
          ],
        ),
      );
//เเสดงรายการเมนูอาหารที่สั่ง
  Container buildfoodorder(int index) {
    return Container(
      width: 350,
      decoration: ShapeDecoration(
          color: Colors.white,
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

//เเสดงข้อมูลลูกค้า
  Container buildinformationCustomer() {
    return Container(
      width: 350,
      height: 120,
      decoration: ShapeDecoration(
          color: Colors.white,
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

// //เเสดงรายละเอียดเมนูอาหารที่สั่ง
// //listviewอยู่ในlistview
  ListView buildListViewMenuFood(int index) => ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: menufoods.length,
      itemBuilder: (context, index2) => Column(
            children: [
              Row(
                children: [
                  Expanded(flex: 2, child: Text(listMenufoods[index][index2])),
                  Expanded(flex: 1, child: Text(listAmounts[index][index2])),
                  Expanded(
                      flex: 1,
                      child: Text(
                          '${myFormat.format(int.parse(listnetPrices[index][index2]))}')),
                ],
              ),
            ],
          ));
}
