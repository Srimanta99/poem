import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class SheardPreference{
  static addStringToSF(String key,String value)  {
    SharedPreferences prefs =  SharedPreferences.getInstance() as SharedPreferences;
    prefs.setString(key,value);
  }

  static addSbooleanToSF(String key,bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key,value);
  }
  static String getStringValuesSF(String key)   {
    SharedPreferences prefs =  SharedPreferences.getInstance() as SharedPreferences;
    //Return String
    String stringValue = prefs.getString(key);
    return stringValue;
  }
  static Future<bool> getboolValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    bool boolalue = prefs.getBool(key);
    return boolalue;
  }

  static clearpreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

}