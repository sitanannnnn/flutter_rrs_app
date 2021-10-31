import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/cart_model.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/model/reservation_model.dart';
import 'package:flutter_rrs_app/model/table_model.dart';
import 'package:flutter_rrs_app/screen/booking_detail_orderfood.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:flutter_rrs_app/utility/normal_dialog.dart';
import 'package:flutter_rrs_app/utility/sqlite_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartOrderfood extends StatefulWidget {
  final ReadshopModel readshopModel;

  const CartOrderfood({
    Key? key,
    required this.readshopModel,
  }) : super(key: key);
  @override
  _CartOrderfoodState createState() => _CartOrderfoodState();
}

class _CartOrderfoodState extends State<CartOrderfood> {
  ReadshopModel? readshopModel;
  TableModel? tableModel;
  List<ReservationModel> reservationModels = [];
  String? name, email, phonenumber;
  List<CartModel> cartModels = [];
  int total = 0;
  bool status = true;
  String? reviewId;
  String? customerId,
      restaurantNameshop,
      reservationId,
      foodmenuName,
      table,
      orderfoodDateTime,
      orderfoodStatus,
      promotionId,
      promotionType;
  int index = 0;
  @override
  void initState() {
    super.initState();
    readshopModel = widget.readshopModel;
    promotionId = readshopModel!.promotionId;
    promotionType = readshopModel!.promotionType;
    print('promotionId==> $promotionId');

    readSQLite();
    findUser();
    // orderfoodDateTime = widget.date;
    // print('Gun ==>$orderfoodDateTime');
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString('name');
      email = preferences.getString('email');
      phonenumber = preferences.getString('phonenumber');
    });
  }

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
          title: Text('Food order details'),
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
          buildHeadTitle(),
          buildListFood(),
          // buildTotal(),
          buildOrderButton()
        ],
      ),
    );
  }

  Widget buildOrderButton() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            width: 150,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              child: Text('Order food'),
              onPressed: () {
                orderrecord();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BookingTailOrderfood(
                            readshopModel: readshopModel!,
                            orderfoodDateTime: '$orderfoodDateTime')));
              },
            )),
      ],
    );
  }

  // Widget buildTotal() => Row(
  //       children: [
  //         Expanded(
  //             flex: 5,
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 Text(
  //                   " ",
  //                   style: TextStyle(fontSize: 25),
  //                 ),
  //               ],
  //             )),
  //         // Expanded(flex: 1, child: Text(total.toString()))
  //       ],
  //     );
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
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => PreOrderFood(
                //             readshopModel: readshopModel!,
                //             choosevalue: '$numberOfGueste',
                //             date: '$reservationDate',
                //             pickertime: '$reservationTime',
                //             tableModel: tableModel!)));
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
//บันทึกการสั่งอาหารไปที่ฐานข้อมูล
  Future<Null> orderrecord() async {
    DateTime dateTime = DateTime.now();
    orderfoodDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    //print("date is now===>$dateTime");
    //print('date ==>$orderfoodDateTime');
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

    // print(
    //     'orderDateTime = $orderfoodDateTime,restaurantId= $restaurantId,restaurantNameshop=$restaurantNameshop');
    // print(
    //     'foodmenuId = $foodmenuId,foodmenuName =$foodmenuName,foodmenuPrice=$foodmenuPrice,amount =$amount,netPricr=$netPrice');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? customerId = preferences.getString('customerId');
    restaurantNameshop = readshopModel!.restaurantNameshop!;

    // print('name shop ==> $restaurantNameshop');
    String? url =
        '${Myconstant().domain_00webhost}/addOrderfood.php?isAdd=true&customerId=$customerId&restaurantId=$restaurantId&restaurantNameshop=$restaurantNameshop&foodmenuId=$foodmenuId&foodmenuName=$foodmenuName&foodmenuPrice=$foodmenuPrice&amount=$amount&netPrice=$netPrice&orderfoodDateTime=$orderfoodDateTime&reservationId=$reservationId&orderfoodStatus=$orderfoodStatus&promotionId=$promotionId&promotionType=$promotionType';
    await Dio().get(url).then((value) {
      // print('value is ===> $value');
      if (value.statusCode == 200) {
        clearAllSQLite();
      } else {
        normalDialog(context, 'Please try again');
      }
    });
  }

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
