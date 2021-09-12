// showDialog(
//         context: context,
//         builder: (context) => StatefulBuilder(
//               builder: (context, setState) => AlertDialog(
//                 title: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Column(
//                       children: [
//                         Text(foodmenuModels[index].foodmenuName!),
//                       ],
//                     ),
//                   ],
//                 ),
//                 content: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       width: 150,
//                       height: 130,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           image: DecorationImage(
//                               image: NetworkImage(
//                                   '${Myconstant().domain}${foodmenuModels[index].foodmenuPicture!}'),
//                               fit: BoxFit.cover)),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         IconButton(
//                           onPressed: () {
//                             if (amount > 1) {
//                               setState(() {
//                                 amount--;
//                               });
//                             }
//                           },
//                           icon: Icon(
//                             Icons.remove_circle,
//                             color: Colors.red,
//                           ),
//                           iconSize: 30,
//                         ),
//                         Text(amount.toString()),
//                         IconButton(
//                           onPressed: () {
//                             setState(() {
//                               amount++;
//                             });
//                           },
//                           icon: Icon(
//                             Icons.add_circle,
//                             color: Colors.green,
//                           ),
//                           iconSize: 30,
//                         )
//                       ],
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           Container(
//                             width: 90,
//                             child: ElevatedButton(
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                                 child: Text('Cancle')),
//                           ),
//                           Container(
//                             width: 90,
//                             child: ElevatedButton(
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                                 child: Text('Order')),
//                           )
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ));