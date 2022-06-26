import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

showCustomFlushBar(context, String msg, int duration) {
  Flushbar(
    margin: EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
    message: msg,
    icon: Icon(
      Icons.info_outline,
      size: 20,
      color: Colors.lightBlue[800],
    ),
    duration: Duration(seconds: duration),
  ).show(context);
}
