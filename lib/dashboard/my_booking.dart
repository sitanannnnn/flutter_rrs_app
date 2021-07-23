import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';

class MyBooking extends StatefulWidget {
  const MyBooking({Key? key}) : super(key: key);

  @override
  _MyBookingState createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking> {
  @override
  Widget build(BuildContext context) {
    double wid = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kprimary,
          toolbarHeight: wid / 5,
          title: Center(
            child: Text('My booking'),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBar(
            unselectedLabelColor: Colors.black,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50), color: kprimary),
            tabs: [
              Tab(
                text: 'not comfirm',
              ),
              Tab(
                text: 'verified',
              ),
              Tab(
                text: 'past booking',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
