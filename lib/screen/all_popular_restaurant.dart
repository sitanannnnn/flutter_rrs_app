import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/screen/show_restaurant.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class AllPopularReataurant extends StatefulWidget {
  const AllPopularReataurant({
    Key? key,
  }) : super(key: key);
  @override
  _AllPopularReataurantState createState() => _AllPopularReataurantState();
}

class _AllPopularReataurantState extends State<AllPopularReataurant> {
  List<ReadshopModel> readshopModels = [];
  List<String> distances = [];
  double? lat1, lng1, lat2, lng2, distance;
  late String distanceString;
  bool loadstate = true;
  @override
  void initState() {
    super.initState();
    readShop().then((value) => findLat1Lng1());
  }

//function อ่านค่าร้านอาหารที่มีอยูในฐานข้อมูล
  Future<Null> readShop() async {
    String url =
        '${Myconstant().domain_00webhost}/getRestaurantFromchooseType.php?isAdd=true&chooseType=Shop';
    await Dio().get(url).then((value) {
      // print('value=$value');
      var result = json.decode(value.data);

      for (var map in result) {
        ReadshopModel model = ReadshopModel.fromJson(map);

        String? NameShop = model.restaurantNameshop;
        if (NameShop!.isNotEmpty) {
          print('NameShop =${model.restaurantNameshop}');

          setState(() {
            loadstate = false;
            readshopModels.add(model);
          });
        }
      }
    });
  }

  //function หา ตำเเหน่งของลูกค้า และ ร้านอาหาร
  Future<Null> findLat1Lng1() async {
    LocationData? locationData = await findLocationData();
    setState(() {
      lat1 = locationData!.latitude;
      lng1 = locationData.longitude;
    });
    for (int index = 0; index < readshopModels.length; index++) {
      setState(() {
        lat2 = double.parse(readshopModels[index].latitude.toString());
        lng2 = double.parse(readshopModels[index].longitude.toString());
        print('lat2 = ${lat2.toString()}, lng2 = ${lng2.toString()}');
        distance = calculateDistance(lat1!, lng1!, lat2!, lng2!);

        var myFormat = NumberFormat('#0.0#', 'en_US');
        distanceString = myFormat.format(distance);
        distances.add(distanceString);
      });
    }
  }

//คำนวณระยะห่างจากลูกค้า กับ ร้านอาหาร
  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    double distance = 0;
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    distance = 12742 * asin(sqrt(a));
    return distance;
  }

  //เก็บตำเเหน่งปัจจุบันของลูกค้า
  Future<LocationData?> findLocationData() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kprimary,
          title: Text('Popular restaurant '),
        ),
        body: loadstate == true
            ? MyStyle().showProgrsee()
            : ListView.builder(
                itemCount: readshopModels.length,
                itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        print('You click index $index');

                        MaterialPageRoute route = MaterialPageRoute(
                          builder: (context) => ShowRestaurant(
                            readshopModel: readshopModels[index],
                          ),
                        );
                        Navigator.push(context, route);
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 350,
                                      height: 250,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                '${Myconstant().domain_restaurantPic}${readshopModels[index].restaurantPicture}',
                                              ),
                                              fit: BoxFit.cover)),
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.all(8.0)),
                                  Text(
                                      'Name restaurant : ${readshopModels[index].restaurantNameshop}'),
                                  Text(
                                      'Name branch :${readshopModels[index].restaurantBranch}'),
                                  Text(
                                      'Type of food :${readshopModels[index].typeOfFood}'),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(Icons.location_on_rounded),
                                        distances.length == 0
                                            ? MyStyle().showProgrsee()
                                            : Text('${distances[index]} km')
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    )));
  }
}
