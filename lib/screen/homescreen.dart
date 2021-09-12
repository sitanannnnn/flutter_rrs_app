import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/screen/category_food.dart';
import 'package:flutter_rrs_app/screen/show_cart.dart';
import 'package:flutter_rrs_app/screen/show_restaurant.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:flutter_rrs_app/screen/hometilepopular.dart';
import 'package:flutter_rrs_app/screen/hometilerestaurant.dart';
import 'package:flutter_rrs_app/screen/nearby_restaurant.dart';
import 'package:flutter_rrs_app/screen/type_of_food.dart';
import 'package:flutter_rrs_app/screen/promotion.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ReadshopModel> readshopModels = [];
  List<Widget> restaurantCards = [];
  List<Widget> categoryCards = [];
  String? reservatinDate, reservationTime, numberOfGueste, typeOfFood;

  @override
  void initState() {
    super.initState();
    readRestaurant();
  }

//อ่านค่าร้านอาหารจากฐานข้อมูลมาเเสดง
  Future<Null> readRestaurant() async {
    if (readshopModels.length != 0) {
      readshopModels.clear();
    }
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

//อ่านค่าประเภทของอาหารจากฐานข้อมูลมาเเสดง
  Future<Null> readcategoriesrestaurant() async {
    String url =
        '${Myconstant().domain}/my_login_rrs/getRestaurantFromtypeOfFood.php?isAdd=true&chooseType=Shop&typeOfFood=$typeOfFood';
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
            categoryCards.add(createCard(model, index));
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
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.shopping_cart_rounded,
                color: Colors.white,
              ))
        ],
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                nearfood(),
                foodorder(),
                promotion(),
              ],
            ),

            // Widget imageCarousel = new Container(
            //   height: 225.0,
            //   child: Carousel(
            //     boxFit: BoxFit.cover,
            //     images: [
            //       AssetImage('assets/images/c1.jpg'),
            //       AssetImage('assets/images/c2.jpg'),
            //       AssetImage('assets/images/c3.jpg'),
            //       AssetImage('assets/images/c4.jpg'),
            //     ],
            //     autoplay: true,
            //     dotSize: 5.0,
            //     indicatorBgPadding: 9.0,
            //     overlayShadow: false,
            //     borderRadius: true,
            //     animationCurve: Curves.fastOutSlowIn,
            //     animationDuration: Duration(microseconds: 1500),
            //   ),
            // );
            Container(
              width: 350,
              height: 250,
              child: Image.asset('assets/images/2.jpg'),
            ),
            HomeTilePopular(),
            popularReataurant(),
            HomeTileRestaurant(),
            resReataurant(),
          ],
        ),
      ),
    );
  }

//function เเสดงร้านอาหารเป็นที่นิยม
  Container popularReataurant() {
    return Container(
      height: 150,
      child: restaurantCards.length == 0
          ? MyStyle().showProgrsee()
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: readshopModels.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(5),
                  child: Container(
                    child: Row(children: restaurantCards),
                  ),
                );
              }),
    );
  }

//function เเสดงร้านอาหาร
  Container resReataurant() {
    return Container(
      height: 150,
      child: restaurantCards.length == 0
          ? MyStyle().showProgrsee()
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: readshopModels.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(5),
                  child: Container(
                    child: Row(children: restaurantCards),
                  ),
                );
              }),
    );
  }

//ค้นหาร้านอาหาร
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

//ไปหน้าร้านอาหารที่ใกล้เคียง
  ElevatedButton nearfood() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NearbyReataurant()));
      },
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          primary: ksecondary),
      child: Text(
        'restaurant near',
        style: GoogleFonts.lato(),
      ),
    );
  }

//ไปที่หน้าสั่งอาหาร
  ElevatedButton foodorder() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => TypeOfFood()));
      },
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          primary: ksecondary),
      child: Text(
        'order food',
        style: GoogleFonts.lato(),
      ),
    );
  }

//ไปที่หน้าร้านอาหารที่จัดโปรโมชั่น
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
        style: GoogleFonts.lato(),
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
              width: 150,
              height: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  image: DecorationImage(
                      image: NetworkImage(
                        '${Myconstant().domain}${readshopModel.restaurantPicture}',
                      ),
                      fit: BoxFit.cover)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${readshopModel.restaurantNameshop}',
                style: GoogleFonts.lato(fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
