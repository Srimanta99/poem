
import 'package:flutter/material.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';



void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    //home: HomeTheme(),
  )
);

Widget build(BuildContext context) {
  return Container(
    
  );
}


ThemeData dark = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.indigo,
  accentColor: Color.fromRGBO(227, 99, 135, 1), //Colors.pink,
  scaffoldBackgroundColor: Color.fromRGBO(255, 233, 232, 1),
  textTheme: TextTheme(
    bodyText1: TextStyle(
    color: Color.fromRGBO(0, 0, 0, 1),
    fontFamily: 'whitneymedium',
    fontSize: 16
    ),

    headline1: TextStyle(
    color: Color.fromRGBO(0, 0, 0, 1),
    fontFamily: 'whitneybold',
    fontSize: 18),

    headline2: TextStyle(
    color: Color.fromRGBO(227, 99, 135, 1),
    fontFamily: 'whitneybold',
    fontSize: 22),

    bodyText2: TextStyle(
    color: Color.fromRGBO(0, 0, 0, 1),
    fontFamily: 'whitneymedium',
    fontSize: 14),
  ),
  bottomAppBarColor: Colors.white,
  
  
);

ThemeData light = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.indigo,
  accentColor: Color.fromRGBO(0, 0, 0, 1),  //Colors.black,
  scaffoldBackgroundColor: Color.fromRGBO(46, 44, 44, 1),
  textTheme: TextTheme(
    bodyText1: TextStyle(
    color: Color.fromRGBO(255, 255, 255, 1),
    fontFamily: 'whitneymedium',
    fontSize: 16),

    bodyText2: TextStyle(
    color: Color.fromRGBO(255, 255, 255, 1),
    fontFamily: 'whitneymedium',
    fontSize: 14),

    headline1: TextStyle(
    color: Color.fromRGBO(255, 255, 255, 1),
    fontFamily: 'whitneybold',   
    fontSize: 18),

    headline2: TextStyle(
    color: Color.fromRGBO(255, 255, 255, 1),
    fontFamily: 'whitneybold',
    fontSize: 22),

  ),
  bottomAppBarColor: Colors.black87,
);



class ThemeNotifier extends ChangeNotifier {
  final String key = "theme";
  SharedPreferences _prefs;
  bool _darkTheme = false;
  bool _lightTheme = false;

  bool get darkTheme => _darkTheme;
  bool get lightTheme => _lightTheme;
  
  ThemeNotifier() {
  _darkTheme = false;
  _lightTheme = true;
    _loadFromPrefs();
  }

  toggleTheme() {
  _darkTheme = !_darkTheme;
  _lightTheme = !_lightTheme;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    if(_prefs == null)
      _prefs = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
  _darkTheme = _prefs.getBool(key) ?? true;
  _lightTheme = _prefs.getBool(key) ?? true;
    notifyListeners();
  }

  _saveToPrefs()async {
    await _initPrefs();
    _prefs.setBool(key, _darkTheme);
    _prefs.setBool(key, _lightTheme);
  }

}