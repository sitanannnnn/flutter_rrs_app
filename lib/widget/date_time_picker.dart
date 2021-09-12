// import 'package:flutter/material.dart';

// class DateTimePicker extends StatefulWidget {
//   const DateTimePicker({Key? key}) : super(key: key);

//   @override
//   _DateTimePickerState createState() => _DateTimePickerState();
// }

// class _DateTimePickerState extends State<DateTimePicker> {
//   DateTime? pickerDate;
//   TimeOfDay? time;
//   @override
//   void initState() {
//     super.initState();
//     pickerDate = DateTime.now();
//     time = TimeOfDay.now();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ListTile(
//           title: Text(
//               "Date :${pickerDate!.year},${pickerDate!.month},${pickerDate!.day}"),
//           trailing: Icon(Icons.keyboard_arrow_down),
//           onTap: _pickDate,
//         ),
//           ListTile(
//           title: Text(
//               "Time :${time!.hour}:${time!.minute}"),
//           trailing: Icon(Icons.keyboard_arrow_down),
//           onTap: _pickTime,
//         ),
//       ],
//     );
//   }

//   _pickDate() async {
//     DateTime? date = await showDatePicker(
//       context: context,
//       firstDate: DateTime(DateTime.now().year - 10),
//       lastDate: DateTime(DateTime.now().year + 10),
//       initialDate: pickerDate!,
//     );
//     if (date != null) {
//       setState(() {
//         pickerDate = date;
//       });
//     }
//   }
//     _pickTime() async {
//     TimeOfDay?  t= await showTimePicker(
//       context: context,
//       initialTime: time!,
//     );
//     if (time != null) {
//       setState(() {
//         time = t;
//       });
//     }
//   }
// }
