import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/dashboard/my_booking.dart';
import 'package:flutter_rrs_app/model/orderfood_model.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/screen/payment_method.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    readshopModel = widget.readshopModel;
    orderfoodDateTime = widget.orderfoodDateTime;
    print('order time => $orderfoodDateTime');
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
    String? url =
        '${Myconstant().domain}/my_login_rrs/getOrderfoodWherecustomerIdandDateTime.php?isAdd=true&customerId=$customerId&orderfoodDateTime=$orderfoodDateTime';
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
        int total = 0;
        for (var string in netPrices) {
          total = total + int.parse(string.trim());
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

          // listPrices.add(prices);
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
        body: SingleChildScrollView(child: buildContent()));
  }

//เเสดงชื่อร้านอาหาร ข้อมูลลูกค้า
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
            SizedBox(
              height: 20,
            ),
            buildfoodorder(index),
            SizedBox(
              height: 10,
            ),
            buildtotal(index),
            SizedBox(
              height: 80,
            ),
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
                          primary: kprimary,
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('total ', style: GoogleFonts.lato(fontSize: 25)),
                Text(
                  totalInt[index].toString(),
                  style: GoogleFonts.lato(fontSize: 20),
                )
              ],
            ),
          ],
        ),
      );
//เเสดงรายการเมนูอาหารที่สั่ง
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

//เเสดงข้อมูลลูกค้า
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
                  Expanded(flex: 3, child: Text(listMenufoods[index][index2])),
                  Expanded(flex: 1, child: Text(listAmounts[index][index2])),
                  Expanded(flex: 1, child: Text(listnetPrices[index][index2])),
                ],
              ),
            ],
          ));
}
