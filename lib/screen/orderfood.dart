import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/screen/restaurant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';

class OrderFood extends StatefulWidget {
  OrderFood({Key? key}) : super(key: key);

  @override
  _OrderFoodState createState() => _OrderFoodState();
}

class _OrderFoodState extends State<OrderFood> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kprimary,
        title: Text('Type Of Food'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/images/thaifood.jpg'),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Restaurant()));
                  },
                  child: Text("Thai Food")),
              Image.asset('assets/images/thaifood.jpg'),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Restaurant()));
                  },
                  child: Text("Chinese Food")),
              Image.asset('assets/images/thaifood.jpg'),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Restaurant()));
                  },
                  child: Text("Indain Food")),
              Image.asset('assets/images/thaifood.jpg'),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Restaurant()));
                  },
                  child: Text("Jananese Food")),
              Image.asset('assets/images/thaifood.jpg'),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Restaurant()));
                  },
                  child: Text("Isaan Food")),
            ],
          ),
        ),
      ),
    );
  }
}
