import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
/// format `isoDate`
String convertDate(String isoDate) {
  if (isoDate == '') {
    return '';
  }
  final parsedDate = DateTime.parse(isoDate);
  final DateTime dateTime = DateTime.now();
  if (dateTime.difference(parsedDate).inDays == 0) {
    return 'Today';
  } else if (dateTime.difference(parsedDate).inDays == 1) {
    return 'Yesterday';
  } else {
    return DateFormat('MM/dd/yyyy').format(parsedDate);
  }
}

