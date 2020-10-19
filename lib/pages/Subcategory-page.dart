import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:poems/model/CategoryModel.dart';
import 'package:poems/pages/settings-page.dart';
import 'package:poems/pages/subcat_poem_details.dart';
import 'package:poems/pages/top-poems-details-page.dart';
import 'package:poems/utils/Checkinternet.dart';
import 'package:poems/utils/ShowAdd.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
//import 'package:line_icons/line_icons.dart';

import 'Favorites-page.dart';
import 'HomePage.dart';
import 'Top-poems-page.dart';
import 'Write-page.dart';


class SubCategoryPage extends StatefulWidget {
  List<Childs> childs;
  String headertext;
  SubCategoryPage(this.headertext,this.childs){}

  @override
  _SubCategoryPageState createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage>
  with SingleTickerProviderStateMixin {
  int currentIndex = 0;

  bool adActive=false;
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
        //notconnected
        print('notconnected');
        setState(() {
          adActive = false;
        });
      }
    } on SocketException catch (_) {
      print('not connected');
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
    super.initState();
    adShowHide();

  }
  @override
  Widget build(BuildContext context) {

    List<String> widgetList = ['A', 'B', 'C', 'D', 'E', 'f', 'g', 'h', 'i', 'j'];
    const _adUnitID = "ca-app-pub-3940256099942544/8135179316";
    Future<bool> _onBackButtonPressed(BuildContext context) {
    //  _timer.cancel();
      Navigator.pop(context);
    }
    final _nativeAdController = NativeAdmobController();
    return WillPopScope(
      onWillPop: ()=>_onBackButtonPressed(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor, //Color.fromRGBO(255, 233, 232, 1),
        appBar: AppBar(
          backgroundColor: Theme.of(context).accentColor, // Color.fromRGBO(227, 99, 135, 1),
          title:Text(widget.headertext,
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
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.only(left:5.0, right: 5.0),
                      child: new GridView.count(
                        crossAxisCount: 3,
                        controller: new ScrollController(keepScrollOffset: false),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: widget.childs.map(( value) {
                          return new Container(
                            child: subCategoryUI(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                )
              ),


            SizedBox(height:10),
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
            ),

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
                              Image.asset('assets/homeiconactive.png'),
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
                              Image.asset('assets/baricon2.png'),
                              SizedBox(height:3),
                              Text('Top poem',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText2,
                              )
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

Widget subCategoryUI(Childs value){
  return Container(
    child: InkWell(
      onTap: () =>
          Navigator.of(context).push(new MaterialPageRoute(
          builder: (context)=> new SubCategoryPoemDetails(widget.headertext,value))),
      child: Container(
        margin: EdgeInsets.all(5),
        width: 150,
        height: 140,
        decoration: BoxDecoration(            
          color: Color.fromRGBO(0, 0, 0, 1),
          image: DecorationImage(
            image: Checkinternet.IsINternetAvalible? NetworkImage(value.category_bg_img):AssetImage('assets/categorybg.jpg'),
            fit: BoxFit.cover,
            colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.dstATop),
            ),
          
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[            
            SizedBox(height: 10,),
            Text(value.category_name,
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 0.8,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontFamily: 'CaveatB',
                fontSize: ResponsiveFlutter.of(context).fontSize(4),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

}







