import 'package:flutter/material.dart';

Map<String, dynamic> errorhandler([Map<String, dynamic>? data]) {
  return {
    'status': false,
    'message': data == null ? "failed" : data['message']
  };
}

Map<String, dynamic> excephandler(String place, var e) {
  debugPrint("$place excep catch : $e");
  return {'status': false, 'message': "excep error"};
}
