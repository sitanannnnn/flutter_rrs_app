import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/dashboard/my_booking.dart';
import 'package:flutter_rrs_app/model/detailorderfood_model.dart';
import 'package:flutter_rrs_app/model/orderfood_model.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/screen/payment_method.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailOrderfood extends StatefulWidget {
  final OrderfoodModel orderfoodModel;
  const DetailOrderfood({
    Key? key,
    required this.orderfoodModel,
  }) : super(key: key);
  @override
  _DetailOrderfoodState createState() => _DetailOrderfoodState();
}

class _DetailOrderfoodState extends State<DetailOrderfood> {
  OrderfoodModel? orderfoodModel;
  String? orderfoodId, name, customerId, phonenumber;
  List<DetailorderfoodModel> detailorderfoodModels = [];
  List<List<String>> listMenufoods = [];
  List<String> menufoods = [];
  List<List<String>> listPrices = [];
  List<List<String>> listAmounts = [];
  List<List<String>> listnetPrices = [];
  List<int> totalInt = [];
  @override
  void initState() {
    super.initState();
    findUser();
    readOrderfood();
    orderfoodModel = widget.orderfoodModel;
    orderfoodId = orderfoodModel!.id;
    print('id orderfoof==>$orderfoodId');
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
        '${Myconstant().domain}/my_login_rrs/getOrderfoodWherecustomerIdandId.php?isAdd=true&customerId=$customerId&id=$orderfoodId';
    Response response = await Dio().get(url);
    print('res==> $response');
    if (response.toString() != 'null') {
      var result = json.decode(response.data);

      for (var map in result) {
        //print('result= $result');
        DetailorderfoodModel detailorderfoodModel =
            DetailorderfoodModel.fromJson(map);
        menufoods = changeArray(detailorderfoodModel.foodmenuName!);
        List<String> prices = changeArray(detailorderfoodModel.foodmenuPrice!);
        List<String> amounts = changeArray(detailorderfoodModel.amount!);
        List<String> netPrices = changeArray(detailorderfoodModel.netPrice!);
        int total = 0;
        for (var string in netPrices) {
          total = total + int.parse(string.trim());
        }
        print('total==> $total');
        print(' lenght menu ==>${menufoods.length}');
        setState(() {
          detailorderfoodModels.add(detailorderfoodModel);
          listMenufoods.add(menufoods);
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
        itemCount: detailorderfoodModels.length,
        itemBuilder: (context, index) => Column(
          children: [
            MyStyle()
                .showheadText(detailorderfoodModels[index].restaurantNameshop!),
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
