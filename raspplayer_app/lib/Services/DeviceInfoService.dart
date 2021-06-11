
import 'package:device_info/device_info.dart';
import 'dart:io';

import 'package:flutter/services.dart';

class DeviceInfoService {
  final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();

  Future<String> getDeviceId() async {
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        return build.androidId;
      }
      if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        return data.identifierForVendor;
      }
      throw PlatformException(code: "");
    } on PlatformException {
      print("could not get ID");
      return "";
    }
  }

}