import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

Future<void> normalDialog(BuildContext context, String message) async {
  showDialog(
      context: context,
      builder: (context) => SimpleDialog(
            title: Text(message),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'OK',
                        style: TextStyle(color: Colors.red),
                      )),
                ],
              )
            ],
          ));
}

Future<void> locationnormalDialog(BuildContext context, String message) async {
  showDialog(
      context: context,
      builder: (context) => SimpleDialog(
            title: Text(message),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () async {
                        // Navigator.pop(context);
                        await Geolocator.openLocationSettings();
                        exit(0);
                      },
                      child: Text('OK'))
                ],
              )
            ],
          ));
}
