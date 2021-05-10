import 'package:flutter/material.dart';
import './widgets/country_selector.dart';
import './constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toast/toast.dart';
import './http_util.dart';

class HistoryPage extends StatelessWidget {
  final List<String> phoneNumbers;

  HistoryPage({Key key, this.phoneNumbers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (ScreenUtil() == null) {
      ScreenUtil.init(context, width: 360, height: 640, allowFontScaling: false);
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(48.w),
        child: AppBar(
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 1,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            'Validation history',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 16.w,
            ),
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        color: Colors.white,
        child: SafeArea(
            child: ListView.builder(
              itemCount: phoneNumbers.length,
              itemBuilder: (context, index) {
                var item = phoneNumbers[index];

                return Container(
                  padding: EdgeInsets.all(20.w),
                  margin: EdgeInsets.symmetric(horizontal: 0.w),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 1, color: Color(0xffe8e8e8)))
                  ),
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 14.w,
                    ),
                  ),
                );
              },
            )
        ),      ),
    );
  }
}

