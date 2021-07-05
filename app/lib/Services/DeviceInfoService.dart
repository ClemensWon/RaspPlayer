
import 'package:device_info/device_info.dart';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:raspplayer_app/Services/UserData.dart';

class DeviceInfoService {
  final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();

  Future<String> getDeviceId() async {
    try {
      //gets the device id from android devices
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        UserData.deviceID = build.androidId;
        return build.androidId;
      }
      //gets the device id from ios devices
      if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        UserData.deviceID = data.identifierForVendor;
        return data.identifierForVendor;
      }
      throw PlatformException(code: "");
    } on PlatformException {
      print("could not get ID");
      return "";
    }
  }

}