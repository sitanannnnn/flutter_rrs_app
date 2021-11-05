import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:flutter_rrs_app/widget/about_restaurant.dart';
import 'package:flutter_rrs_app/widget/show_menu_food.dart';
import 'package:flutter_rrs_app/widget/show_review.dart';

class ShowRestaurant extends StatefulWidget {
  final ReadshopModel readshopModel;
  ShowRestaurant({Key? key, required this.readshopModel}) : super(key: key);
  @override
  _ShowRestaurantState createState() => _ShowRestaurantState();
}

class _ShowRestaurantState extends State<ShowRestaurant> {
  ReadshopModel? readshopModel;
  List<Widget>? listWidgets = [];
  int indexPage = 0;
  @override
  void initState() {
    super.initState();
    readshopModel = widget.readshopModel;
    listWidgets!.add(AboutRestaurant(
      readshopModel: readshopModel!,
    ));
    listWidgets!.add(ShowMenuFood(
      readshopModel: readshopModel,
    ));
  }

  @override
  Widget build(BuildContext context) {
    double wid = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kprimary,
          toolbarHeight: wid / 4,
          title: Text(
            readshopModel!.restaurantNameshop!,
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.white,
            tabs: [
              Tab(
                text: 'abount the restaurant',
              ),
              Tab(
                text: 'food menu ',
              ),
              Tab(
                text: 'review',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AboutRestaurant(readshopModel: readshopModel!),
            ShowMenuFood(
              readshopModel: readshopModel,
            ),
            ShowReview(readshopModel: readshopModel!)
          ],
        ),
      ),
    );
  }
}
