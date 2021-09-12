import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/food_menu_model.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';

class ShowMenuFood extends StatefulWidget {
  final ReadshopModel? readshopModel;

  ShowMenuFood({Key? key, this.readshopModel}) : super(key: key);
  @override
  _ShowMenuFoodState createState() => _ShowMenuFoodState();
}

class _ShowMenuFoodState extends State<ShowMenuFood> {
  ReadshopModel? readshopModel;
  String? restaurantId;
  List<FoodMenuModel> foodmenuModels = [];
  @override
  void initState() {
    super.initState();
    readshopModel = widget.readshopModel;
    readFoodMenu();
  }

  Future<Null> readFoodMenu() async {
    restaurantId = readshopModel!.restaurantId;
    String url =
        '${Myconstant().domain}/my_login_rrs/getFoodWhererestaurantId.php?isAdd=true&restaurantId=$restaurantId';
    Response response = await Dio().get(url);
    print('res==> $response');

    var result = json.decode(response.data);
    print('result= $result');
    for (var map in result) {
      FoodMenuModel foodMenuModel = FoodMenuModel.fromJson(map);
      setState(() {
        foodmenuModels.add(foodMenuModel);
      });
    }
  }

  Widget build(BuildContext context) {
    return foodmenuModels.length == 0
        ? MyStyle().showProgrsee()
        : ListView.builder(
            itemCount: foodmenuModels.length,
            itemBuilder: (context, index) => Row(
                  children: [
                    showFoodmenuImage(context, index),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.width * 0.3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(foodmenuModels[index].foodmenuName!),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                            0.4 -
                                        8.0,
                                    child: Text(foodmenuModels[index]
                                        .foodmenuDescrip!)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    'Price : ${foodmenuModels[index].foodmenuPrice!} LAK'),
                              ],
                            )
                          ],
                        )),
                  ],
                ));
  }

  Padding showFoodmenuImage(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.width * 0.3,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(
              image: NetworkImage(
                '${Myconstant().domain}${foodmenuModels[index].foodmenuPicture!}',
              ),
              fit: BoxFit.cover,
            )),
      ),
    );
  }
}
