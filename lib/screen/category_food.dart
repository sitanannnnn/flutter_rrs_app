import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/screen/show_restaurant.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:flutter_rrs_app/screen/order_food.dart';

class CategoryFood extends StatefulWidget {
  final String category_name;
  const CategoryFood({Key? key, required this.category_name}) : super(key: key);

  @override
  _CategoryFoodState createState() => _CategoryFoodState();
}

class _CategoryFoodState extends State<CategoryFood> {
  List<ReadshopModel> readshopModels = [];
  List<Widget> shopCards = [];
  String? typeOfFood;
  @override
  void initState() {
    super.initState();
    typeOfFood = widget.category_name;
    readcategoryrestaurant();
  }

//function อ่านค่าร้านประเภทอาหารที่มีอยูในฐานข้อมูล
  Future<Null> readcategoryrestaurant() async {
    String url =
        '${Myconstant().domain}/getRestaurantFromtypeOfFood.php?isAdd=true&chooseType=Shop&typeOfFood=$typeOfFood';
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
            shopCards.add(createCard(model, index));
            index++;
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
        body: shopCards.length == 0
            ? MyStyle().showProgrsee()
            : GridView.count(
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                crossAxisCount: 1,
                children: shopCards));
  }

//สร้างwidget  มาเก็บค่าของร้านอาหารที่ทำการอ่านค่าเข้ามา
  Widget createCard(ReadshopModel readshopModel, int index) {
    return GestureDetector(
      onTap: () {
        print('You click index $index');
        MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => OrderFood(readshopModel: readshopModel));
        Navigator.push(context, route);
      },
      child: Card(
        child: Column(
          children: [
            Container(
              width: 350,
              height: 300,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: NetworkImage(
                        '${Myconstant().domain}${readshopModel.restaurantPicture}',
                      ),
                      fit: BoxFit.cover)),
            ),
            Padding(padding: EdgeInsets.all(8.0)),
            Text('Name restaurant : ${readshopModel.restaurantNameshop}'),
            Text('Name branch :${readshopModel.restaurantBranch}'),
            Text('Type of food :${readshopModel.typeOfFood}'),
          ],
        ),
      ),
    );
  }
}
