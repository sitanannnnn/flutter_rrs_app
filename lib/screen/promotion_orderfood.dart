import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/promotion_model.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/screen/order_food.dart';
import 'package:flutter_rrs_app/screen/show_restaurant.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:google_fonts/google_fonts.dart';

class PromotionOrderfood extends StatefulWidget {
  PromotionOrderfood({
    Key? key,
  }) : super(key: key);

  @override
  _PromotionOrderfoodState createState() => _PromotionOrderfoodState();
}

class _PromotionOrderfoodState extends State<PromotionOrderfood> {
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
        '${Myconstant().domain}/getPromotionOrder_food.php?isAdd=true&promotion.promotion_type=Order food';
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
            builder: (context) => OrderFood(readshopModel: readshopModel));
        Navigator.push(context, route);
      },
      child: Card(
        child: Column(
          children: [
            Container(
              width: 350,
              height: 250,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: NetworkImage(
                        '${Myconstant().domain}${readshopModel.restaurantPicture}',
                      ),
                      fit: BoxFit.cover)),
            ),
            Padding(padding: EdgeInsets.all(8.0)),
            Text(
                'Name restaurant : ${readshopModels[index].restaurantNameshop}',
                style: GoogleFonts.lato(fontSize: 15)),
            Text('promotion :${readshopModels[index].promotionType}',
                style: GoogleFonts.lato(fontSize: 15)),
            Text(
                'date of promotion :${readshopModels[index].promotionFinishDate}',
                style: GoogleFonts.lato(fontSize: 15)),
            Text(
                'time of promotion :${readshopModels[index].promotionFinishTime}',
                style: GoogleFonts.lato(fontSize: 15)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  child: Image.asset(
                    'assets/images/discountfood.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                    '  ${readshopModels[index].promotionDiscount} % discount for order food ',
                    style: GoogleFonts.lato(fontSize: 15)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
