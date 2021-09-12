import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/cart_model.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/model/reservation_model.dart';
import 'package:flutter_rrs_app/model/table_model.dart';
import 'package:flutter_rrs_app/screen/booking_datial_table_orderfood.dart';
import 'package:flutter_rrs_app/screen/pre_order_food.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:flutter_rrs_app/utility/normal_dialog.dart';
import 'package:flutter_rrs_app/utility/sqlite_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowCart extends StatefulWidget {
  final ReadshopModel readshopModel;
  final TableModel tableModel;
  final String choosevalue;
  final String date;
  final String timeFormt;
  const ShowCart({
    Key? key,
    required this.readshopModel,
    required this.date,
    required this.choosevalue,
    required this.timeFormt,
    required this.tableModel,
  }) : super(key: key);
  @override
  _ShowCartState createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  ReadshopModel? readshopModel;
  TableModel? tableModel;
  List<ReservationModel> reservationModels = [];
  String? name, email, phonenumber;
  List<CartModel> cartModels = [];
  int total = 0;
  bool status = true;
  String? customerId,
      restaurantNameshop,
      reservationId,
      numberOfGueste,
      reservationDate,
      reservationTime,
      foodmenuName,
      dateof,
      timeof,
      table,
      orderfoodDateTime;
  int index = 0;
  @override
  void initState() {
    super.initState();
    readshopModel = widget.readshopModel;
    tableModel = widget.tableModel;
    reservationDate = widget.date;
    reservationTime = widget.timeFormt;
    numberOfGueste = widget.choosevalue;
    readSQLite();
    findUser();
    orderfoodDateTime = widget.date;
    // print('Gun ==>$orderfoodDateTime');
    setState(() {
      dateof = reservationDate.toString().substring(0, 10);
      // print('dateof ==> $dateof');
    });
    setState(() {
      timeof = reservationTime.toString().substring(10, 15);
      // print('timeof ==> $timeof');
    });
  }

//หาข้อมูล cusstomer ที่ทำการ login
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString('name');
      email = preferences.getString('email');
      phonenumber = preferences.getString('phonenumber');
    });
  }

//อ่านข้อมูล SQLite
  Future<Null> readSQLite() async {
    var object = await SQLiteHelper().readAllDataFromSQLite();
    print('object length ==> ${object.length}');
    if (object.length != 0) {
      for (var model in object) {
        String? sumString = model.netPrice;
        int sumnetPrice = int.parse(sumString!);
        setState(() {
          status = false;
          cartModels = object;
          // total = total + sumnetPrice;
        });
      }
    } else {
      setState(() {
        status = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kprimary,
          title: Text('Order food details'),
        ),
        body: status
            ? Center(
                child: Text("Empty basket"),
              )
            : buildContent());
  }

  Widget buildContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          //ข้อมูลลูกค้า
          buildHeadTitle(),
          buildListFood(),
          buildTotal(),
          buildOrderButton()
        ],
      ),
    );
  }

//ปุ่มorder รายการอาหาร
  Widget buildOrderButton() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            width: 150,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: kprimary,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              child: Text('Order food'),
              onPressed: () {
                orderrecord();
                clearAllSQLite();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BookingTailTableOrderfood(
                              readshopModel: readshopModel!,
                              date: '$reservationDate',
                              choosevalue: '$numberOfGueste',
                              timeFormt: '$reservationTime',
                              tableModel: tableModel!,
                              orderfoodDateTime: '$orderfoodDateTime',
                            )));
              },
            )),
      ],
    );
  }

  Widget buildTotal() => Row(
        children: [
          Expanded(
              flex: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    " ",
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              )),
          // Expanded(flex: 1, child: Text(total.toString()))
        ],
      );
  Widget buildHeadTitle() {
    return Container(
      margin: EdgeInsets.all(5),
      height: 50,
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text("Food order",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          Expanded(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PreOrderFood(
                            readshopModel: readshopModel!,
                            choosevalue: '$numberOfGueste',
                            date: '$reservationDate',
                            pickertime: '$reservationTime',
                            tableModel: tableModel!)));
              },
              child: Text(
                'Add order',
                style: TextStyle(color: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildListFood() => ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: cartModels.length,
        itemBuilder: (context, index) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      flex: 2, child: Text(cartModels[index].foodmenuName!)),
                  Expanded(flex: 1, child: Text(cartModels[index].amount!)),
                  Expanded(flex: 1, child: Text(cartModels[index].netPrice!)),
                  Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: Icon(
                          Icons.clear_rounded,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          int? id = cartModels[index].id;
                          print("You click Delete id ==> $id");
                          await SQLiteHelper()
                              .deleteDataWhereId(id!)
                              .then((value) {
                            print("sucess delete id ==> $id");
                            readSQLite();
                          });
                        },
                      ))
                ],
              ),
            ),
            Divider(
              height: 30,
              color: Colors.grey,
            ),
          ],
        ),
      );
//บันทึกข้อมูลการสั่งอาหารไปที่ฐานข้อมูล
  Future<Null> orderrecord() async {
    DateTime dateTime = DateTime.now();
    String? orderfoodDateTime = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    String? restaurantId = cartModels[0].restaurantId;
    String? restaurantNameshop = cartModels[0].restaurantNameshop;
    List<String> foodmenuIds = [];
    List<String> foodmenuNames = [];
    List<String> foodmenuPrices = [];
    List<String> amounts = [];
    List<String> netPrices = [];
    for (var model in cartModels) {
      foodmenuIds.add(model.foodmenuId!);
      foodmenuNames.add(model.foodmenuName!);
      foodmenuPrices.add(model.foodmenuPrice!);
      amounts.add(model.amount!);
      netPrices.add(model.netPrice!);
    }
    String foodmenuId = foodmenuIds.toString();
    String foodmenuName = foodmenuNames.toString();
    String foodmenuPrice = foodmenuPrices.toString();
    String amount = amounts.toString();
    String netPrice = netPrices.toString();
    orderfoodDateTime = widget.date;
    // print('date ==>$orderfoodDateTime');
    // print(
    //     'orderDateTime = $orderfoodDateTime,restaurantId= $restaurantId,restaurantNameshop=$restaurantNameshop');
    // print(
    //     'foodmenuId = $foodmenuId,foodmenuName =$foodmenuName,foodmenuPrice=$foodmenuPrice,amount =$amount,netPricr=$netPrice');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? customerId = preferences.getString('customerId');
    restaurantNameshop = readshopModel!.restaurantNameshop!;
    print('name shop ==> $restaurantNameshop');
    String? url =
        '${Myconstant().domain}/my_login_rrs/addOrderfood.php?isAdd=true&customerId=$customerId&restaurantId=$restaurantId&restaurantNameshop=$restaurantNameshop&foodmenuId=$foodmenuId&foodmenuName=$foodmenuName&foodmenuPrice=$foodmenuPrice&amount=$amount&netPrice=$netPrice&orderfoodDateTime=$orderfoodDateTime';
    await Dio().get(url).then((value) {
      // print('value is ===> $value');
      if (value.toString() == 'true') {
        clearAllSQLite();
      } else {
        normalDialog(context, 'Please try again');
      }
    });
  }

//clearค่าข้อมูลบนฐานข้อมูลSQLite
//เเสดง Toast บนหน้าจอตามข้อความที่เรากำหนด
  Future<Null> clearAllSQLite() async {
    Fluttertoast.showToast(
        msg: 'Order completed',
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 5,
        backgroundColor: kprimary,
        textColor: Colors.white,
        fontSize: 16.0);
    await SQLiteHelper().deleteAllData().then((value) {
      readSQLite();
    });
  }
}
