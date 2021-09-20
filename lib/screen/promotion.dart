import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/screen/promotion_orderfood.dart';
import 'package:flutter_rrs_app/screen/promotion_reserve_table.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';

class Promotion extends StatefulWidget {
  const Promotion({
    Key? key,
  }) : super(key: key);

  @override
  _PromotionState createState() => _PromotionState();
}

class _PromotionState extends State<Promotion> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    double wid = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kprimary,
          toolbarHeight: wid / 4,
          title: Center(
              child: Text(
            'Promotion',
            style: TextStyle(color: Colors.white),
          )),
          bottom: TabBar(
            // isScrollable: true,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.white,

            tabs: [
              Tab(
                text: 'Reserve a table ',
              ),
              Tab(
                text: 'Order food',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PromotionReserveTable(),
            PromotionOrderfood(),
          ],
        ),
      ),
    );
  }
}
