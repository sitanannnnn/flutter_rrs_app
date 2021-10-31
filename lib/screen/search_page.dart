import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/screen/show_restaurant.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<ReadshopModel> readshopModels = [];
  List<ReadshopModel> readshop = [];
  @override
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
          print('NameShop!! =${readshopModel.restaurantNameshop}');
          setState(() {
            readshopModels.add(readshopModel);
            readshop = readshopModels;
            //print(readshop.length);
          });
        }
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
              color: ksecondary, borderRadius: BorderRadius.circular(30)),
          child: TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                errorBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.all(15),
                hintText: 'Search....'),
            onChanged: (text) {
              text = text.toLowerCase();
              setState(() {
                readshop = readshopModels.where((element) {
                  var postTitle = element.restaurantNameshop!.toLowerCase();
                  return postTitle.contains(text);
                }).toList();
              });
            },
          ),
        ),
        backgroundColor: kprimary,
      ),
      body: readshop.isEmpty
          ? Center(
              child: Text('Restaurant not found!!',
                  style: GoogleFonts.lato(fontSize: 20)))
          : ListView.builder(
              itemCount: readshop.length,
              itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      print('youclick => ${readshop[index].restaurantId}');
                      MaterialPageRoute route = MaterialPageRoute(
                        builder: (context) => ShowRestaurant(
                          readshopModel: readshop[index],
                        ),
                      );
                      Navigator.push(context, route);
                    },
                    child: _listItem(index),
                  )),
    );
  }

  _listItem(index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Card(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 75,
                    height: 75,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          '${Myconstant().domain_restaurantPic}${readshop[index].restaurantPicture}'),
                      // child: Image.network(
                      //   ,
                      // ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(readshop[index].restaurantNameshop!,
                      style: GoogleFonts.lato(fontSize: 20)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // _searchBar() {
  //   return Padding(
  //     padding: EdgeInsets.all(8),
  //     child: TextField(
  //       decoration: InputDecoration(hintText: 'Search....'),
  //       onChanged: (text) {
  //         text = text.toLowerCase();
  //         setState(() {
  //           readshop = readshopModels.where((element) {
  //             var postTitle = element.restaurantNameshop!.toLowerCase();
  //             return postTitle.contains(text);
  //           }).toList();
  //         });
  //       },
  //     ),
  //   );
  // }
}
