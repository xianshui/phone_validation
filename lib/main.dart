import 'package:flutter/material.dart';
import 'pages/validation_page.dart';
import 'package:provider/provider.dart';
import 'models/theme_model.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeModel()),
        ],
        child: Consumer<ThemeModel> (
          builder: (_, themeModel, __) {
            print(themeModel.primaryColor);
            return MaterialApp(
                title: 'Phone validation',
                theme: ThemeData(
                  primarySwatch: themeModel.primaryColor,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                home: ValidationPage(title: 'Phone validation'),
              );
          },
        )
    );
  }
}

