import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:flutter_rrs_app/widget/about_restaurant.dart';
import 'package:flutter_rrs_app/widget/show_menu_food.dart';

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
    listWidgets!.add(AboutRestaurant());
    listWidgets!.add(ShowMenuFood());
  }

  BottomNavigationBarItem aboutRestaurantNav() {
    return BottomNavigationBarItem(
        icon: Icon(Icons.fastfood), title: Text("about the restaurant"));
  }

  BottomNavigationBarItem showMenuFoodNav() {
    return BottomNavigationBarItem(
        icon: Icon(Icons.restaurant_menu), title: Text("food menu"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kprimary,
        title: Text(' ${readshopModel!.restaurantNameshop}'),
      ),
      body: listWidgets!.length == 0
          ? MyStyle().showLogotable()
          : listWidgets![indexPage],
      bottomNavigationBar: showBottomNavigationBar(),
    );
  }

  BottomNavigationBar showBottomNavigationBar() {
    return BottomNavigationBar(
      selectedItemColor: Colors.white,
      backgroundColor: kprimary,
      currentIndex: indexPage,
      onTap: (value) {
        setState(() {
          indexPage = value;
        });
      },
      items: <BottomNavigationBarItem>[aboutRestaurantNav(), showMenuFoodNav()],
    );
  }
}
