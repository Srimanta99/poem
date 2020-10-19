import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:poems/setting-pages/about-page.dart';
import 'package:poems/setting-pages/moreApps-page.dart';
import 'package:poems/setting-pages/privacy-page.dart';
import 'package:poems/theme.dart';
import 'package:poems/utils/PreferenceConstant.dart';
import 'package:poems/utils/ShowAdd.dart';
import 'package:poems/utils/UrlConstant.dart';
import 'package:poems/utils/alert.dart';
import 'package:provider/provider.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:http/http.dart' as http;

import 'HomePage.dart';

 class SettingsPage extends StatefulWidget {   
   @override
   _SettingsPageState createState() => _SettingsPageState();
 }
 
 class _SettingsPageState extends State<SettingsPage> {

   List<bool> isSelected;
   Timer timer;


   @override
   void dispose() {
     super.dispose();
   }

   @override
   void initState() {
     super.initState();
   }


   void showProcessingDialog() async {
     return showDialog(
         barrierDismissible: false,
         context: context,
         builder: (BuildContext context) {
           return AlertDialog(
               shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.all(Radius.circular(10.0))),
               contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
               content: Container(
                   padding: EdgeInsets.all(15),
                   width: ResponsiveFlutter.of(context).moderateScale(350),
                   //350,
                   height: ResponsiveFlutter.of(context).moderateScale(390),
                   //390,
                   child: Column(
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         Container(
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.end,
                             children: <Widget>[
                               InkWell(
                                 onTap: () {
                                   Navigator.of(context, rootNavigator: true)
                                       .pop();
                                 },
                                 child: Icon(
                                   Icons.close, size: ResponsiveFlutter.of(
                                     context).moderateScale(20),),
                               )
                             ],
                           ),
                         ),
                         Container(
                           child: Image.asset('assets/popbg.png',
                             width: ResponsiveFlutter.of(context).moderateScale(
                                 170), //170,
                           ),
                         ),
                         SizedBox(
                           height: ResponsiveFlutter.of(context).moderateScale(
                               10),),
                         Container(
                           child: Text(
                             "We\'d greatly appreciate if you can rate us.",
                             textAlign: TextAlign.center,
                             style: TextStyle(
                               color: Color.fromRGBO(58, 58, 58, 1),
                               fontWeight: FontWeight.w700,
                               fontFamily: 'Roboto',
                               fontSize: ResponsiveFlutter.of(context).fontSize(
                                   2.2), //20
                             ),
                           ),
                         ),
                         SizedBox(height: ResponsiveFlutter.of(context)
                             .moderateScale(15)),
                         //star rate
                         Container(
                           child: SmoothStarRating(
                             //rating: rating,
                             color: Colors.blue,
                             isReadOnly: false,
                             size: ResponsiveFlutter.of(context).moderateScale(
                                 40),
                             //40,
                             filledIconData: Icons.star,
                             halfFilledIconData: Icons.star_half,
                             defaultIconData: Icons.star_border,
                             starCount: 5,
                             allowHalfRating: true,
                             spacing: 2.0,
                             onRated: (value) {
                               print("rating value -> $value");
                               // print("rating value dd -> ${value.truncate()}");
                             },
                           ),
                         ),
                         SizedBox(
                           height: ResponsiveFlutter.of(context).moderateScale(
                               10),),
                         Container(
                           child: Text("The best We can get :)",
                             style: TextStyle(
                               color: Color.fromRGBO(255, 146, 52, 1),
                               fontWeight: FontWeight.w700,
                               fontFamily: 'Roboto',
                               fontSize: ResponsiveFlutter.of(context).fontSize(
                                   1.8), //15
                             ),
                           ),
                         ),
                         SizedBox(
                           height: ResponsiveFlutter.of(context).moderateScale(
                               10),),

                         Container(
                           height: ResponsiveFlutter.of(context).moderateScale(
                               60), //60.0,
                           color: Colors.transparent,
                           child: Container(
                             decoration: BoxDecoration(
                                 color: Color.fromRGBO(108, 99, 255, 1),
                                 borderRadius: BorderRadius.circular(5.0)
                             ),
                             child: InkWell(
                               onTap: () async {
                                 Navigator.of(context, rootNavigator: true)
                                     .pop();
                               },
                               child: Center(
                                   child: Text('RATE',
                                     style: TextStyle(
                                       color: Color.fromRGBO(255, 255, 255, 1),
                                       fontWeight: FontWeight.w700,
                                       fontFamily: 'Roboto',
                                       fontSize: ResponsiveFlutter.of(context)
                                           .fontSize(2), //17
                                     ),
                                   )
                               ),
                             ),
                           ),
                         ),
                       ]
                   )
               )

           );
         }
     );
   }

   // chnages 04-08-2020 start
   bool toggleValue = true;


   toggleButton() {
     setState(() {
       toggleValue = !toggleValue;
     });
   }


   // chnages 04-08-2020 end
   @override
   Widget build(BuildContext context) {
     const _adUnitID = "ca-app-pub-3940256099942544/8135179316";
     final _nativeAdController = NativeAdmobController();

     Future<void> callApiforsync(BuildContext context) async {
       try {
         final result = await InternetAddress.lookup('google.com');
         if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
           callCategoryApi(context);
         } else {
           Alert.showalertDialog(context, "No Internet connection");
         }
       } on SocketException catch (_) {

         Alert.showalertDialog(context, "No Internet connection");
       }
     }
     Future<bool> _onBackButtonPressed(BuildContext context) {
       Navigator.pop(context);
     }
     return WillPopScope(
       onWillPop: () => _onBackButtonPressed(context),
       child: Scaffold(
         backgroundColor: Theme
             .of(context)
             .scaffoldBackgroundColor, //Color.fromRGBO(255, 233, 232, 1),
         appBar: AppBar(
           backgroundColor: Theme
               .of(context)
               .accentColor, //Color.fromRGBO(227, 99, 135, 1),
           title: Text('Settings',
             style: TextStyle(
               color: Color.fromRGBO(255, 255, 255, 1),
               //fontWeight: FontWeight.w700,
               fontFamily: 'whitneybold',
               fontSize: ResponsiveFlutter.of(context).fontSize(2.2), //20
             ),),
           //automaticallyImplyLeading: false,

         ),

         body: Container(
           padding: EdgeInsets.only(top: 15, right: 15, bottom: 15),
           child: Column(
             children: <Widget>[
               Expanded(
                   child: ListView(
                     children: <Widget>[
                       //Dark Mode
                       Container(
                         child: FittedBox(
                           fit: BoxFit.contain,
                           child: Container(
                             width: 400,
                             child: Consumer<ThemeNotifier>(
                               builder: (context, notifier, child) =>
                                   SwitchListTile(
                                     title: Align(
                                       child: Row(
                                         mainAxisAlignment: MainAxisAlignment
                                             .start,
                                         children: <Widget>[
                                           //SizedBox(width: 20,),
                                           Icon(Icons.brightness_2),
                                           SizedBox(width: 5,),
                                           Container(
                                             child: Text("Dark Mode",
                                               style: Theme
                                                   .of(context)
                                                   .textTheme
                                                   .bodyText1,
                                             ),
                                           )

                                         ],
                                       ),
                                       alignment: Alignment(-5.5, 0),
                                     ),
                                     onChanged: (toggleValue) {
                                       notifier.toggleTheme();
                                     },
                                     value: !notifier.darkTheme,
                                     activeTrackColor: Colors.pink[50],
                                     activeColor: Colors.pink,
                                   ),
                             ),
                           ),

                         ),
                       ),
                       //Privecy
                       Container(
                         padding: EdgeInsets.only(
                             top: ResponsiveFlutter.of(context).moderateScale(
                                 10),
                             bottom: ResponsiveFlutter.of(context)
                                 .moderateScale(10), left: 20),
                         child: FittedBox(
                           fit: BoxFit.contain,
                           child: Container(
                             width: 400,
                             child: InkWell(
                                 onTap: () {
                                   Navigator.push(context,
                                     MaterialPageRoute(
                                         builder: (context) => PrivacyPage()),
                                   );
                                 },
                                 child: Row(
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     children: <Widget>[
                                       Container(
                                         child: Icon(Icons.lock_outline),
                                       ),
                                       SizedBox(width: 7,),
                                       Container(
                                         child: Text("Privacy",
                                           style: Theme
                                               .of(context)
                                               .textTheme
                                               .bodyText1,
                                         ),
                                       )
                                     ]
                                 )
                             ),
                           ),

                         ),
                       ),
                       //Help and Feedback
                       Container(
                         padding: EdgeInsets.only(
                             top: ResponsiveFlutter.of(context).moderateScale(
                                 10),
                             bottom: ResponsiveFlutter.of(context)
                                 .moderateScale(10), left: 20),
                         child: FittedBox(
                           fit: BoxFit.contain,
                           child: Container(
                             width: 400,
                             child: InkWell(
                                 onTap: () {},
                                 child: Row(
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     children: <Widget>[
                                       Container(
                                         child: Icon(Icons.help),
                                       ),
                                       SizedBox(width: 7,),
                                       Container(
                                         child: Text("Help and Feedback",
                                           style: Theme
                                               .of(context)
                                               .textTheme
                                               .bodyText1,
                                         ),
                                       )
                                     ]
                                 )
                             ),
                           ),

                         ),
                       ),
                       //More Apps
                       Container(
                         padding: EdgeInsets.only(
                             top: ResponsiveFlutter.of(context).moderateScale(
                                 10),
                             bottom: ResponsiveFlutter.of(context)
                                 .moderateScale(10), left: 20),
                         child: FittedBox(
                           fit: BoxFit.contain,
                           child: Container(
                             width: 400,
                             child: InkWell(
                                 onTap: () {
                                   Navigator.push(context,
                                     MaterialPageRoute(
                                         builder: (context) => MoreAppsPage()),
                                   );
                                 },
                                 child: Row(
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     children: <Widget>[
                                       Container(
                                         child: Icon(Icons.table_chart),
                                       ),
                                       SizedBox(width: 7,),
                                       Container(
                                         child: Text("More Apps",
                                           style: Theme
                                               .of(context)
                                               .textTheme
                                               .bodyText1,
                                         ),
                                       )
                                     ]
                                 )
                             ),
                           ),

                         ),
                       ),
                       //About Us
                       Container(
                         padding: EdgeInsets.only(
                             top: ResponsiveFlutter.of(context).moderateScale(
                                 10),
                             bottom: ResponsiveFlutter.of(context)
                                 .moderateScale(10), left: 20),
                         child: FittedBox(
                           fit: BoxFit.contain,
                           child: Container(
                             width: 400,
                             child: InkWell(
                                 onTap: () {
                                   Navigator.push(context,
                                     MaterialPageRoute(
                                         builder: (context) => AboutUsPage()),
                                   );
                                 },
                                 child: Row(
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     children: <Widget>[
                                       Container(
                                         child: Icon(Icons.info),
                                       ),
                                       SizedBox(width: 7,),
                                       Container(
                                         child: Text("About Us",
                                           style: Theme
                                               .of(context)
                                               .textTheme
                                               .bodyText1,
                                         ),
                                       )
                                     ]
                                 )
                             ),
                           ),

                         ),
                       ),
                       //Rate Us
                       Container(
                         padding: EdgeInsets.only(
                             top: ResponsiveFlutter.of(context).moderateScale(
                                 10),
                             bottom: ResponsiveFlutter.of(context)
                                 .moderateScale(10), left: 20),
                         child: FittedBox(
                           fit: BoxFit.contain,
                           child: Container(
                             width: 400,
                             child: InkWell(
                                 onTap: () {
                                   showProcessingDialog();
                                 },
                                 child: Row(
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     children: <Widget>[
                                       Container(
                                         child: Icon(Icons.star),
                                       ),
                                       SizedBox(width: 7,),
                                       Container(
                                         child: Text("Rate Us",
                                           style: Theme
                                               .of(context)
                                               .textTheme
                                               .bodyText1,
                                         ),
                                       )
                                     ]
                                 )
                             ),
                           ),

                         ),
                       ),

                     ],
                   )
               ),


               Visibility(
                 maintainSize: true,
                 maintainAnimation: true,
                 maintainState: true,
                 visible: false,
                 child: Align(
                   alignment: Alignment.bottomCenter,
                   child: Container(
                     height: 90,
                     padding: EdgeInsets.all(10),
                     margin: EdgeInsets.only(bottom: 5.0),
                     child: NativeAdmob(
                       // Your ad unit id
                       adUnitID: _adUnitID,
                       controller: _nativeAdController,
                       type: NativeAdmobType.banner,
                     ),
                   ), /*Container(
                    height: 56,
                    color: Colors.white,
                    child: Image.asset('assets/addImg.jpg'),
                  ),*/
                 ),
               ),


             ],
           ),
         ),


       ),
     );
   }

   Future<Void> callCategoryApi(BuildContext context) async {
     Map<String, dynamic> requestPayload = {
       'apitoken': "P@EM",
     };

     final response = await http.post(
         UrlConstant.Cat_url, body: jsonEncode(requestPayload),
         headers: {'Content-Type': 'application/json'});
     if (response.statusCode == 200) {
       Map<String, dynamic> map = jsonDecode(response.body);
       String success = map['api_action_message'];
       if (success == "success") {
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

   Future<Void> callTopCategoryApi(BuildContext context) async {
     Map<String, dynamic> requestPayload = {
       'apitoken': "P@EM",
     };

     final response = await http.post(
         UrlConstant.Top_cat_url, body: jsonEncode(requestPayload),
         headers: {'Content-Type': 'application/json'});
     if (response.statusCode == 200) {
       Map<String, dynamic> map = jsonDecode(response.body);
       String success = map['api_action_message'];
       if (success == "success") {
         Future<SharedPreferences> prefs = SharedPreferences.getInstance();
         prefs.then(
                 (pref) {
               pref.setString(PreferenceConstant.TOP_POEM, response.body);
               Alert.showalertDialog(context, "Data sync successfully");
             }

         );
       }
     }
   }
 }

 