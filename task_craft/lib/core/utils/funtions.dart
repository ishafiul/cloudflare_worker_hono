import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:task_craft/api/export.dart';

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

Future<ObjectDto> rawDeviceInfo() async {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  final token = await FirebaseMessaging.instance.getToken();
  if (Platform.isAndroid) {
    final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return ObjectDto(
      deviceType: 'android',
      osName: androidInfo.version.sdkInt.toString(),
      osVersion: androidInfo.version.sdkInt.toString(),
      appVersion: '0.1.1',
      isPhysicalDevice: androidInfo.isPhysicalDevice,
      ipAddress: '',
      fcmToken: token ?? '',
      deviceModel: androidInfo.model,
    );
  }
  if (Platform.isIOS) {
    final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return ObjectDto(
      deviceType: 'ios',
      osName: iosInfo.systemName,
      osVersion: iosInfo.systemVersion,
      appVersion: '0.1.1',
      isPhysicalDevice: iosInfo.isPhysicalDevice,
      ipAddress: '',
      fcmToken: token ?? '',
      deviceModel: iosInfo.model,
    );
  }
  return ObjectDto(
    deviceType: 'android',
    osName: 'android',
    osVersion: 'android',
    appVersion: 'android',
    isPhysicalDevice: true,
    ipAddress: '',
    deviceModel: '',
    fcmToken: token ?? '',
  );
}
