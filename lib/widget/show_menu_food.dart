import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/food_menu_model.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowMenuFood extends StatefulWidget {
  final ReadshopModel? readshopModel;

  ShowMenuFood({Key? key, this.readshopModel}) : super(key: key);
  @override
  _ShowMenuFoodState createState() => _ShowMenuFoodState();
}

class _ShowMenuFoodState extends State<ShowMenuFood> {
  ReadshopModel? readshopModel;
  String? restaurantId;
  List<FoodMenuModel> foodmenuModels = [];
  @override
  void initState() {
    super.initState();
    readshopModel = widget.readshopModel;
    readFoodMenu();
  }

  Future<Null> readFoodMenu() async {
    restaurantId = readshopModel!.restaurantId;
    String url =
        '${Myconstant().domain_00webhost}/getFoodmenuWhererestaurantId.php?isAdd=true&restaurantId=$restaurantId';
    Response response = await Dio().get(url);
    //print('res==> $response');

    var result = json.decode(response.data);
    //print('result= $result');
    for (var map in result) {
      FoodMenuModel foodMenuModel = FoodMenuModel.fromJson(map);
      setState(() {
        foodmenuModels.add(foodMenuModel);
      });
    }
  }

  Widget build(BuildContext context) {
    return foodmenuModels.length == 0
        ? MyStyle().showProgrsee()
        : SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: foodmenuModels.length,
                  itemBuilder: (context, index) => GestureDetector(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            showFoodmenuImage(context, index),
                            Flexible(
                              child: Container(
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5 -
                                              8.0,
                                          child: foodmenuModels[index]
                                                      .foodMenuIdBuyOne ==
                                                  null
                                              ? Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        foodmenuModels[index]
                                                            .foodmenuName!,
                                                        style: GoogleFonts.lato(
                                                            fontSize: 16,
                                                            color: Colors
                                                                .blue[800]),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        '${foodmenuModels[index].foodmenunameBuyOne} + ${foodmenuModels[index].foodmenunameGetOne}',
                                                        style: GoogleFonts.lato(
                                                            fontSize: 16,
                                                            color: Colors
                                                                .blue[800]),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    //show price food
                                    Row(
                                      children: [
                                        foodmenuModels[index].promotion_id ==
                                                null
                                            ? Container(
                                                width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.4 -
                                                    8.0,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      foodmenuModels[index]
                                                          .foodmenuPrice!,
                                                      style: GoogleFonts.lato(
                                                          fontSize: 16,
                                                          color: Colors
                                                              .green[800]),
                                                    ),
                                                    Text("K",
                                                        style: GoogleFonts.lato(
                                                            fontSize: 16,
                                                            color: Colors
                                                                .grey[800],
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough))
                                                  ],
                                                ))
                                            : Container(
                                                width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.4 -
                                                    8.0,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      foodmenuModels[index]
                                                          .promotionOldPrice!,
                                                      style: GoogleFonts.lato(
                                                          fontSize: 14,
                                                          color:
                                                              Colors.grey[800],
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                          decorationColor:
                                                              Colors.red,
                                                          decorationThickness:
                                                              3),
                                                    ),
                                                    Text("K",
                                                        style: GoogleFonts.lato(
                                                            fontSize: 16,
                                                            color: Colors
                                                                .grey[800],
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough))
                                                  ],
                                                ))
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        foodmenuModels[index].promotion_id ==
                                                null
                                            ? Text("")
                                            : Row(
                                                children: [
                                                  Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width *
                                                                  0.4 -
                                                              8.0,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            foodmenuModels[
                                                                    index]
                                                                .promotionNewPrice!,
                                                            style: GoogleFonts.lato(
                                                                fontSize: 16,
                                                                color: Colors
                                                                        .green[
                                                                    800]),
                                                          ),
                                                          Text("K",
                                                              style: GoogleFonts.lato(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                          .grey[
                                                                      800],
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough))
                                                        ],
                                                      ))
                                                ],
                                              ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey[200],
                          thickness: 10,
                          indent: 0,
                          endIndent: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Padding showFoodmenuImage(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.width * 0.3,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(
              image: NetworkImage(
                '${Myconstant().domain_foodPic}${foodmenuModels[index].foodmenuPicture!}',
              ),
              fit: BoxFit.cover,
            )),
      ),
    );
  }
}
