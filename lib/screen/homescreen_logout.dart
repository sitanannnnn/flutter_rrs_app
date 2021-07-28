import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:flutter_rrs_app/screen/hometilecategort.dart';
import 'package:flutter_rrs_app/screen/hometilepopular.dart';
import 'package:flutter_rrs_app/screen/hometilerestaurant.dart';
import 'package:flutter_rrs_app/screen/nearby_restaurant.dart';
import 'package:flutter_rrs_app/screen/orderfood.dart';
import 'package:flutter_rrs_app/screen/promotion.dart';

class HomeScreenOut extends StatefulWidget {
  const HomeScreenOut({Key? key}) : super(key: key);

  @override
  _HomeScreenOutState createState() => _HomeScreenOutState();
}

class _HomeScreenOutState extends State<HomeScreenOut> {
  @override
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
      height: 120,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (_, index) {
            return Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                height: 80,
                width: 100,
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

  Container resReataurant() {
    return Container(
      height: 120,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (_, index) {
            return Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                height: 80,
                width: 100,
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
                height: 80,
                width: 100,
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
}
