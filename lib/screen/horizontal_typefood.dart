import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/screen/category_tpyefood.dart';
import 'package:google_fonts/google_fonts.dart';

class HorizontalTypefood extends StatelessWidget {
  const HorizontalTypefood({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Category(
              image_location: 'assets/food/1.jpg',
              caption_location: 'Asian Fusin'),
          Category(
              image_location: 'assets/food/2.jpg', caption_location: 'Bagels'),
          Category(
              image_location: 'assets/food/3.jpg', caption_location: 'Bakery'),
          Category(
              image_location: 'assets/food/4.jpg',
              caption_location: 'Breakfast'),
          Category(
              image_location: 'assets/food/6.jpg', caption_location: 'Brunch'),
          Category(
              image_location: 'assets/food/7.jpg', caption_location: 'Buffets'),
          Category(
              image_location: 'assets/food/8.jpg', caption_location: 'Burgers'),
          Category(
              image_location: 'assets/food/9.jpg',
              caption_location: 'Cajun/Creole'),
          Category(
              image_location: 'assets/food/10.jpg',
              caption_location: 'Chinese'),
          Category(
              image_location: 'assets/food/11.jpg',
              caption_location: 'Coffee/Espresso'),
          Category(
              image_location: 'assets/food/12.jpg',
              caption_location: 'Ice Cream'),
          Category(
              image_location: 'assets/food/13.jpg', caption_location: 'Indian'),
          Category(
              image_location: 'assets/food/15.jpg',
              caption_location: 'Italian'),
          Category(
              image_location: 'assets/food/16.jpg',
              caption_location: 'Japanese'),
          Category(
              image_location: 'assets/food/17.jpg',
              caption_location: 'Latin American'),
          Category(
              image_location: 'assets/food/18.jpg',
              caption_location: 'Mediterranean'),
          Category(
              image_location: 'assets/food/19.jpg', caption_location: 'Pizza'),
          Category(
              image_location: 'assets/food/20.jpg',
              caption_location: 'Fast Food'),
          Category(
              image_location: 'assets/food/21.jpg',
              caption_location: 'Fine Dining'),
          Category(
              image_location: 'assets/food/22.jpg', caption_location: 'French'),
          Category(
              image_location: 'assets/food/23.jpg', caption_location: 'German'),
          Category(
              image_location: 'assets/food/24.jpg', caption_location: 'Lao'),
          Category(
              image_location: 'assets/food/25.jpg',
              caption_location: 'Seafood'),
          Category(
              image_location: 'assets/food/26.jpg',
              caption_location: 'Spanish'),
          Category(
              image_location: 'assets/food/27.jpg', caption_location: 'Steaks'),
          Category(
              image_location: 'assets/food/28.jpg', caption_location: 'thai'),
        ],
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String image_location;
  final String caption_location;
  const Category(
      {Key? key, required this.image_location, required this.caption_location})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CategoryTypefood(caption_location: caption_location)));
          print('type of food ==>$caption_location');
        },
        child: Card(
          child: Column(
            children: [
              Container(
                width: 150,
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    image: DecorationImage(
                        image: AssetImage(
                          '$image_location',
                        ),
                        fit: BoxFit.cover)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '$caption_location',
                  style: GoogleFonts.lato(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
