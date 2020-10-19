import 'package:flutter/material.dart';
import 'package:poems/theme.dart';
import 'package:provider/provider.dart';

import 'HomePage.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeTheme(),
  )
);

class HomeTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
          child: Consumer<ThemeNotifier>(
            builder: (context, ThemeNotifier notifier, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                //theme: notifier.lightTheme ? dark : light,
                theme: notifier.darkTheme ? dark : light,
                home: HomePage(),
            );
            } ,
          ),
    );
  }
}