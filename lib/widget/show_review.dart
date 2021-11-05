import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/model/review_model.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowReview extends StatefulWidget {
  final ReadshopModel readshopModel;
  const ShowReview({Key? key, required this.readshopModel}) : super(key: key);

  @override
  _ShowReviewState createState() => _ShowReviewState();
}

class _ShowReviewState extends State<ShowReview> {
  ReadshopModel? readshopModel;
  List<ReviewModel> reviewModels = [];
  String? restaurantId;
  int? countreview;
  @override
  void initState() {
    super.initState();
    readshopModel = widget.readshopModel;
    readReview();
  }

  Future<Null> readReview() async {
    restaurantId = readshopModel!.restaurantId;
    String url =
        '${Myconstant().domain_00webhost}/getReviewWhereRestaurantId.php?restaurantId=$restaurantId';
    Response response = await Dio().get(url);
    print('res==> $response');

    var result = json.decode(response.data);
    print('result Review= $result');
    for (var map in result) {
      ReviewModel reviewModel = ReviewModel.fromJson(map);
      setState(() {
        reviewModels.add(reviewModel);
        countreview = reviewModels.length;
        print('count $countreview');
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: reviewModels.length == 0
          ? MyStyle().showProgrsee()
          : SingleChildScrollView(
              child: Column(
                children: [
                  countreview == null
                      ? MyStyle().showProgrsee()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text('$countreview Reviews',
                                  style: GoogleFonts.lato(fontSize: 25)),
                            ],
                          ),
                        ),
                  Divider(
                    color: Colors.grey[300],
                    thickness: 1,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: reviewModels.length,
                      itemBuilder: (context, index) => Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: 350,
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .account_circle_rounded,
                                                      color: Colors.grey,
                                                    ),
                                                    Text(
                                                        '${reviewModels[index].user}'),
                                                  ],
                                                ),
                                                Text(
                                                    '${reviewModels[index].review_date_time}')
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: kprimary,
                                                ),
                                                Text(
                                                    ' ${reviewModels[index].rate}')
                                              ],
                                            ),
                                            reviewModels[index].opinion ==
                                                    'null'
                                                ? Text("")
                                                : Container(
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .rate_review_outlined,
                                                          color: kprimary,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            '${reviewModels[index].opinion}',
                                                            maxLines: 5,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                color: Colors.grey[300],
                                endIndent: 10,
                                indent: 10,
                                thickness: 2,
                              )
                            ],
                          )),
                ],
              ),
            ),
    );
  }
}
