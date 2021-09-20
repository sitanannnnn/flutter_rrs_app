import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/model/table_model.dart';
import 'package:flutter_rrs_app/screen/booking_detail_table.dart';
import 'package:flutter_rrs_app/screen/pre_order_food.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:flutter_rrs_app/utility/normal_dialog.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowTable extends StatefulWidget {
  //ข้อมูลที่มีรับมาจากการส่งมาจากต่างscreen
  final ReadshopModel readshopModel;
  final String choosevalue;
  final String date;
  final String pickertime;

  ShowTable({
    Key? key,
    required this.readshopModel,
    required this.choosevalue,
    required this.date,
    required this.pickertime,
  }) : super(key: key);
  @override
  _ShowTableState createState() => _ShowTableState();
}

class _ShowTableState extends State<ShowTable> {
  ReadshopModel? readshopModel;
  String? choosevalue;
  String? restaurantId;
  String? customerId,
      restaurantNameshop,
      numberOfGueste,
      reservationDate,
      reservationTime,
      tableResId,
      tableId,
      orderfoodId,
      reservationStatus,
      tableStatus,
      promotionId,
      promotionType;
  List<TableModel> tableModels = [];

  @override
  //initstate จะทำงานก่อน build
  void initState() {
    super.initState();
    readshopModel = widget.readshopModel;
    promotionId = readshopModel!.promotionId;
    print('promotion id ==> $promotionId');
    promotionType = readshopModel!.promotionType;
    print('promotion Type ==>$promotionType');
    restaurantNameshop = readshopModel!.restaurantNameshop;
    numberOfGueste = widget.choosevalue;
    reservationDate = widget.date;
    reservationTime = widget.pickertime;
    // print('people = $numberOfGueste');
    // print('date = $reservationDate');
    // print('time = $reservationTime');
    readTable();
  }

//function อ่านค่าข้อมูลของโต๊ะมาเเสดง
  Future<Null> readTable() async {
    restaurantId = readshopModel!.restaurantId;
    numberOfGueste = widget.choosevalue;
    String? numberpeople = numberOfGueste.toString().substring(0, 1);
    var numpeople = int.parse(numberpeople);

    print('number==> $numpeople');

    print('table of ==>$numberpeople');

    String url =
        '${Myconstant().domain}/getTableWhererestaurantId.php?isAdd=true&restaurantId=$restaurantId&tableNumseat=$numpeople&tableStatus=$tableStatus';
    Response response = await Dio().get(url);
    // print('res==> $response');
    var result = json.decode(response.data);
    // print('result= $result');
    if (result != null) {
      // numpeople = numpeople + 1;
      print('number++ ====> $numpeople');
      for (var map in result) {
        TableModel tableModel = TableModel.fromJson(map);

        setState(() {
          tableModels.add(tableModel);
          print('lenht table==>${tableModels.length}');
        });
      }
    }
    //อ่านค่าข้อมูลโต๊ะมาเเสดง เมื่อโต๊ะขนาดโต๊ะที่ระบบตั้งไว้ให้เต็มให้มีการบวกขนาดโต๊ะเพิ่มขึ้น
    else if (result == null) {
      numpeople = numpeople + 1;
      print('null');
      String url =
          '${Myconstant().domain}/getTableWhererestaurantId.php?isAdd=true&restaurantId=$restaurantId&tableNumseat=$numpeople&tableStatus=$tableStatus';
      Response response = await Dio().get(url);
      var result = json.decode(response.data);
      for (var map in result) {
        TableModel tableModel = TableModel.fromJson(map);

        setState(() {
          tableModels.add(tableModel);
          print('lenht table==>${tableModels.length}');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kprimary,
        title: Text(' ${readshopModel!.restaurantNameshop}'),
      ),
      body: tableModels.length == 0
          ? MyStyle().showProgrsee()
          : ListView.builder(
              itemCount: tableModels.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  print('You Click  index = $index');
                  confirmTable(index);
                },
                child: Row(
                  children: [
                    showTableImage(context, index),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.width * 0.3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: ShapeDecoration(
                                      color: kprimary, shape: CircleBorder()),
                                  child: Center(
                                      child:
                                          Text(tableModels[index].tableResId!)),
                                ),
                                Text(tableModels[index].tableName!),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                            0.4 -
                                        8.0,
                                    child: Row(
                                      children: [
                                        Icon(Icons.chair_alt_rounded),
                                        Text(
                                            '${tableModels[index].tableNumseat} seat')
                                      ],
                                    )),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                tableModels[index].tableDescrip! == "null"
                                    ? Text("")
                                    : Text(tableModels[index].tableDescrip!),
                              ],
                            )
                          ],
                        )),
                  ],
                ),
              ),
            ),
    );
  }

  //function show table image
  Padding showTableImage(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.width * 0.3,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(
                image: NetworkImage(
                  '${Myconstant().domain}${tableModels[index].tablePicture!}',
                ),
                fit: BoxFit.cover)),
      ),
    );
  }

//function confirm tableที่ถูกเลือก
  Future<Null> confirmTable(int index) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(' You choose the table '),
                Text('number ${tableModels[index].tableResId!}'),
                Text(tableModels[index].tableName!),
              ],
            ),
          ],
        ),
        children: [
          Container(
            width: 150,
            height: 130,
            child: Image.network(
              '${Myconstant().domain}${tableModels[index].tablePicture!}',
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 110,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: kprimary,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Edit')),
                ),
                Container(
                  width: 110,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: kprimary,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                      onPressed: () {
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (context) => SimpleDialog(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                              'Table number ${tableModels[index].tableResId!}'),
                                          Text('has been booked'),
                                          Text(' successfully.'),
                                          IconButton(
                                            onPressed: () {
                                              recordReservation(index);
                                              recordStatusTable(index);
                                              // editStatusTable(index);
                                              Navigator.pop(context);
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      SimpleDialog(
                                                        title: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Column(
                                                              children: [
                                                                Text(
                                                                    'Would you like to'),
                                                                Text(
                                                                    'pre-order food ?')
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Container(
                                                                  width: 110,
                                                                  child: ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(primary: kprimary, onPrimary: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15)))),
                                                                      onPressed: () {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (context) => BookingTailTable(
                                                                                      readshopModel: readshopModel!,
                                                                                      date: '$reservationDate',
                                                                                      choosevalue: '$numberOfGueste',
                                                                                      timeFormt: '$reservationTime',
                                                                                      tableModel: tableModels[index],
                                                                                    )));
                                                                      },
                                                                      child: Text('No'))),
                                                              Container(
                                                                  width: 110,
                                                                  child: ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(primary: kprimary, onPrimary: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15)))),
                                                                      onPressed: () {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (context) => PreOrderFood(
                                                                                      date: '$reservationDate',
                                                                                      choosevalue: '$numberOfGueste',
                                                                                      pickertime: '$reservationTime',
                                                                                      tableModel: tableModels[index],
                                                                                      readshopModel: readshopModel!,
                                                                                    )));
                                                                      },
                                                                      child: Text('Yes')))
                                                            ],
                                                          )
                                                        ],
                                                      ));
                                            },
                                            icon: Icon(
                                              Icons.check_circle,
                                              color: kprimary,
                                            ),
                                            iconSize: 30,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ));
                      },
                      child: Text('Comfirm')),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

//function บันทึกรายการจองของโต๊ะ
  Future<Null> recordReservation(int index) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? customerId = preferences.getString("customerId");
    tableResId = tableModels[index].tableResId;
    tableId = tableModels[index].tableId;
    DateTime dateTime = DateTime.now();
    String? reservationDateTime =
        DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    var url =
        '${Myconstant().domain}/addReservation.php?isAdd=true&customerId=$customerId&restaurantId=$restaurantId&tableResId=$tableResId&restaurantNameshop=$restaurantNameshop&numberOfGueste=$numberOfGueste&reservationDate=$reservationDate&reservationTime=$reservationTime&orderfoodId=$orderfoodId&reservationStatus=$reservationStatus&promotionId=$promotionId&promotionType=$promotionType&reservationDateTime=$reservationDateTime';
    try {
      Response response = await Dio().get(url);
      // print('res = $response');
      if (response.toString() == 'true') {
        // Navigator.pop(context);x
      } else {
        normalDialog(context, 'Please try again');
      }
    } catch (e) {}
  }

//function บันทึกสถานะของโต๊ะ
  Future<Null> recordStatusTable(int index) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? customerId = preferences.getString("customerId");
    tableResId = tableModels[index].tableResId;
    tableId = tableModels[index].tableId;
    var url =
        '${Myconstant().domain}/editTable_res.php?isAdd=true&tableId=$tableId&tableStatus=$tableStatus';
    try {
      Response response = await Dio().get(url);
      // print('res = $response');
      if (response.toString() == 'true') {
        // Navigator.pop(context);
      } else {
        normalDialog(context, 'Please try again');
      }
    } catch (e) {}
  }
}
