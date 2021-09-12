import 'package:flutter/material.dart';

class HomeTileRestaurant extends StatefulWidget {
  const HomeTileRestaurant({Key? key}) : super(key: key);

  @override
  _HomeTileRestaurantState createState() => _HomeTileRestaurantState();
}

class _HomeTileRestaurantState extends State<HomeTileRestaurant> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.restaurant),
                  Text('restaurant'),
                ],
              ),
              Text('view all'),
            ],
          ),
        ],
      ),
    );
  }
}
