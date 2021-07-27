import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';

class AboutRestaurant extends StatefulWidget {
  final ReadshopModel readshopModel;
  AboutRestaurant({Key? key, required this.readshopModel}) : super(key: key);
  @override
  _AboutRestaurantState createState() => _AboutRestaurantState();
}

class _AboutRestaurantState extends State<AboutRestaurant> {
  ReadshopModel? readshopModel;
  @override
  @override
  void initState() {
    super.initState();
    readshopModel = widget.readshopModel;
  }

  Widget build(BuildContext context) {
    return Image.network(
        '${Myconstant().domain}${readshopModel!.restaurantPicture}');
  }
}
