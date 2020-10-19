import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:poems/model/FavouritePoemModel.dart';
import 'package:poems/model/PoemModel.dart';
import 'package:poems/pages/settings-page.dart';
import 'package:poems/sqldatabase/DatabaseHelper.dart';
import 'package:poems/utils/Checkinternet.dart';
import 'package:poems/utils/ShowAdd.dart';
import 'package:poems/utils/checkpermessionandsaveimage.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:share/share.dart';



import 'HomePage.dart';
import 'Top-poems-page.dart';
import 'Write-page.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:ui' as ui;

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  Map<PermissionGroup, PermissionStatus> permissions;
    int currentIndex = 2;
    List<Favouritepoem> list=new List();
    final key = new GlobalKey<ScaffoldState>();
    //List<int> fav_poemids;
    final _adUnitID = "ca-app-pub-3940256099942544/8135179316";
    final _nativeAdController = NativeAdmobController();
    bool isvisible=false;
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
    _querygetall();
  }
    void getPermission() async {
      permissions = await PermissionHandler().requestPermissions([
        PermissionGroup.storage,
      ]);
    }
    void _querygetall() async {
      final allRows = await dbHelper.queryAllRows();
      print('query all rows:');
      setState(() {
        list=List<Favouritepoem>.from(allRows.map((x) => Favouritepoem.fromMap(x)));
        setState(() {
          if(list.length>0)
            isvisible=false;
              else
                isvisible=true;
        });
      });

    }
Future<bool> _onBackPressed(){
  Navigator.of(context).pop();
  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
      HomePage()), (Route<dynamic> route) => false);
}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor:Theme.of(context).scaffoldBackgroundColor,// Color.fromRGBO(255, 233, 232, 1),
        key: key,
        appBar: AppBar(
          backgroundColor: Theme.of(context).accentColor,//Color.fromRGBO(227, 99, 135, 1),
          title:Text('Favorites',
          style: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1),
            fontFamily: 'whitneybold',
            fontSize: ResponsiveFlutter.of(context).fontSize(2.2), //20
            )),
            //automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.settings,
            size: ResponsiveFlutter.of(context).moderateScale(22),
            color: Color.fromRGBO(255, 255, 255, 1),),
            onPressed: (){
              //_timer.cancel();
              Navigator.push(context,
              MaterialPageRoute(builder: (context) =>SettingsPage()),
              );
            })
          ],
        ),

        body: Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: <Widget>[
              //mainHeadinglistpage,
              SizedBox(height: 2,),
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
              Visibility(
                visible: isvisible,
                child: Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(top:10.0),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Container(
                            width: 400,
                            child: Text('No favorite poems marked',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline1,
                            )
                        ),
                      )
                  ),
                ),
              ),

              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  primary: true,
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index){
                    GlobalKey _globalKey = GlobalKey();
                    return RepaintBoundary(
                      key: _globalKey,
                      child: Container(
                        child: fevPoemsListUI(list[index],_globalKey),
                      ),
                    );
                  }),
              ),
              SizedBox(height: 20,),
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
                            //_timer.cancel();
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
                              SizedBox(height:3),
                              Image.asset('assets/baricon2.png'),
                              SizedBox(height:3),
                              Text('Top Poem',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText2,
                              )
                            ],
                          ),
                          onPressed: () {
                           // _timer.cancel();
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
                              Image.asset('assets/favactive.png')
                            ],
                          ),
                          onPressed: () {
                            //_timer.cancel();
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
                            //_timer.cancel();
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
   _capturePng(GlobalKey<State<StatefulWidget>> globalKey) async {
    try {
     // print('inside');
      RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      String dir = (await getApplicationDocumentsDirectory()).path;
      String fullPath = '$dir/poem.png';
     // print("local file full path ${fullPath}");
      File file = File(fullPath);
      await file.writeAsBytes(pngBytes);
      setState(() {
        Share.shareFiles(['${dir}/poem.png'], text: 'Sending to you via:  https://play.google.com/store/apps/details?id=com.romantic.boyfriend.girlfriend.love.letters&hl=en_IN');
      });
    } catch (e) {
      print(e);
    }
  }
    void _delete(int id) async {
      // Assuming that the number of rows is the id for the last row.
      //final id = await dbHelper.queryRowCount();
      final rowsDeleted = await dbHelper.delete(id);
      print('deleted $rowsDeleted row(s): row $id');
      setState(() {
         list.clear();
        _querygetall();
      });
    }
Widget fevPoemsListUI( Favouritepoem list, GlobalKey<State<StatefulWidget>> globalKey){
  GlobalKey _globalKey = GlobalKey();
   return Container(
    child: Container(
      margin: EdgeInsets.only(top:10, bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          RepaintBoundary(
            key: _globalKey,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 1),
                image: DecorationImage(
                  // image: NetworkImage(list.poem_bg_img!=null?list.poem_bg_img:""),
                  image: Checkinternet.IsINternetAvalible? NetworkImage(list.poem_bg_img!=null?list.poem_bg_img:""):AssetImage('assets/favourite.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop),
                ),
              ),
              child: Column(
                children: <Widget>[
                  //details text
                  Container(
                    child: Text(list.poemtext.replaceAll("<br />", ""),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'SatisfyRegular',
                        fontSize: ResponsiveFlutter.of(context).fontSize(2.2),
                        height: 1.2,
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  // written by
                  Container(
                    child: Text(list.poem_author,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'whitneybold',
                        fontSize: ResponsiveFlutter.of(context).fontSize(2),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  // location field(12-08-2020)
                  Container(
                    child: Text(list.location,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'whitneybold',
                          fontSize: ResponsiveFlutter.of(context).fontSize(2),
                        )
                    ),
                  ),

                ],
              )
            ),
          ),

          //Social network area
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
              boxShadow: [BoxShadow(
                color: Colors.grey,
                blurRadius: 5.0,
              ),]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                InkWell(
                  onTap: (){
                    Clipboard.setData(new ClipboardData(text: list.poemtext.replaceAll("<br />", "")+'\n\n '+list.poem_author+'\n\n'+list.location + '\n\n https://play.google.com/store/apps/details?id=com.romantic.boyfriend.girlfriend.love.letters&hl=en_IN'));
                    key.currentState.showSnackBar(new SnackBar(
                      content: new Text("Text  Copied"),
                    ));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 6,
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    height: ResponsiveFlutter.of(context).moderateScale(50), //50,
                    child: Image.asset('assets/social1.png',
                    width: ResponsiveFlutter.of(context).moderateScale(52),
                    ),
                  ),
                ),

                InkWell(
                  onTap: (){
                      CheckpermessionAndSaveImage.requestPermission(PermissionGroup.storage,list.poem_bg_img,key,_globalKey);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 6,
                    height: ResponsiveFlutter.of(context).moderateScale(50), //50,
                    decoration: BoxDecoration(
                      border: Border(
                      left: BorderSide(width: 1, color: Color.fromRGBO(0, 0, 0, 0.2)),
                    ),
                    ),
                    child: Image.asset('assets/social2.png',
                    width: ResponsiveFlutter.of(context).moderateScale(52),
                    ),
                  ),
                ),

                InkWell(
                  onTap: (){
                    final RenderBox box = context.findRenderObject();
                    Share.share(list.poemtext.replaceAll("<br />", "")+'\n\n '+list.poem_author+'\n\n'+list.location+ '\n\n https://play.google.com/store/apps/details?id=com.romantic.boyfriend.girlfriend.love.letters&hl=en_IN',
                        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 6,
                    height: ResponsiveFlutter.of(context).moderateScale(50), //50,
                    decoration: BoxDecoration(
                      border: Border(
                      left: BorderSide(width: 1, color: Color.fromRGBO(0, 0, 0, 0.2)),
                    ),
                    ),
                    child: Image.asset('assets/social3.png',
                    width: ResponsiveFlutter.of(context).moderateScale(52),
                    ),
                  ),
                ),

                InkWell(
                  onTap: (){
                      _capturePng(_globalKey);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 6,
                    height: ResponsiveFlutter.of(context).moderateScale(50), //50,
                    decoration: BoxDecoration(
                      border: Border(
                      left: BorderSide(width: 1, color: Color.fromRGBO(0, 0, 0, 0.2)),
                        right: BorderSide(width: 1, color: Color.fromRGBO(0, 0, 0, 0.2)),
                    ),
                    ),
                    child: Image.asset('assets/social4.png',
                    width: ResponsiveFlutter.of(context).moderateScale(52),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 6,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.only(
                        bottomRight: Radius.circular(15.0),
                      )
                  ),
                  child: InkWell(
                    onTap: (){
                      _delete(list.p_id);
                    },
                    child: Icon(LineIcons.heart,
                    size: ResponsiveFlutter.of(context).moderateScale(24),
                      color: Colors.red,),
                  ),
                )

              ],
            ),
          ),


        ],
      ),
    ),
   );
 }

}