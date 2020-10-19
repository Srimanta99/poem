import 'dart:io';

import 'package:flutter/cupertino.dart';

class Checkinternet{
  static bool IsINternetAvalible=false;
  static Future<bool> isinternetAvalible(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        IsINternetAvalible=true;
        return true;
        //connected
      }else{
        IsINternetAvalible=false;
        return false;
        //notconnected
      }
    } on SocketException catch (_) {
      print('not connected');
      IsINternetAvalible=false;
      return false;
    }

  }
}