import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceInfo {
  Future<Map> getInfo(context) async {
    double dvw = MediaQuery.of(context).size.width;
    double dvh = MediaQuery.of(context).size.height;
    int width = dvw.ceil(), height = dvh.ceil();
    String _os, _os_Version, _model, _brand, _dimension, _id;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      _os = "Android";
      _id = androidInfo.id;
      _os_Version = androidInfo.version.sdkInt.toString();
      _model = androidInfo.model;
      _brand = androidInfo.brand;
      _dimension = '$width X $height';
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      _os = iosInfo.systemName;
      _id = iosInfo.identifierForVendor;
      _os_Version = iosInfo.systemVersion;
      _model = iosInfo.model;
      _brand = iosInfo.utsname.machine;
      _dimension = '$width x $height';
    }

    Map details = {
      "os": _os,
      "version": _os_Version,
      "model": _model,
      "brand": _brand,
      "dimension": _dimension,
      "device_id": _id
    };
    return details;
  }

  Future<Map> getPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    var _packageInfo = info;
    Map app = {
      "v_name": "${_packageInfo.version}",
      "v_code": "${_packageInfo.buildNumber}",
    };
    return app;
  }
}
