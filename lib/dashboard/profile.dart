import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/page/home_page_logout.dart';
import 'package:flutter_rrs_app/screen/showOwner.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? name, email, phonenumber;
  @override
  //initstate จะทำงานก่อน build
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    findUser();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString('name');
      email = preferences.getString('email');
      phonenumber = preferences.getString('phonenumber');
    });
  }

  @override
  Widget build(BuildContext context) {
    double wid = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kprimary,
        toolbarHeight: wid / 5,
        title: Center(child: Text("บัญชีผู้ใช้งาน")),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyHomePageOut()));
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration:
                  ShapeDecoration(color: ksecondary, shape: CircleBorder()),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  name == null ? 'Account' : '$name ',
                  style: TextStyle(fontSize: 15),
                )),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 450,
                          height: 350,
                          color: ksecondary,
                          child: Column(
                            children: [
                              Text(
                                name == null ? 'Account' : '$name ',
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                email == null ? 'email' : '$email ',
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                phonenumber == null
                                    ? 'phonenumber'
                                    : '$phonenumber ',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
