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
import 'package:intl/intl.dart';
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
  var myFormat = NumberFormat("#,##0.00", "en_US");

  String? orderfoodId, name, customerId, phonenumber;
  List<DetailorderfoodModel> detailorderfoodModels = [];
  List<List<String>> listMenufoods = [];
  List<String> menufoods = [];
  List<List<String>> listPrices = [];
  List<List<String>> listAmounts = [];
  List<List<String>> listnetPrices = [];
  List<int> totalInt = [];
  List<double> discountAmount = [];
  List<double> totalPrice = [];
  double totaldiscount = 0;
  double netTotal = 0;
  double vatTotal = 0;
  double netprice = 0;
  double netpricethb = 0;
  double netpriceusd = 0;
  double netpriceeur = 0;

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
        '${Myconstant().domain_00webhost}/getOrderfoodWherecustomerIdandId.php?isAdd=true&customerId=$customerId&id=$orderfoodId';
    Response response = await Dio().get(url);

    if (response.statusCode == 200) {
      var result = json.decode(response.data);
      print('res reservation==> $result');

      for (var map in result) {
        //print('result= $result');
        DetailorderfoodModel detailorderfoodModel =
            DetailorderfoodModel.fromJson(map);
        menufoods = changeArray(detailorderfoodModel.foodmenuName!);
        List<String> prices = changeArray(detailorderfoodModel.foodmenuPrice!);
        List<String> amounts = changeArray(detailorderfoodModel.amount!);
        List<String> netPrices = changeArray(detailorderfoodModel.netPrice!);
        String? caldiscount = detailorderfoodModel.promotionDiscount;
        int discount;
        //แปลงค่าให้เป็น int
        caldiscount == null ? discount = 0 : discount = int.parse(caldiscount);
        int total = 0;
        double netTotal = 0;
        String? ratethb = detailorderfoodModel.rate_thb;
        String? rateusd = detailorderfoodModel.rate_usd;
        String? rateeur = detailorderfoodModel.rate_eur;
        double rate_thb = double.parse(ratethb!);
        double rate_usd = double.parse(rateusd!);
        double rate_eur = double.parse(rateeur!);
        print('rate thb=>$rate_thb');
        //ใส่ค่า  % vat  ไว้ใน vat
        String? vat = detailorderfoodModel.vat;
        //แปลงค่าให้เป็น int
        int vatdiscount = int.parse(vat!);

        for (var string in netPrices) {
          total = total + int.parse(string.trim());
          //หาราคาส่วนลด
          totaldiscount = (total * (discount / 100));
          print('total discount ==> $totaldiscount');
          //ราคาหักส่วนลด
          netTotal = (total - totaldiscount);
          print('nettotal$netTotal');
          //ราคาvat
          vatTotal = (netTotal * (vatdiscount / 100));
          print('vat==> $vatTotal');
          //ราคาสุทธ์
          netprice = (netTotal + vatTotal);
          print('total==> $netprice');
          netpricethb = (netprice * rate_thb);
          netpriceusd = (netprice * rate_usd);
          netpriceeur = (netprice * rate_eur);
          print('thai baht =>$netpricethb');
        }

        print(detailorderfoodModel.promotionDiscount);
        setState(() {
          detailorderfoodModels.add(detailorderfoodModel);
          listMenufoods.add(menufoods);
          listAmounts.add(amounts);
          listnetPrices.add(netPrices);
          totalInt.add(total);
          discountAmount.add(totaldiscount);
          totalPrice.add(netTotal);
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
        body: detailorderfoodModels.length == 0
            ? MyStyle().showProgrsee()
            : buildContent());
  }

  //เเสดงชื่อร้านอาหาร ข้อมูลลูกค้า
  Widget buildContent() => ListView.builder(
        padding: EdgeInsets.all(16),
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: detailorderfoodModels.length,
        itemBuilder: (context, index) => Container(
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
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
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
              MyStyle().showheadText(
                  detailorderfoodModels[index].restaurantNameshop!),
              Divider(
                thickness: 3,
                color: Colors.grey[200],
              ),
              buildinformationCustomer(),
              Divider(
                thickness: 3,
                color: Colors.grey[200],
              ),
              buildfoodorder(index),
              Divider(
                thickness: 3,
                color: Colors.grey[200],
              ),
              buildtotal(index),
            ],
          ),
        ),
      );
//เเสดงยอดรวมของอาหาร
  Widget buildtotal(int index) => Column(
        children: [
          Container(
            width: 350,
            decoration: ShapeDecoration(
                // color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total money  ', style: GoogleFonts.lato()),
                      Text(
                        '${myFormat.format(int.parse(totalInt[index].toString()))} ',
                      ),
                    ],
                  ),
                  detailorderfoodModels[index].promotionDiscount == null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Discount ', style: GoogleFonts.lato()),
                            Text('0 %'),
                            Text('0.00')
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Discount ', style: GoogleFonts.lato()),
                            Text(
                                '${detailorderfoodModels[index].promotionDiscount} %'),
                            Text('${myFormat.format((totaldiscount))}'),
                          ],
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Amount after discount'),
                      Text('${myFormat.format((totalPrice[index]))}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Vat'),
                      Text('${detailorderfoodModels[index].vat} %',
                          style: GoogleFonts.lato()),
                      Text('${myFormat.format((vatTotal))}'),
                    ],
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total ', style: GoogleFonts.lato(fontSize: 18)),
                      Row(
                        children: [
                          Text('${myFormat.format((netprice))}'),
                          Text('KIP', style: GoogleFonts.lato())
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(' ', style: GoogleFonts.lato(fontSize: 18)),
                      Row(
                        children: [
                          Text('${myFormat.format((netpricethb))}'),
                          Text('THB', style: GoogleFonts.lato())
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(' ', style: GoogleFonts.lato(fontSize: 18)),
                      Row(
                        children: [
                          Text('${myFormat.format((netpriceusd))}'),
                          Text('USD', style: GoogleFonts.lato())
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(' ', style: GoogleFonts.lato(fontSize: 18)),
                      Row(
                        children: [
                          Text('${myFormat.format((netpriceeur))}'),
                          Text('EUR', style: GoogleFonts.lato())
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );

//เเสดงรายการเมนูอาหารที่สั่ง
  Container buildfoodorder(int index) {
    return Container(
      width: 350,
      decoration: ShapeDecoration(
          // color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.food_bank_outlined),
                    Text(
                      'food order',
                      style: GoogleFonts.lato(fontSize: 20),
                    ),
                  ],
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
          // color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.account_box_outlined),
                MyStyle().showheadText('Customer information'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'name-last name : ',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                Text('$name')
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('phonenumber : ',
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      color: Colors.grey[600],
                    )),
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
