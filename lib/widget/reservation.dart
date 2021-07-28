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

  get child => null;
  @override
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
                height: 300,
                width: 290,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
