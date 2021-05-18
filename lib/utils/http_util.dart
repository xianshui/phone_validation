import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

class HttpUtil {

  static final accountSid = 'AC79887a29f1e93a23b9776bc19a40f459';
  static final authorToken = 'f6f2420aed7147ebc8be008622c51098';

  static final HttpUtil singleton = HttpUtil._internal();
  final Dio dio = Dio();

  factory HttpUtil() {
    return singleton;
  }

  HttpUtil._internal();

  Future validatePhoneNumber(String number) async {
    try {

      var str = '$accountSid:$authorToken';
      var bytes = utf8.encode(str);
      var base64Str = base64.encode(bytes);

      Response response = await dio.get('https://lookups.twilio.com/v1/PhoneNumbers/${number}',
          options: Options(headers: {'Authorization': 'Basic $base64Str'}),);
      //print(response);

      if (response.statusCode == 200) {
        print(response.data);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}