import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';

class AboutRestaurant extends StatefulWidget {
  final ReadshopModel readshopModel;
  AboutRestaurant({Key? key, required this.readshopModel}) : super(key: key);
  @override
  _AboutRestaurantState createState() => _AboutRestaurantState();
}

class _AboutRestaurantState extends State<AboutRestaurant> {
  ReadshopModel? readshopModel;

  @override
  void initState() {
    super.initState();
    readshopModel = widget.readshopModel;
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(16.0),
              width: 350.0,
              height: 250.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: NetworkImage(
                        '${Myconstant().domain}${readshopModel!.restaurantPicture}',
                      ),
                      fit: BoxFit.cover)),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Row(
            children: [
              MyStyle().showTitleH2('Name restaurant :'),
              Text(' ${readshopModel!.restaurantNameshop}'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Row(
            children: [
              MyStyle().showTitleH2('Phone number :'),
              Text(' ${readshopModel!.phonenumber}'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Row(
            children: [
              MyStyle().showTitleH2('Name branch :'),
              Text(' ${readshopModel!.restaurantBranch}'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Row(
            children: [
              MyStyle().showTitleH2('Type of food :'),
              Text(' ${readshopModel!.typeOfFood}'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: kprimary,
                  onPrimary: Colors.white,
                ),
                onPressed: () {
                  reservationRestaurant();
                },
                child: Text(
                  'Reserve',
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<Null> reservationRestaurant() async {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Column(
                children: [],
              ),
            ));
  }
}
