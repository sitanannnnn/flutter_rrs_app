import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/screen/show_restaurant.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';

class NearbyReataurant extends StatefulWidget {
  const NearbyReataurant({Key? key}) : super(key: key);

  @override
  _NearbyReataurantState createState() => _NearbyReataurantState();
}

class _NearbyReataurantState extends State<NearbyReataurant> {
  List<ReadshopModel> readshopModels = [];
  List<Widget> shopCards = [];
  @override
  void initState() {
    super.initState();
    readShop();
  }

//function อ่านค่าร้านอาหารที่มีอยูในฐานข้อมูล
  Future<Null> readShop() async {
    String url =
        '${Myconstant().domain}/my_login_rrs/getRestaurantFromchooseType.php?isAdd=true&&chooseType=Shop';
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
          title: Text('restaurant nearby'),
        ),
        body: shopCards.length == 0
            ? MyStyle().showProgrsee()
            : GridView.count(crossAxisCount: 1, children: shopCards));
  }

//สร้าง card ในการเเสดงข้อมูล
  Widget createCard(ReadshopModel readshopModel, int index) {
    return GestureDetector(
      onTap: () {
        print('You click index $index');
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => ShowRestaurant(
            readshopModel: readshopModels[index],
          ),
        );
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
