import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/promotion_model.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/screen/show_restaurant.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';

class Promotion extends StatefulWidget {
  Promotion({
    Key? key,
  }) : super(key: key);

  @override
  _PromotionState createState() => _PromotionState();
}

class _PromotionState extends State<Promotion> {
  List<PromotionModel> promotionModels = [];
  List<ReadshopModel> readshopModels = [];
  List<Widget> shopCards = [];
  String? restautantId;
  @override
  void initState() {
    super.initState();
    readPromotion();
  }

  Future<Null> readPromotion() async {
    String url =
        '${Myconstant().domain}/my_login_rrs/getPromotion.php?isAdd=true&chooseType=Shop';
    await Dio().get(url).then((value) {
      // print('value=$value');
      var result = json.decode(value.data);
      int index = 0;
      for (var map in result) {
        PromotionModel model = PromotionModel.fromJson(map);
        String? NameShop = model.restaurantNameshop;
        if (NameShop!.isNotEmpty) {
          print('NameShop =${model.restaurantNameshop}');
          setState(() {
            promotionModels.add(model);
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
        title: Text('Promotion'),
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

  Widget createCard(PromotionModel promotionModel, int index) {
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
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: NetworkImage(
                        '${Myconstant().domain}${promotionModel.restaurantPicture}',
                      ),
                      fit: BoxFit.cover)),
            ),
            Padding(padding: EdgeInsets.all(8.0)),
            Text('Name restaurant : ${promotionModel.restaurantNameshop}'),
            Text('Name branch :${promotionModel.restaurantBranch}'),
            Text('Type of food :${promotionModel.typeOfFood}'),
            Text('promotion :${promotionModel.promotionType}'),
          ],
        ),
      ),
    );
  }
}
