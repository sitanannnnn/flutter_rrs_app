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
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.restaurant),
                Text('the restaurant is popular'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(160, 5, 5, 5),
                  child: Text('view all'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
