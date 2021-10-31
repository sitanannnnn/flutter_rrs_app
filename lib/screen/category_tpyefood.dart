import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/screen/show_restaurant.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:flutter_rrs_app/screen/order_food.dart';

class CategoryTypefood extends StatefulWidget {
  final String caption_location;
  const CategoryTypefood({Key? key, required this.caption_location})
      : super(key: key);

  @override
  _CategoryTypefoodState createState() => _CategoryTypefoodState();
}

class _CategoryTypefoodState extends State<CategoryTypefood> {
  List<ReadshopModel> readshopModels = [];
  String? typeOfFood;
  @override
  void initState() {
    super.initState();
    typeOfFood = widget.caption_location;
    readcategoryrestaurant();
  }

//function อ่านค่าร้านประเภทอาหารที่มีอยูในฐานข้อมูล
  Future<Null> readcategoryrestaurant() async {
    String url =
        '${Myconstant().domain_00webhost}/getRestaurantFromtypeOfFood.php?isAdd=true&chooseType=Shop&typeOfFood=$typeOfFood';
    await Dio().get(url).then((value) {
      // print('value=$value');
      var result = json.decode(value.data);
      int index = 0;
      for (var map in result) {
        ReadshopModel model = ReadshopModel.fromJson(map);
        String? NameShop = model.restaurantNameshop;
        if (NameShop!.isNotEmpty) {
          print('NameShop =${model.restaurantNameshop}');
          setState(() {
            readshopModels.add(model);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kprimary,
          title: Text('$typeOfFood'),
        ),
        body: readshopModels.length == 0
            ? Center(child: Text('There is no restaurant of this type'))
            : ListView.builder(
                itemCount: readshopModels.length,
                itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        print('You click index $index');

                        MaterialPageRoute route = MaterialPageRoute(
                            builder: (context) => ShowRestaurant(
                                readshopModel: readshopModels[index]));
                        Navigator.push(context, route);
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                            child: Container(
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
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 350,
                                      height: 250,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                '${Myconstant().domain_restaurantPic}${readshopModels[index].restaurantPicture}',
                                              ),
                                              fit: BoxFit.cover)),
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.all(8.0)),
                                  Text(
                                      'Name restaurant : ${readshopModels[index].restaurantNameshop}'),
                                  Text(
                                      ' branch :${readshopModels[index].restaurantBranch}'),
                                  Text(
                                      'Type of food :${readshopModels[index].typeOfFood}'),
                                  SizedBox(
                                    height: 8,
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    )));
  }
}
