import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/read_shop_model.dart';
import 'package:flutter_rrs_app/model/table_model.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';
import 'package:flutter_rrs_app/utility/normal_dialog.dart';
import 'package:flutter_rrs_app/widget/show_table_restaurant.dart';
import 'package:google_fonts/google_fonts.dart';

class Reservation extends StatefulWidget {
  final ReadshopModel readshopModel;
  Reservation({Key? key, required this.readshopModel}) : super(key: key);
  @override
  _ReservationState createState() => _ReservationState();
}

class _ReservationState extends State<Reservation> {
  ReadshopModel? readshopModel;
  DateTime? pickerDate;
  TimeOfDay? time;
  TableModel? tableModel;
  String? customerId,
      restaurantId,
      numberOfGueste,
      reservationDate,
      reservationTime,
      restaurantNameshop,
      timeFormat,
      tableResId;
  int index = 0;
  String? choosevalue;
  List myitems = [
    '1 people',
    '2 people',
    '3 people',
    '4 people',
    '5 people',
    '6 people',
    '7 people',
    '8 people',
  ];
  @override
  void initState() {
    super.initState();
    pickerDate = DateTime.now();
    time = TimeOfDay.now();
    readshopModel = widget.readshopModel;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kprimary,
        title: Text(' ${readshopModel!.restaurantNameshop}'),
      ),
      body: SingleChildScrollView(
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
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Row(
                children: [
                  MyStyle().showTitleH2('Type of food :'),
                  Text(' ${readshopModel!.typeOfFood}'),
                ],
              ),
            ),
            Divider(
              height: 10,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 300,
                    height: 300,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 300,
                            height: 50,
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: kprimary, width: 4)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                hint: Text("Choose number of people"),
                                icon: Icon(Icons.keyboard_arrow_down,
                                    color: Colors.grey),
                                iconSize: 30,
                                isExpanded: true,
                                value: choosevalue,
                                onChanged: (value) {
                                  setState(() {
                                    choosevalue = value.toString();
                                    print(choosevalue);
                                  });
                                },
                                items: myitems.map((newvalue) {
                                  return DropdownMenuItem(
                                    value: newvalue,
                                    child: Text(newvalue),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 300,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(color: kprimary, width: 4)),
                                child: ListTile(
                                  title: Text(
                                      "Date  ${pickerDate!.day}/${pickerDate!.month}/${pickerDate!.year}"),
                                  trailing: Icon(Icons.keyboard_arrow_down),
                                  onTap: _pickDate,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                width: 300,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(color: kprimary, width: 4)),
                                child: ListTile(
                                  title: Text(
                                      "Time  ${time!.hour}:${time!.minute}"),
                                  trailing: Icon(Icons.keyboard_arrow_down),
                                  onTap: _pickTime,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                width: 300,
                                height: 40,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: kprimary,
                                        onPrimary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)))),
                                    onPressed: () {
                                      if (choosevalue == null) {
                                        normalDialog(context,
                                            "Please complete the information");
                                      } else {
                                        // recordReservation();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ShowTable(
                                                      readshopModel:
                                                          readshopModel!,
                                                      choosevalue: choosevalue!,
                                                      date: '$pickerDate',
                                                      pickertime: '$time',
                                                    )));
                                      }
                                    },
                                    child: Text('Next',
                                        style: GoogleFonts.lato(fontSize: 20))),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
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

  _pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
      initialDate: pickerDate!,
    );
    if (date != null) {
      setState(() {
        pickerDate = date;
        // print(date);
      });
    }
  }

  _pickTime() async {
    TimeOfDay? pickertime = await showTimePicker(
      context: context,
      initialTime: time!,
    );
    if (time != null) {
      setState(() {
        time = pickertime;
        time.toString().substring(10, 15);
        // print('time if ==> $time');
      });
    }
    setState(() {
      timeFormat = time.toString().substring(10, 15);
      // print('Time format ==> $timeFormat');
    });
  }
}
