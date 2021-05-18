import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/country_selector.dart';
import '../constants.dart';
import '../utils/http_util.dart';
import 'history_page.dart';
import '../models/theme_model.dart';
import 'package:provider/provider.dart';

class ValidationPage extends StatefulWidget {
  ValidationPage({Key key, this.title}) : super(key: key);
  final String title;


  @override
  _ValidationPageState createState() => _ValidationPageState();
}

class _ValidationPageState extends State<ValidationPage> {
  String countryCode = 'CN';
  List<String> countryCodes = ['HK', 'CN', 'KR', 'US', 'GB', 'AU'];
  TextEditingController codeEditingController = TextEditingController();
  TextEditingController controller = TextEditingController();
  String phoneNum = '';
  List<String> phoneNumbers = [];
  String status = '';

  static void showToast(String content, BuildContext context) {
    Toast.show(content, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
  }

  @override
  void initState() {
    super.initState();

    countryCode = 'HK';
    codeEditingController.text = '+852';

    readHistory();
  }

  void readHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    phoneNumbers = await prefs.getStringList('phone_numbers') ?? [];
  }

  void saveHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('phone_numbers', phoneNumbers);
  }

  void onValidate() async {
    FocusScope.of(context).requestFocus(new FocusNode());

    if (phoneNum == '') {
      showToast('Please input phone number', context);
      return;
    }

    final number = codeEditingController.text + phoneNum;
    final res = await HttpUtil().validatePhoneNumber(number);

    //todo
    if (res != null) {
      if (res) {
        setState(() {
          status = 'Phone number is valid';
        });

        if (!phoneNumbers.contains(number)) {
          phoneNumbers.insert(0, number);

          saveHistory();
        }
      } else {
        setState(() {
          status = 'Phone number is invalid';
        });
      }

    }
  }

  void showHistory() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryPage(phoneNumbers: phoneNumbers,)));
  }

  void changeTheme() {
    Provider.of<ThemeModel>(context).switchPrimaryColor();
  }

  @override
  Widget build(BuildContext context) {
    if (ScreenUtil() == null) {
      ScreenUtil.init(context, width: 360, height: 640, allowFontScaling: false);
    }

    return Scaffold(
      body: Container(
        height: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          child: InkWell(
            onTap: () {
              //print('click');
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 80.w,),
                  Image.asset(
                    'assets/images/logo.png',
                    height: 80,
                  ),
                  SizedBox(height: 60.w,),
                  Stack(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Image.asset(
                            'assets/images/earth.png',
                            width: 25.w,
                            height: 25.w,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                print('tap');
                              },
                              child: TextField(
                                enabled: false,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.w
                                ),
                                keyboardAppearance: Brightness.light,
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(AppColors.line),
                                      )
                                  ),
                                  disabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(AppColors.line),
                                      )
                                  ),
                                  filled: true,
                                  hintText: 'Please select country code',
                                  fillColor: Colors.transparent,
                                ),
                                controller: codeEditingController,
                                onChanged: (str) {
                                  setState(() {
                                    //print(editingController.text);
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 35.w),
                        color: Colors.white,
                        child: SelectButton(
                          country: countryCode,
                          onChanged: (value) {
                            print(value.dialCode);
                            setState(() {
                              countryCode = value.countryCode;
                              codeEditingController.text = value.dialCode;
                              status = '';
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.w,),
                  Row(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/phone.png',
                        width: 25.w,
                        height: 25.w,
                      ),
                      Expanded(
                        child:
                        TextField(
                          key: Key('phone_number'),
                          style: TextStyle(
                              fontSize: 14.w
                          ),
                          keyboardType: TextInputType.phone,
                          keyboardAppearance: Brightness.light,
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                )
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(AppColors.line),
                                )
                            ),
                            filled: true,
                            hintStyle: TextStyle(
                                color: Color(0x80707070)
                            ),
                            hintText: 'Please input phone number',
                            fillColor: Colors.transparent,
                          ),
                          onChanged: (str) {
                            setState(() {
                              phoneNum = str;

                              if (status != '') {
                                status = '';
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.w,),
                  Text(
                    status,
                    key: Key('status'),
                    style: TextStyle(
                      color: status.contains('invalid') ? Colors.red : Theme.of(context).primaryColor,
                      fontSize: 13.w,
                    ),
                  ),
                  SizedBox(height: 30.w,),
                  RaisedButton(
                    key: Key('validate'),
                    padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 10.w),
                    disabledColor: Color(0xffe4e4e4),
                    elevation: 0,
                    onPressed: onValidate,
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      'Validate',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.w,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60.w),
                    ),
                  ),
                  SizedBox(height: 50.w,),
                  TextButton(
                    onPressed: showHistory,
                    child: Text(
                      'Validation history',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 13.w,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.w,),
                  TextButton(
                    onPressed: changeTheme,
                    child: Text(
                      'change theme',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 13.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
