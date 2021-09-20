import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/screen/show_cancel_order_food.dart';
import 'package:flutter_rrs_app/screen/show_cancel_table_reservation.dart';
import 'package:flutter_rrs_app/screen/show_completed_orderfood.dart';
import 'package:flutter_rrs_app/screen/show_completed_reservation.dart';
import 'package:flutter_rrs_app/screen/show_confirm_order_food.dart';
import 'package:flutter_rrs_app/screen/show_confirm_table_reservation.dart';
import 'package:flutter_rrs_app/screen/show_unconfirmed_order_food.dart';

import 'package:flutter_rrs_app/screen/show_unconfirmed_table_reservation.dart';

import 'package:flutter_rrs_app/utility/my_style.dart';

class MyBooking extends StatefulWidget {
  const MyBooking({
    Key? key,
  }) : super(key: key);

  @override
  _MyBookingState createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    double wid = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kprimary,
          toolbarHeight: wid / 4,
          title: Center(
              child: Text(
            'My booking',
            style: TextStyle(color: Colors.white),
          )),
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.white,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50), color: ksecondary),
            tabs: [
              Tab(
                text: 'table reservation',
              ),
              Tab(
                text: 'confirm reservation ',
              ),
              Tab(
                text: 'reservation was canceled ',
              ),
              Tab(
                text: 'reservation completed ',
              ),
              Tab(
                text: 'order food',
              ),
              Tab(
                text: 'order comfirm ',
              ),
              Tab(
                text: 'order was canceled ',
              ),
              Tab(
                text: 'order completed ',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ShowUnconfirmedTableReservation(),
            ShowConfirmTableReservation(),
            ShowCancelTableReservation(),
            ShowCompletedTableReservation(),
            ShowUnconfirmedOrderFood(),
            ShowConfirmedOrderFood(),
            ShowCancelOrderFood(),
            ShowCompletedOrderFood()
          ],
        ),
      ),
    );
  }
}
