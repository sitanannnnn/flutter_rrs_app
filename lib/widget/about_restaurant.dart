import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';

import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:flutter_rrs_app/widget/reservation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class AboutRestaurant extends StatefulWidget {
  final ReadshopModel readshopModel;
  AboutRestaurant({Key? key, required this.readshopModel}) : super(key: key);
  @override
  _AboutRestaurantState createState() => _AboutRestaurantState();
}

class _AboutRestaurantState extends State<AboutRestaurant> {
  ReadshopModel? readshopModel;
  double? lat1, lng1, lat2, lng2, distance;
  String? distanceString;
  CameraPosition? position;

  @override
  void initState() {
    super.initState();
    readshopModel = widget.readshopModel;
    findLat1Lng1();
  }

//function หา ตำเเหน่งของร้านอาหาร
  Future<Null> findLat1Lng1() async {
    LocationData? locationData = await findLocationData();
    setState(() {
      lat1 = locationData!.latitude;
      print('$lat1');
      lng1 = locationData.longitude;
      print('$lng1');
      lat2 = double.parse(readshopModel!.latitude!);
      lng2 = double.parse(readshopModel!.longitude!);
      print('lat1 = $lat1, lng1 = $lng1, lat2 = $lat2, lng2 = $lng2');
      distance = calculateDistance(lat1!, lng1!, lat2!, lng2!);

      var myFormat = NumberFormat('#0.0#', 'en_US');
      distanceString = myFormat.format(distance);

      print('distance = $distance');
    });
  }

//คำนวณระยะห่างจากลูกค้า กับ ร้านอาหาร
  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    double distance = 0;
    {}
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    distance = 12742 * asin(sqrt(a));

    return distance;
  }

  Future<LocationData?> findLocationData() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } catch (e) {
      return null;
    }
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
          showTypeofFoodRestaurant(),
          showPromotionRestaurant(),
          showdistanceRestaurant(),
          showMap(),
          // SizedBox(
          //   height: 70,
          // ),
          Column(
            children: [
              Container(
                width: 300,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)))),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Reservation(readshopModel: readshopModel!)));
                  },
                  child: Text('Reserve', style: GoogleFonts.lato(fontSize: 20)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

// เเสดงเเผนที่
  Container showMap() {
    if (lat1 != null) {
      LatLng latLng1 = LatLng(lat1!, lng2!);
      position = CameraPosition(
        target: latLng1,
        zoom: 10.0,
      );
    }
//เเสดงตำเเหน่งที่ลูกค้าอยู่
    Marker userMarker() {
      return Marker(
        markerId: MarkerId('userMarker'),
        position: LatLng(lat1!, lng1!),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: 'You are here'),
      );
    }

//เเสดงตำเเหน่งของร้านอาหาร
    Marker shopMarker() {
      return Marker(
        markerId: MarkerId('shopMarker'),
        position: LatLng(lat2!, lng2!),
        icon: BitmapDescriptor.defaultMarkerWithHue(30.0),
        infoWindow: InfoWindow(
            title: ' restaurant ${readshopModel!.restaurantNameshop}'),
      );
    }

    Set<Marker> mySet() {
      return <Marker>[userMarker(), shopMarker()].toSet();
    }

    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 32),
      // color: Colors.grey,
      height: 250,
      child: lat1 == null
          ? MyStyle().showProgrsee()
          : GoogleMap(
              initialCameraPosition: position!,
              myLocationEnabled: true,
              mapType: MapType.normal,
              onMapCreated: (controller) {},
              markers: mySet(),
            ),
    );
  }

// show distance restaurant
  Padding showdistanceRestaurant() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(Icons.location_on),
          distance == null ? Text("") : Text('$distanceString km'),
        ],
      ),
    );
  }

//show promotion
  Padding showPromotionRestaurant() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Row(
        children: [
          MyStyle().showTitleH2('Promotion :'),
          readshopModel!.promotionType == null
              ? Text('   -  ', style: GoogleFonts.lato(fontSize: 20))
              : Text(' ${readshopModel!.promotionType}'),
        ],
      ),
    );
  }

//shoe Type of food
  Padding showTypeofFoodRestaurant() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Row(
        children: [
          MyStyle().showTitleH2('Type of food :'),
          Text(' ${readshopModel!.typeOfFood}'),
        ],
      ),
    );
  }

//show branch restaurant
  Padding showNameBranchRestaurant() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Row(
        children: [
          MyStyle().showTitleH2('Name branch :'),
          readshopModel!.restaurantBranch == 'null'
              ? Text('  -')
              : Text(' ${readshopModel!.restaurantBranch}'),
        ],
      ),
    );
  }

//show phonenumber restaurant
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

//show name restaurant
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

//show image restaurant
  BoxDecoration showImageRestaurant() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
            image: NetworkImage(
              '${Myconstant().domain_restaurantPic}${readshopModel!.restaurantPicture}',
            ),
            fit: BoxFit.cover));
  }
}
