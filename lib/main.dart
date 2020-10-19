import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poems/model/CategoryModel.dart';
import 'package:poems/model/TopCategoryModel.dart';
import 'package:http/http.dart' as http;
import 'package:poems/pages/theme_home.dart';
import 'package:poems/utils/Checkinternet.dart';
import 'package:poems/utils/PreferenceConstant.dart';
import 'package:poems/utils/SheardPteference.dart';
import 'package:poems/utils/ShowAdd.dart';
import 'package:poems/utils/UrlConstant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:responsive_flutter/responsive_flutter.dart';


void main()  =>
    runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WelcomePage(),
  )

);

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with SingleTickerProviderStateMixin {
  @override
  initState(){
    super.initState();
    ShowAdd.createInterstitialLoadAd();
    Checkinternet.isinternetAvalible(context);
    callApi(context);
  }

  
  bool toggleValue = true;
  Widget _myAnimatedWidget = FirstWidget();

  @override
  Widget build(BuildContext context) {
    
    final categoryCard = Container(
      margin: EdgeInsets.only(left:15.0, top:10.0, right: 15.0),
      
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
      //scrollDirection: Axis.horizontal,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only( top: 10, bottom: 10, right: 10),
          child: Text("More Apps",
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.white,
              //fontWeight: FontWeight.w500,
              fontFamily: 'whitneybold',
              fontSize: ResponsiveFlutter.of(context).fontSize(2.5),//22,
            ),
          ),
        ),

        Container(
          height: ResponsiveFlutter.of(context).moderateScale(180), //180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              InkWell(
              onTap: () {
                launch('https://play.google.com/store/apps/details?id=com.romantic.boyfriend.girlfriend.love.letters&hl=en');
              },
              child: Container(
                width: ResponsiveFlutter.of(context).moderateScale(120), //120,  
                height: ResponsiveFlutter.of(context).moderateScale(180), //180,   
                margin: EdgeInsets.only(top:5.0, left: 0, bottom: 10, right: 10),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: ResponsiveFlutter.of(context).moderateScale(120), //120,
                      height: ResponsiveFlutter.of(context).moderateScale(110), //110,
                      decoration: BoxDecoration(            
                        color: Color.fromRGBO(255, 255, 255, 1),
                        image: DecorationImage(
                          image: AssetImage('assets/apps1.jpg'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),            
                      ),
                      child: Center(),
                    ),
                    SizedBox(height: 5,),
                    Center(
                      child:  Text('Quotes & Sayings',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'whitneymedium',
                        fontSize: ResponsiveFlutter.of(context).fontSize(2) //17,
                      ),),
                    ),
                  ],
                ),
              ), //cat2
            ),

              InkWell(
                onTap: () {
                  launch('https://play.google.com/store/apps/details?id=com.romantic.boyfriend.girlfriend.love.letters&hl=en');
                },
                child: Container(
                  width: ResponsiveFlutter.of(context).moderateScale(120), //120,  
                  height: ResponsiveFlutter.of(context).moderateScale(180), //160,   
                  margin: EdgeInsets.only(top:5.0, left: 0, bottom: 10, right: 10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: ResponsiveFlutter.of(context).moderateScale(120), //120,
                        height: ResponsiveFlutter.of(context).moderateScale(110), //110,
                        decoration: BoxDecoration(            
                          color: Color.fromRGBO(255, 255, 255, 1),
                          image: DecorationImage(
                            image: AssetImage('assets/apps2.jpg'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(10),            
                        ),
                        child: Center(),
                      ),
                      SizedBox(height: 5,),
                      Center(
                        child:  Text('Love letter Messages',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          //fontWeight: FontWeight.w300,
                          fontFamily: 'whitneymedium',
                          fontSize: ResponsiveFlutter.of(context).fontSize(2) //17,
                        ),),
                      ),
                    ],
                  ),
                ), //cat2
              ),

              InkWell(
                onTap: () {
                  launch('https://play.google.com/store/apps/details?id=com.romantic.boyfriend.girlfriend.love.letters&hl=en');
                },
                child: Container(
                  width: ResponsiveFlutter.of(context).moderateScale(120), //120,  
                  height: ResponsiveFlutter.of(context).moderateScale(180), //160,   
                  margin: EdgeInsets.only(top:5.0, left: 0, bottom: 10, right: 5),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: ResponsiveFlutter.of(context).moderateScale(120), //120,
                        height: ResponsiveFlutter.of(context).moderateScale(110), //110,
                        decoration: BoxDecoration(            
                          color: Color.fromRGBO(255, 255, 255, 1),
                          image: DecorationImage(
                            image: AssetImage('assets/apps3.jpg'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(10),            
                        ),
                        child: Center(),
                      ),
                      SizedBox(height: 5,),
                      Center(
                        child:  Text('Messages for Wife',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          //fontWeight: FontWeight.w300,
                          fontFamily: 'whitneymedium',
                          fontSize: ResponsiveFlutter.of(context).fontSize(2) //17,
                        ),),
                      ),
                    ],
                  ),
                ), //cat2
              ),

            ],
          ),
        ),

      ],
    ),
  );



    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/splashscreen.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(child: ListView(
              children: <Widget>[
              Center(
              child: Padding(
                padding: EdgeInsets.only(top: 100),
                child: Text("POEMS",                
                  style: TextStyle( 
                  shadows: [
                    Shadow(
                        blurRadius: 0,
                        color: Colors.black,
                        offset: Offset(5.0, 5.0),
                      ),
                  ],
                  color: Color.fromRGBO(255, 255, 255, 1), 
                  fontWeight: FontWeight.w800,
                  fontFamily: 'SpecialElite',
                  fontSize: ResponsiveFlutter.of(context).fontSize(11) //82
                  ),
                ),
              ),
            ),

              Center(
              child: Padding(
                padding: EdgeInsets.only(top: 0),
                child: Text("FOR ALL OCCASIONS",
                  style: TextStyle( 
                  color: Color.fromRGBO(255, 255, 255, 1), 
                  fontWeight: FontWeight.w400,
                  fontFamily: 'SpecialElite',
                  fontSize: ResponsiveFlutter.of(context).fontSize(3.5) //22
                  ),
                ),
              ),
            ),

              SizedBox(height: 20,),
              //button area
              Center(
                child: FlatButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) =>HomeTheme()),
                      );
                    },
                    child: Container(
                        width: ResponsiveFlutter.of(context).moderateScale(80), //80,
                        height: ResponsiveFlutter.of(context).moderateScale(80), //80,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child:Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/arrow_small.png", ),
                            ),
                          ),
                        )
                    )
                ),

              ),
              

              ]
            )), 

            Align(
              alignment: Alignment.bottomCenter,
              child: categoryCard,
            ),
            
            
          ],
        ),
      ),
    );
  }
  Future<void> callApi(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        callCategoryApi(context);
      }else{
        String catdata=await loadAssetCat();
        Future<SharedPreferences> prefs = SharedPreferences.getInstance();
        prefs.then(
                (pref) {
              pref.setString(PreferenceConstant.CAT_JSON,catdata);
            }

        );
      }
    } on SocketException catch (_) {
      print('not connected');
      String catdata= await loadAssetCat();
      String topcat=await loadAssettopcat();
      Future<SharedPreferences> prefs = SharedPreferences.getInstance();
      prefs.then(
              (pref) {
            pref.setString(PreferenceConstant.CAT_JSON,catdata);
            pref.setString(PreferenceConstant.TOP_POEM, topcat);
          }

      );
    }
  }
  Future<String> loadAssetCat() async {
    return await rootBundle.loadString('assets/poem_cat.txt');
  }
  Future<String> loadAssettopcat() async {
    return await rootBundle.loadString('assets/top_poem.txt');
  }
  Future<Void> callCategoryApi(BuildContext context) async{
    Map<String, dynamic> requestPayload = {
      'apitoken': "P@EM",
    };

    final response = await http.post(UrlConstant.Cat_url, body: jsonEncode(requestPayload), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      String success = map['api_action_message'];
      if (success=="success") {
        Future<SharedPreferences> prefs = SharedPreferences.getInstance();
        prefs.then(
                (pref) {
               pref.setString(PreferenceConstant.CAT_JSON, response.body);
              callTopCategoryApi(context);
            }

        );
      }
    }
  }

  Future<Void> callTopCategoryApi(BuildContext context) async{
    Map<String, dynamic> requestPayload = {
      'apitoken': "P@EM",
    };

    final response = await http.post(UrlConstant.Top_cat_url, body: jsonEncode(requestPayload), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      String success = map['api_action_message'];
      if (success=="success") {
        Future<SharedPreferences> prefs = SharedPreferences.getInstance();
        prefs.then(
                (pref) {
              pref.setString(PreferenceConstant.TOP_POEM, response.body);

            }

        );
      }
    }
  }
}

class FirstWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.circular(100),                    
      ),
      child:Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/arrow_small.png"),
          ),
        ),
      )
    );
  }

} 