import 'package:flutter/material.dart';

class HomeTilePopular extends StatefulWidget {
  const HomeTilePopular({Key? key}) : super(key: key);

  @override
  _HomeTilePopularState createState() => _HomeTilePopularState();
}

class _HomeTilePopularState extends State<HomeTilePopular> {
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
                  Icon(Icons.store_mall_directory_rounded),
                  Text('the restaurant is popular'),
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
