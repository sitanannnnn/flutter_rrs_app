import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/promotion_model.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/screen/show_restaurant.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:google_fonts/google_fonts.dart';

class PromotionReserveTable extends StatefulWidget {
  PromotionReserveTable({
    Key? key,
  }) : super(key: key);
  @override
  _PromotionReserveTableState createState() => _PromotionReserveTableState();
}

class _PromotionReserveTableState extends State<PromotionReserveTable> {
  List<PromotionModel> promotionModels = [];
  List<ReadshopModel> readshopModels = [];
  String? restautantId;
  @override
  void initState() {
    super.initState();
    readPromotion();
  }

//read promotion restaurant
  Future<Null> readPromotion() async {
    String url =
        '${Myconstant().domain_00webhost}/getPromotionReserve_a_table.php?isAdd=true&promotion.promotion_type=Reserve a table';
    await Dio().get(url).then((value) {
      print('value=$value');
      var result = json.decode(value.data);
      int index = 0;
      for (var map in result) {
        ReadshopModel model = ReadshopModel.fromJson(map);
        String? NameShop = model.restaurantNameshop;
        if (NameShop!.isNotEmpty) {
          print('NameShop =${model.restaurantNameshop}');
          setState(() {
            readshopModels.add(model);
            // shopCards.add(createCard(model, index));
            // index++;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: readshopModels.length == 0
            ? Center(child: Text('There is no promotions of this type'))
            : ListView.builder(
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
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 350,
                                      height: 250,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                '${Myconstant().domain_restaurantPic}${readshopModels[index].restaurantPicture}',
                                              ),
                                              fit: BoxFit.cover)),
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.all(8.0)),
                                  Text(
                                      'Name restaurant : ${readshopModels[index].restaurantNameshop}',
                                      style: GoogleFonts.lato(fontSize: 15)),
                                  Text(
                                      'promotion :${readshopModels[index].promotionType}',
                                      style: GoogleFonts.lato(fontSize: 15)),
                                  Text(
                                      'date of promotion :${readshopModels[index].promotionFinishDate}',
                                      style: GoogleFonts.lato(fontSize: 15)),
                                  Text(
                                      'time of promotion :${readshopModels[index].promotionFinishTime}',
                                      style: GoogleFonts.lato(fontSize: 15)),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                            '  ${readshopModels[index].promotionDiscount} % discount for reserve a table and order food ',
                                            style:
                                                GoogleFonts.lato(fontSize: 15)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    )));
  }
}
