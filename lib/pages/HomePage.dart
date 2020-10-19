import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:poems/model/CategoryModel.dart';
import 'package:poems/pages/settings-page.dart';
import 'package:poems/utils/Checkinternet.dart';
import 'package:poems/utils/PreferenceConstant.dart';
import 'package:poems/utils/SheardPteference.dart';
import 'package:poems/utils/ShowAdd.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'Favorites-page.dart';
import 'Subcategory-page.dart';
import 'Top-poems-page.dart';
import 'Write-page.dart';
//import 'package:line_icons/line_icons.dart';


void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  )
);

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int currentIndex = 2;
  String nameKey;
  String catgeory_json="";
  List<CategoryModel> list;
 static Timer _timer;
  int _start = 30;
  bool adActive=false;

  void startTimer() {
   // const oneSec = const Duration(seconds: 25);
    _timer = new Timer.periodic(ShowAdd.oneSec,
          (Timer timer) => setState(
            () {
          if (_start < 1) {
            timer.cancel();
          } else {
            if(ShowAdd.isAdclose) {
               ShowAdd.showalnstatialAdd(context);

            }
            _start = _start - 1;
         }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    adShowHide();
    startTimer();
      listparse() ;
  }
  listparse(){
   Future<SharedPreferences> prefs = SharedPreferences.getInstance();
   prefs.then(
           (pref) {
         String value= pref.getString(PreferenceConstant.CAT_JSON) ;
         setState((){
           Map<String, dynamic> map = jsonDecode(value);
           list = List<CategoryModel>.from(map['result'].map((x) => CategoryModel.fromJson(x)));
         });
       }
   );

   // });
   }
  @override
  void dispose() {
    super.dispose();
  }
  adShowHide() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //connected
        setState(() {
          adActive = true;
        });
      }else{
        //notconnected

        setState(() {
          adActive = false;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        adActive = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
     const _adUnitID = "ca-app-pub-3940256099942544/8135179316";
    final _nativeAdController = NativeAdmobController();
     Future<bool> _onBackButtonPressed(BuildContext context) {
       Navigator.pop(context);
       Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
           WelcomePage()), (Route<dynamic> route) => false);
     }
    return WillPopScope(
      onWillPop:()=> _onBackButtonPressed(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).accentColor,//Color.fromRGBO(227, 99, 135, 1),
          title:Text('Poems For All Occasions',
          style: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1),
            fontFamily: 'whitneybold',
            fontSize: ResponsiveFlutter.of(context).fontSize(2.2), //20
            )),
            automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.settings,
            size: ResponsiveFlutter.of(context).moderateScale(22),
            color: Color.fromRGBO(255, 255, 255, 1),),
            onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context) =>SettingsPage()),
              );
            })
          ],
        ),

        body: Center(
          child: Column(
            children: <Widget>[
              Visibility(
                visible: adActive,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    height: 90,
                    color: Colors.white,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: NativeAdmob(
                      // Your ad unit id
                      adUnitID: _adUnitID,
                      controller: _nativeAdController,
                      type: NativeAdmobType.banner,
                    ),
                  ),
                ),
              ),
              SizedBox(height:10),

              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left:8.0, right: 8.0),
                  child: new GridView.count(
                    crossAxisCount: 2,
                    controller: new ScrollController(keepScrollOffset: false),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: list?.map(( value) {
                      return new Container(
                        child: mainCategoryUI(value),
                      );
                    })?.toList()??[],
                  ),
                )
              )



            ],
          ),
        ),

        bottomNavigationBar: Builder(
          builder: (BuildContext context) {
            return Container(
                height: ResponsiveFlutter.of(context).moderateScale(52), //52,
               // margin: const EdgeInsets.only(bottom: 70),
              decoration: BoxDecoration(
                color: Theme.of(context).bottomAppBarColor,//Colors.white,
                border: Border(top: BorderSide(
                  color: Theme.of(context).accentColor, //Color.fromRGBO(227, 99, 135, 1),
                ))
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(                    
                    child: Container(
                      height: ResponsiveFlutter.of(context).moderateScale(52),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Container(
                          child: FlatButton(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(height:6),
                                Image.asset('assets/homeiconactive.png'
                                ),
                              ],
                            ),
                            onPressed: () {
                            //  _timer.cancel();
                            },
                          ),
                        ),
                      ),
                    )
                  ),

                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Container(
                        child: FlatButton(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height:6),
                              Image.asset('assets/baricon2.png'
                              ),
                              SizedBox(height:3),
                              Text('Top poem',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText2,
                              )
                            ],
                          ),
                          onPressed: () {
                            //_timer.cancel();
                            Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>ToppoemsPage()),
                            );
                        },
                        ),
                          ),
                    ),
                  ),

                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Container(
                        child: FlatButton(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height:6),
                              Image.asset('assets/baricon3.png'),
                              SizedBox(height:3),
                              Text('Favorites',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText2,
                              )
                            ],
                          ),
                          onPressed: () {
                            //_timer.cancel();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritePage()),);
                          },
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Container(
                        child: FlatButton(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height:6),
                              Image.asset('assets/baricon4.png'),
                              SizedBox(height:3),
                              Text('Write',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText2,
                              )
                            ],
                          ),
                          onPressed: () {
                            _timer.cancel();
                            Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>WritePoemPage()),
                            );
                        },
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            );
          },
        ),

      ),
    );
  }

Widget mainCategoryUI(CategoryModel list){
     List<String> catname=new List();
    if(list.category_name.contains(' '))
         catname = list.category_name.split(' ');
    else {
      catname.insert(0," ");
      catname.insert(1,list.category_name);
     // catname[1] = list.category_name;
    }
  return Container(
    child: InkWell(
      onTap: () => Navigator.of(context).push(new MaterialPageRoute(
          builder: (context)=> new SubCategoryPage(list.category_name,list.childs))),
      child: Container(
        margin: EdgeInsets.all(10),
        width: 150,
        height: 140,
        decoration: BoxDecoration(            
          color: Color.fromRGBO(0, 0, 0, 1),
          image: DecorationImage(
           // image:  CachedNetworkImageProvider(list.category_bg_img),// dynamic image area
            image: Checkinternet.IsINternetAvalible? NetworkImage(list.category_bg_img):AssetImage('assets/category.jpg'),
            fit: BoxFit.cover,
            colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop),
            ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(catname[0], // dynamic text area
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                //fontWeight: FontWeight.w800,
                fontFamily: 'whitneybold',
                fontSize: ResponsiveFlutter.of(context).fontSize(2.5),
              ),
            ),
            SizedBox(height: 15,),
            Text(catname[1], // dynamic text area
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontFamily: 'GreatVibes',
                fontSize: ResponsiveFlutter.of(context).fontSize(5),
              ),
            )
          ],
        ),
      ),
    ),
  );
}


}










