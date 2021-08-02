import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:flutter_rrs_app/widget/show_table_restaurant.dart';
import 'package:flutter_rrs_app/widget/time_picker_widget.dart';

import 'date_picker_widget.dart';
import 'datetime_picker_widget.dart';

class AboutRestaurant extends StatefulWidget {
  final ReadshopModel readshopModel;
  AboutRestaurant({Key? key, required this.readshopModel}) : super(key: key);
  @override
  _AboutRestaurantState createState() => _AboutRestaurantState();
}

class _AboutRestaurantState extends State<AboutRestaurant> {
  ReadshopModel? readshopModel;
  int index = 0;
  String? choosevalue;
  List myitems = [
    '1 people',
    '2 people',
    '3 people',
    '4 people',
    '5 people',
    '6 people',
    '7 people',
    '8 people',
  ];
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
              decoration: showImageRestaurant(),
            ),
          ],
        ),
        showNameRestaurant(),
        showPhonenumberRestaurant(),
        showNameBranchRestaurant(),
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
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          scrollable: true,
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              child: Column(
                                children: <Widget>[
                                  DropdownButton(
                                    hint: Text("Choose number of people"),
                                    icon: Icon(Icons.arrow_drop_down,
                                        color: Colors.grey),
                                    iconSize: 30,
                                    isExpanded: true,
                                    value: choosevalue,
                                    onChanged: (value) {
                                      setState(() {
                                        choosevalue = value.toString();
                                        print(value);
                                      });
                                    },
                                    items: myitems.map((newvalue) {
                                      return DropdownMenuItem(
                                        value: newvalue,
                                        child: Text(newvalue),
                                      );
                                    }).toList(),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(32),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        DatePickerWidget(),
                                        const SizedBox(height: 24),
                                        TimePickerWidget(),
                                        const SizedBox(height: 24),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                                child: Text("Next"), onPressed: () {})
                          ],
                        );
                      });
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

  Padding showNameBranchRestaurant() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Row(
        children: [
          MyStyle().showTitleH2('Name branch :'),
          Text(' ${readshopModel!.restaurantBranch}'),
        ],
      ),
    );
  }

  Padding showPhonenumberRestaurant() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Row(
        children: [
          MyStyle().showTitleH2('Phone number :'),
          Text(' ${readshopModel!.phonenumber}'),
        ],
      ),
    );
  }

  Padding showNameRestaurant() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Row(
        children: [
          MyStyle().showTitleH2('Name restaurant :'),
          Text(' ${readshopModel!.restaurantNameshop}'),
        ],
      ),
    );
  }

  BoxDecoration showImageRestaurant() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
            image: NetworkImage(
              '${Myconstant().domain}${readshopModel!.restaurantPicture}',
            ),
            fit: BoxFit.cover));
  }
}
