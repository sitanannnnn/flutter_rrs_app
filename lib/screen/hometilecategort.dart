import 'package:flutter/material.dart';

class HomeTileCategory extends StatefulWidget {
  const HomeTileCategory({Key? key}) : super(key: key);

  @override
  _HomeTileCategoryState createState() => _HomeTileCategoryState();
}

class _HomeTileCategoryState extends State<HomeTileCategory> {
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
                Text('type fo food'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(202, 5, 5, 5),
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
