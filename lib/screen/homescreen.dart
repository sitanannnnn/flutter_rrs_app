import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/screen/show_restaurant.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:flutter_rrs_app/screen/hometilecategort.dart';
import 'package:flutter_rrs_app/screen/hometilepopular.dart';
import 'package:flutter_rrs_app/screen/hometilerestaurant.dart';
import 'package:flutter_rrs_app/screen/nearby_restaurant.dart';
import 'package:flutter_rrs_app/screen/orderfood.dart';
import 'package:flutter_rrs_app/screen/promotion.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ReadshopModel? readshopModel;
  List<ReadshopModel> readshopModels = [];
  List<Widget> restaurantCards = [];

  @override
  void initState() {
    super.initState();
    readRestaurant();
  }

  Future<Null> readRestaurant() async {
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
            restaurantCards.add(createCard(model, index));
            index++;
          });
        }
      }
    });
  }

  Widget build(BuildContext context) {
    double wid = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kprimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: searchRestaurant(),
            ),
            Row(
              children: [
                distancesshow(),
                nearfood(),
                distancesshow(),
                foodorder(),
                distancesshow(),
                promotion(),
                distancesshow(),
              ],
            ),
            Container(
              width: 350,
              height: 250,
              child: Image.asset('assets/images/2.jpg'),
            ),
            HomeTilePopular(),
            popularReataurant(),
            HomeTileRestaurant(),
            resReataurant(),
            HomeTileCategory(),
            categoryReataurant(),
            MyStyle().mySizebox()
          ],
        ),
      ),
    );
  }

  Padding distancesshow() => Padding(padding: EdgeInsets.all(8.0));

  Container popularReataurant() {
    return Container(
      height: 150,
      child: restaurantCards.length == 0
          ? MyStyle().showProgrsee()
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: readshopModels.length,
              itemBuilder: (_, index) {
                return Padding(
                  padding: EdgeInsets.all(8),
                  child: Container(
                    child: Row(children: restaurantCards),
                  ),
                );
              }),
    );
  }

  Container resReataurant() {
    return Container(
      height: 150,
      child: restaurantCards.length == 0
          ? MyStyle().showProgrsee()
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: readshopModels.length,
              itemBuilder: (_, index) {
                return Padding(
                  padding: EdgeInsets.all(8),
                  child: Container(
                    child: Row(children: restaurantCards),
                  ),
                );
              }),
    );
  }

  Container categoryReataurant() {
    return Container(
      height: 120,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (_, index) {
            return Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                height: 100,
                width: 90,
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.grey, offset: Offset(1, 1), blurRadius: 4)
                ]),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/1.jpg',
                      height: 80,
                      width: 80,
                    ),
                    Text('restaurant'),
                  ],
                ),
              ),
            );
          }),
    );
  }

  TextField searchRestaurant() {
    return TextField(
      decoration: new InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: "ที่ตั้ง ประเภทร้านอาหาร ชื่อร้านอาหาร ร้านอาหารที่ใกล้เคียง",
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: const BorderSide(
            color: kprimary,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            color: kprimary,
          ),
        ),
      ),
    );
  }

  ElevatedButton nearfood() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NearbtReataurant()));
      },
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          primary: ksecondary),
      child: Text(
        'restaurant near',
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  ElevatedButton foodorder() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => OrderFood()));
      },
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          primary: ksecondary),
      child: Text(
        'order food',
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  ElevatedButton promotion() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Promotion()));
      },
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          primary: ksecondary),
      child: Text(
        'promotion',
        style: TextStyle(color: Colors.black),
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
              width: 180,
              height: 80,
              child: Image.network(
                  '${Myconstant().domain}${readshopModel.restaurantPicture}'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Name restaurant : ${readshopModel.restaurantNameshop}',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
