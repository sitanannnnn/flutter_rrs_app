import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';

class Restaurant extends StatefulWidget {
  Restaurant({Key? key}) : super(key: key);

  @override
  _RestaurantState createState() => _RestaurantState();
}

class _RestaurantState extends State<Restaurant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kprimary,
        title: Text('restaurant'),
      ),
      body: Column(
        children: [
          Image.asset(''),
          TextButton(onPressed: () {}, child: Text(""))
        ],
      ),
    );
  }
}
