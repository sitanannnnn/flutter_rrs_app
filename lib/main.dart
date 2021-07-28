import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/page/select_login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        home: SelectLogin());
  }
}
