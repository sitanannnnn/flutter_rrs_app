import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListRestaurant extends StatefulWidget {
  const ListRestaurant({Key? key}) : super(key: key);

  @override
  _ListRestaurantState createState() => _ListRestaurantState();
}

class _ListRestaurantState extends State<ListRestaurant> {
  @override
  @override
  void initState() {
    super.initState();
    readRestaurant();
  }

  Future<Null> readRestaurant() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? restaurantId = preferences.getString('id');
    print('id = $restaurantId');
    String? nameowner = preferences.getString('name');
    print('name = $nameowner');
    ;

    String url =
        'http://b0b2195d2d06.ngrok.io/my_login_rrs/getRestaurant.php?isAdd=true&restaurantId=$restaurantId';
    Response response = await Dio().get(url);
    print('res ==> $response');
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kprimary,
        title: Text('ร้านอาหาร'),
      ),
    );
  }
}
