import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/screen/show_restaurant.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';

class NearbtReataurant extends StatefulWidget {
  const NearbtReataurant({Key? key}) : super(key: key);

  @override
  _NearbtReataurantState createState() => _NearbtReataurantState();
}

class _NearbtReataurantState extends State<NearbtReataurant> {
  List<ReadshopModel> readshopModels = [];
  List<Widget> shopCards = [];
  @override
  void initState() {
    super.initState();
    readShop();
  }

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
          : GridView.extent(
              maxCrossAxisExtent: 400.0,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: shopCards,
            ),
    );
  }

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
