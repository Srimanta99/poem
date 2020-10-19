import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:poems/model/CategoryModel.dart';
import 'package:poems/model/TopCategoryModel.dart';
import 'package:poems/pages/settings-page.dart';
import 'package:poems/pages/top-poems-details-page.dart';
import 'package:poems/utils/Checkinternet.dart';
import 'package:poems/utils/PreferenceConstant.dart';
import 'package:poems/utils/SheardPteference.dart';
import 'package:poems/utils/ShowAdd.dart';
import 'package:poems/utils/UrlConstant.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Favorites-page.dart';
import 'HomePage.dart';
import 'Write-page.dart';
 
class ToppoemsPage extends StatefulWidget {
  @override
  _ToppoemsPageState createState() => _ToppoemsPageState();
}

class _ToppoemsPageState extends State<ToppoemsPage>
    with SingleTickerProviderStateMixin {
    int currentIndex = 1;
    String nameKey;
    bool adActive=false;
    List<TopCategoryModel> list=new List();

    adShowHide() async {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          //connected
          print('connected');
          setState(() {
            adActive = true;
          });
        }else{
          //notconnecte
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
    void dispose() {
      super.dispose();
    }

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    adShowHide();
    const MethodChannel('plugins.flutter.io/shared_preferences').setMockMethodCallHandler((MethodCall methodcall) async {
      if (methodcall.method == 'getAll') {
        return {"flutter." + nameKey: "[ No Name Saved ]"};
      }
      return null;
    },
    );
    listparse() ;
  }

    listparse(){
     Future<SharedPreferences> prefs = SharedPreferences.getInstance();
     prefs.then(
             (pref)
         {
           String value= pref.getString(PreferenceConstant.TOP_POEM);
           setState((){
             Map<String, dynamic> map = jsonDecode(value);
             list = List<TopCategoryModel>.from(map['result'].map((x) => TopCategoryModel.fromJson(x)));
           });
         }
     );

      //});
    }
    Future<Void> callTopCategoryApi() async{
      Map<String, dynamic> requestPayload = {
        'apitoken': "P@EM",
      };

      final response = await http.post(UrlConstant.Top_cat_url, body: jsonEncode(requestPayload), headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body);
        String success = map['api_action_message'];
        if (success=="success") {
          setState(() {
            list = List<TopCategoryModel>.from(map['result'].map((x) => TopCategoryModel.fromJson(x)));
          });

        }
      }
    }
  @override
  Widget build(BuildContext context) {
    Future<bool> _onBackButtonPressed(BuildContext context) {
      Navigator.pop(context);
    }
    const _adUnitID = "ca-app-pub-3940256099942544/8135179316";

    final _nativeAdController = NativeAdmobController();

    return WillPopScope(
      onWillPop: ()=>_onBackButtonPressed(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor, //Color.fromRGBO(255, 233, 232, 1),
        appBar: AppBar(
          backgroundColor: Theme.of(context).accentColor, // Color.fromRGBO(227, 99, 135, 1),
          title:Text('Top Poems',
          style: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1),
            //fontWeight: FontWeight.w700,
            fontFamily: 'whitneybold',
            fontSize: ResponsiveFlutter.of(context).fontSize(2.2), //20
            )),
            //automaticallyImplyLeading: false,
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
              SizedBox(height: 5,),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left:8.0, right: 8.0),
                      child: new GridView.count(
                        crossAxisCount: 2,
                        controller: new ScrollController(keepScrollOffset: false),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: list.map(( value) {
                          return new Container(
                            child: topPoemsUI(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                )
              ),

              Visibility(
                visible: adActive,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child:Container(
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
              )

            ],
          ),
        ),

        bottomNavigationBar: Builder(
          builder: (BuildContext context) {
            return Container(
              height: ResponsiveFlutter.of(context).moderateScale(52), //52,
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
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Container(
                        child: FlatButton(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height:6),
                              Image.asset('assets/baricon1.png'),
                              SizedBox(height:3),
                              Text('Home',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText2,
                              )
                            ],
                          ),
                          onPressed: () {
                            Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>HomePage()),
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
                              Image.asset('assets/topactive.png')
                            ],
                          ),
                          onPressed: () {
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
                            Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>FavoritePage()),
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
                              Image.asset('assets/baricon4.png'),
                              SizedBox(height:3),
                              Text('Write',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText2,
                              )
                            ],
                          ),
                          onPressed: () {
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

  Widget topPoemsUI(TopCategoryModel value){
    return Container(
      child: InkWell(
        onTap: () => Navigator.of(context).push(new MaterialPageRoute(
            builder: (context)=> new TopPoemsDetailsPage(value.poems,value.category_name))),
        child: Container(
          margin: EdgeInsets.all(10),
          width: 150,
          height: 350,
          decoration: BoxDecoration(            
            color: Color.fromRGBO(0, 0, 0, 1),
            image: DecorationImage(
             // image: AssetImage('assets/toplove.png'),// dynamic image area
             // image:  NetworkImage(value.category_bg_img==""?"https://via.placeholder.com/150":value.category_bg_img),
          //  image:  NetworkImage(value.category_bg_img),
              image: Checkinternet.IsINternetAvalible? NetworkImage(value.category_bg_img):AssetImage('assets/topcategory.jpg'),
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop),
              ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Text(value.category_name, // dynamic text area
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



