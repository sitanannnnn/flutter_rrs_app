import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';

class Reservation extends StatefulWidget {
  final ReadshopModel readshopModel;

  Reservation({Key? key, required this.readshopModel}) : super(key: key);
  @override
  _ReservationtState createState() => _ReservationtState();
}

class _ReservationtState extends State<Reservation> {
  ReadshopModel? readshopModel;

  String? _chosenValue;
  @override
  void initState() {
    super.initState();
    readshopModel = widget.readshopModel;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kprimary,
        title: Text(' ${readshopModel!.restaurantNameshop}'),
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(16.0),
                  width: 350.0,
                  height: 250.0,
                  child: Image.network(
                    '${Myconstant().domain}${readshopModel!.restaurantPicture}',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(0.0),
                child: DropdownButton<String>(
                  value: _chosenValue,
                  //elevation: 5,
                  style: TextStyle(color: Colors.black),

                  items: <String>[
                    '1 Person',
                    '2 Person',
                    '3 Person',
                    '4 Person',
                    '5 Person',
                    '6 Person',
                    '7 Person',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  hint: Text(
                    "Please choose number of people",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _chosenValue = value;
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
