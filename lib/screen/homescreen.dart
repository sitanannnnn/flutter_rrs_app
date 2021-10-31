import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/screen/horizontal_typefood.dart';
import 'package:flutter_rrs_app/screen/search_page.dart';
import 'package:flutter_rrs_app/screen/show_restaurant.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:flutter_rrs_app/screen/nearby_restaurant.dart';
import 'package:flutter_rrs_app/screen/type_of_food.dart';
import 'package:flutter_rrs_app/screen/promotion.dart';
import 'package:google_fonts/google_fonts.dart';
import 'all_popular_restaurant.dart';
import 'all_restaurant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ReadshopModel> readshopModels = [];
  List<ReadshopModel> readshop = [];
  List<Widget> categoryCards = [];
  String? reservatinDate,
      reservationTime,
      numberOfGueste,
      typeOfFood,
      restaurantId;
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
        '${Myconstant().domain_00webhost}/getRestaurantFromchooseType.php?isAdd=true&&chooseType=Shop';
    await Dio().get(url).then((value) {
      // print('value=$value');
      var result = json.decode(value.data);
      for (var map in result) {
        ReadshopModel readshopModel = ReadshopModel.fromJson(map);
        String? NameShop = readshopModel.restaurantNameshop;
        if (NameShop!.isNotEmpty) {
          print('NameShop =${readshopModel.restaurantNameshop}');
          setState(() {
            readshopModels.add(readshopModel);
            readshop = readshopModels;
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
        elevation: 1,
        actions: [
          IconButton(
              onPressed: () {
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (context) => SearchPage());
                Navigator.push(context, route);
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                nearfood(),
                foodorder(),
                promotion(),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('categories'),
                )
              ],
            ),
            HorizontalTypefood(),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 225.0,
                child: CarouselSlider(
                  options: CarouselOptions(
                      enlargeCenterPage: true,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      disableCenter: true,
                      autoPlayAnimationDuration: Duration(microseconds: 1500)),
                  items: [
                    Image.asset(
                      'assets/images/c1.jpg',
                      fit: BoxFit.cover,
                    ),
                    Image.asset('assets/images/c2.jpg', fit: BoxFit.cover),
                    Image.asset('assets/images/c3.jpg', fit: BoxFit.cover),
                    Image.asset('assets/images/c4.jpg', fit: BoxFit.cover),
                  ],
                ),
              ),
            ),
            hometitlePopular(context),
            popularReataurant(),
            hometitleRestaurant(context),
            resReataurant(),
          ],
        ),
      ),
    );
  }

  Column hometitleRestaurant(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.restaurant),
                  Text('restaurant'),
                ],
              ),
              TextButton(
                onPressed: () {
                  MaterialPageRoute route =
                      MaterialPageRoute(builder: (context) => AllReataurant());
                  Navigator.push(context, route);
                },
                child: Row(
                  children: [
                    Text('view all', style: TextStyle(color: Colors.black)),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.black,
                      size: 14,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Column hometitlePopular(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.store_mall_directory_rounded),
                  Text('the restaurant is popular'),
                ],
              ),
              TextButton(
                onPressed: () {
                  MaterialPageRoute route = MaterialPageRoute(
                      builder: (context) => AllPopularReataurant());
                  Navigator.push(context, route);
                },
                child: Row(
                  children: [
                    Text('view all', style: TextStyle(color: Colors.black)),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.black,
                      size: 14,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

//function เเสดงร้านอาหารเป็นที่นิยม
  Container popularReataurant() {
    return Container(
      height: 130,
      child: readshopModels.length == 0
          ? MyStyle().showProgrsee()
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: readshopModels.length,
              itemBuilder: (context, index) => GestureDetector(
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
                                      '${Myconstant().domain_restaurantPic}${readshopModels[index].restaurantPicture}',
                                    ),
                                    fit: BoxFit.cover)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${readshopModels[index].restaurantNameshop}',
                              style: GoogleFonts.lato(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
    );
  }

//function เเสดงร้านอาหาร
  Container resReataurant() {
    return Container(
      height: 130,
      child: readshopModels.length == 0
          ? MyStyle().showProgrsee()
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: readshopModels.length,
              itemBuilder: (context, index) => GestureDetector(
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
                                      '${Myconstant().domain_restaurantPic}${readshopModels[index].restaurantPicture}',
                                    ),
                                    fit: BoxFit.cover)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${readshopModels[index].restaurantNameshop}',
                              style: GoogleFonts.lato(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
    );
  }

// //ค้นหาร้านอาหาร
//   TextField searchRestaurant() {
//     return TextField(
//       decoration: new InputDecoration(
//         prefixIcon: Icon(Icons.search),
//         hintText: "ที่ตั้ง ประเภทร้านอาหาร ชื่อร้านอาหาร ร้านอาหารที่ใกล้เคียง",
//         enabledBorder: const OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(10.0)),
//           borderSide: const BorderSide(
//             color: kprimary,
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(10.0)),
//           borderSide: BorderSide(
//             color: kprimary,
//           ),
//         ),
//       ),
//     );
//   }

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
}
