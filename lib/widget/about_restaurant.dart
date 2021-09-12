import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:flutter_rrs_app/widget/reservation.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutRestaurant extends StatefulWidget {
  final ReadshopModel readshopModel;
  AboutRestaurant({Key? key, required this.readshopModel}) : super(key: key);
  @override
  _AboutRestaurantState createState() => _AboutRestaurantState();
}

class _AboutRestaurantState extends State<AboutRestaurant> {
  ReadshopModel? readshopModel;

  @override
  void initState() {
    super.initState();
    readshopModel = widget.readshopModel;
  }

  Widget build(BuildContext context) {
    return Column(
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
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Row(
            children: [
              MyStyle().showTitleH2('Type of food :'),
              Text(' ${readshopModel!.typeOfFood}'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: kprimary,
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
        )
      ],
    );
  }

  Padding showNameBranchRestaurant() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Row(
        children: [
          MyStyle().showTitleH2('Name branch :'),
          Text(' ${readshopModel!.restaurantBranch}'),
        ],
      ),
    );
  }

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

  BoxDecoration showImageRestaurant() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
            image: NetworkImage(
              '${Myconstant().domain}${readshopModel!.restaurantPicture}',
            ),
            fit: BoxFit.cover));
  }
}
