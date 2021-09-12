import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/screen/category_food.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:google_fonts/google_fonts.dart';

class TypeOfFood extends StatefulWidget {
  TypeOfFood({Key? key}) : super(key: key);
  @override
  _TypeOfFoodState createState() => _TypeOfFoodState();
}

class _TypeOfFoodState extends State<TypeOfFood> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kprimary,
          title: Text('Type Of Food'),
        ),
        body: Container(
          child: Categories(),
        ));
  }
}

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final list_item = [
    {"name": "Asian Fusin", "picture": "assets/food/1.jpg"},
    {"name": "Bagels", "picture": "assets/food/2.jpg"},
    {"name": "Bakery", "picture": "assets/food/3.jpg"},
    {"name": "Breakfast", "picture": "assets/food/4.jpg"},
    {"name": "Brunch", "picture": "assets/food/6.jpg"},
    {"name": "Buffets", "picture": "assets/food/7.jpg"},
    {"name": "Burgers", "picture": "assets/food/8.jpg"},
    {"name": "Cajun/Creole", "picture": "assets/food/9.jpg"},
    {"name": "Chinese", "picture": "assets/food/10.jpg"},
    {"name": "Coffee/Espresso", "picture": "assets/food/11.jpg"},
    {"name": "Ice Cream", "picture": "assets/food/12.jpg"},
    {"name": "Indian", "picture": "assets/food/13.jpg"},
    {"name": "Italian", "picture": "assets/food/15.jpg"},
    {"name": "Japanese", "picture": "assets/food/16.jpg"},
    {"name": "Latin American", "picture": "assets/food/17.jpg"},
    {"name": "Mediterranean", "picture": "assets/food/18.jpg"},
    {"name": "Pizza", "picture": "assets/food/19.jpg"},
    {"name": "Fast Food", "picture": "assets/food/20.jpg"},
    {"name": "Fine Dining", "picture": "assets/food/21.jpg"},
    {"name": "French", "picture": "assets/food/22.jpg"},
    {"name": "German", "picture": "assets/food/23.jpg"},
    {"name": "Lao", "picture": "assets/food/24.jpg"},
    {"name": "Seafood", "picture": "assets/food/25.jpg"},
    {"name": "Spanish", "picture": "assets/food/26.jpg"},
    {"name": "Steaks", "picture": "assets/food/27.jpg"},
    {"name": "Thai ", "picture": "assets/food/28.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: list_item.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return Category(
            category_name: list_item[index]['name'],
            category_picture: list_item[index]['picture'],
          );
        });
  }
}

class Category extends StatelessWidget {
  final category_name;
  final category_picture;
  Category({this.category_name, this.category_picture});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
          tag: category_name,
          child: Material(
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CategoryFood(category_name: '$category_name')));
                print('type of food ==>$category_name');
              },
              child: GridTile(
                  footer: Container(
                    color: Colors.white,
                    child: ListTile(
                      leading: Text(category_name,
                          style: GoogleFonts.lato(fontSize: 15)),
                    ),
                  ),
                  child: Image.asset(
                    category_picture,
                    fit: BoxFit.cover,
                  )),
            ),
          )),
    );
  }
}
