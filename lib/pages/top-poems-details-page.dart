import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';


import 'package:dio/dio.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:line_icons/line_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:poems/model/CategoryModel.dart';
import 'package:poems/model/FavouritePoemModel.dart';
import 'package:poems/model/PoemModel.dart';
import 'package:poems/model/TopCategoryModel.dart';
//import 'package:line_icons/line_icons.dart';
import 'package:poems/pages/Favorites-page.dart';
import 'package:poems/pages/HomePage.dart';
import 'package:poems/pages/Top-poems-page.dart';
import 'package:poems/pages/Write-page.dart';
import 'package:http/http.dart' as http;
import 'package:poems/pages/settings-page.dart';
import 'package:poems/sqldatabase/DatabaseHelper.dart';
import 'package:poems/utils/Checkinternet.dart';
import 'package:poems/utils/ShowAdd.dart';
import 'package:poems/utils/UrlConstant.dart';
import 'package:poems/utils/checkpermessionandsaveimage.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

import 'dart:ui' as ui;

import 'package:share/share.dart';



 class TopPoemsDetailsPage extends StatefulWidget {
   List<PoemModel> poems;
   String toppoemcategory;

  TopPoemsDetailsPage(this.poems,this.toppoemcategory );


   @override
   _TopPoemsDetailsPageState createState() => _TopPoemsDetailsPageState();
 }
 
 class _TopPoemsDetailsPageState extends State<TopPoemsDetailsPage> {
   List<PoemModel> list = new List();
   Color iconColor = Colors.white;
   final key = new GlobalKey<ScaffoldState>();
   String poemid;
   List<String> fav_poemids=new List();
   List<Favouritepoem> favpoemlist=new List();
   Map<PermissionGroup, PermissionStatus> permissions;
   RewardedVideoAd _rewardedVideoAd=RewardedVideoAd.instance;
   bool adActive=false;

   static const MobileAdTargetingInfo _mobileAdTargetingInfo=MobileAdTargetingInfo(
       testDevices: <String>[],
       keywords: <String>['Book','game'],
       nonPersonalizedAds: true
   );
   void getPermission() async {
     permissions = await PermissionHandler().requestPermissions([
       PermissionGroup.storage,
       // PermissionGroup.microphone,
     ]);
   }

   void _querygetall() async {
     final allRows = await dbHelper.queryAllRows();
     print('query all rows:');
     setState(() {

       favpoemlist=List<Favouritepoem>.from(allRows.map((x) => Favouritepoem.fromMap(x)));
       favpoemlist.forEach((row) => {
         fav_poemids.add(row.p_id.toString())
       });
       list = widget.poems;

     });

   }

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
   Future<Void> _capturePng(GlobalKey<State<StatefulWidget>> _globalKey) async {
     try {
       // print('inside');
       final RenderRepaintBoundary boundary = _globalKey.currentContext.findRenderObject();
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

   Timer _timer;
   int _start = 10;
   void startTimer() {
     const oneSec = const Duration(seconds: 20);
     _timer = new Timer.periodic(
       oneSec,
           (Timer timer) => setState(
             () {
           if (_start < 1) {
             timer.cancel();
           } else {
             ShowAdd.showalnstatialAdd(context);
             _start = _start - 1;
           }
         },
       ),
     );
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
   @override
   Widget build(BuildContext context) {
    const _adUnitID = "ca-app-pub-3940256099942544/8135179316";
    final _nativeAdController = NativeAdmobController();

    final mainHeadinglistpage = Container(    
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Padding(
          padding: EdgeInsets.only(top:10.0),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Container(
              width: 400,
              child: Text(widget.toppoemcategory + ' Poems',
              style: Theme.of(context).textTheme.headline1,
              )
            ),
          )
          )
        )

      ],
    ),
  );
   
     return WillPopScope(
       onWillPop:  () =>_onBackButtonPressed(context),
       child: Scaffold(
         backgroundColor: Theme.of(context).scaffoldBackgroundColor, //Color.fromRGBO(255, 233, 232, 1),
         key: key,
         appBar: AppBar(
           backgroundColor: Theme.of(context).accentColor, //Color.fromRGBO(227, 99, 135, 1),
           title: Text('Top Poems',
             style: TextStyle(
                 color: Color.fromRGBO(255, 255, 255, 1),
                 //fontWeight: FontWeight.w700,
                 fontFamily: 'whitneybold',
                 fontSize: ResponsiveFlutter.of(context).fontSize(2.2), //20
                 ),),
           //automaticallyImplyLeading: false,
           actions: <Widget>[
             IconButton(icon: Icon(
               Icons.settings, 
               size: ResponsiveFlutter.of(context).moderateScale(22),
               color: Color.fromRGBO(255, 255, 255, 1),),
                 onPressed: () {
                   Navigator.push(context,
                     MaterialPageRoute(builder: (context) => SettingsPage()),
                   );
                 })
           ],
         ),

         body: Container(
           margin: EdgeInsets.only(left: 15, right: 15),
           child: Column(
             children: <Widget>[

               //admob
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
               mainHeadinglistpage,
               SizedBox(height: 10,),
               Expanded(
                 child: ListView.builder(
                     scrollDirection: Axis.vertical,
                     primary: true,
                     itemCount: list.length,
                     itemBuilder: (BuildContext context, int index) {
                       GlobalKey _globalKey = GlobalKey();
                       return RepaintBoundary(
                         key: _globalKey,
                         child: Container(
                           child: poemdetailsListUi(list[index],_globalKey),
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
                              SizedBox(height: 6),
                              Image.asset('assets/baricon1.png'),
                              SizedBox(height: 3),
                              Text('Home',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText2,
                              )
                            ],
                          ),
                          onPressed: () {
                            //_timer.cancel();
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) => HomePage()),
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
                              SizedBox(height: 6),
                              Image.asset('assets/topactive.png')
                            ],
                          ),
                          onPressed: () {
                           // _timer.cancel();
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>
                                  ToppoemsPage()),
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
                              SizedBox(height: 6),
                              Image.asset('assets/baricon3.png'),
                              SizedBox(height: 3),
                              Text('Favorites',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText2,
                              )
                            ],
                          ),
                          onPressed: () {
                           // _timer.cancel();
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>
                                  FavoritePage()),
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
                              SizedBox(height: 6),
                              Image.asset('assets/baricon4.png'),
                              SizedBox(height: 3),
                              Text('Write',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText2,
                              )
                            ],
                          ),
                          onPressed: () {
                           // _timer.cancel();
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>
                                  WritePoemPage()),
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

   Widget poemdetailsListUi(PoemModel poemModel, GlobalKey<State<StatefulWidget>> globalKey) {
     GlobalKey _globalKey = GlobalKey();

     return Container(
       child: Container(
         margin: EdgeInsets.only(top: 10, bottom: 10),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: <Widget>[

              // center text area
             RepaintBoundary(
               key: _globalKey,
               child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 1),
                 /* borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),*/
                  image: DecorationImage(
                    //image:  NetworkImage(poemModel.poem_bg_img),
                    image: Checkinternet.IsINternetAvalible? NetworkImage(poemModel.poem_bg_img):AssetImage('assets/favourite.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop),
                  ),
                 ),
                child: Column(
                  children: <Widget>[
                    //details text
                    Container(
                      child: Text(poemModel.poem_text.replaceAll("<br />", ""),
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
                      child: Text(poemModel.written_by,
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
                      child: Text(poemModel.location_name,
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
                     onTap: () {
                       Clipboard.setData(
                           new ClipboardData(text: poemModel.poem_text.replaceAll("<br />", "")+'\n\n '+poemModel.written_by+'\n\n'+poemModel.location_name+ '\n\n https://play.google.com/store/apps/details?id=com.romantic.boyfriend.girlfriend.love.letters&hl=en_IN'));
                       key.currentState.showSnackBar(new SnackBar(
                         content: new Text("Text  Copied"),
                       ));
                       //showtoastmessage("Text Copied");
                     },
                     child: Container(
                       width: MediaQuery.of(context).size.width / 6,
                       margin: EdgeInsets.only(top: 5, bottom: 5),                                             
                       height: ResponsiveFlutter.of(context).moderateScale(50), // 50,
                       child: Image.asset('assets/social1.png',
                       width: ResponsiveFlutter.of(context).moderateScale(52),
                       ),
                     ),
                   ),

                   InkWell(
                     onTap: () {
                         CheckpermessionAndSaveImage.requestPermission(PermissionGroup.storage,poemModel.poem_bg_img,key,_globalKey);
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
                     onTap: () {
                       final RenderBox box = context.findRenderObject();
                       Share.share(poemModel.poem_text.replaceAll("<br />", "")+'\n\n '+poemModel.written_by+'\n\n'+poemModel.location_name+ '\n\n https://play.google.com/store/apps/details?id=com.romantic.boyfriend.girlfriend.love.letters&hl=en_IN',
                           sharePositionOrigin: box.localToGlobal(
                               Offset.zero) & box.size);
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
                     onTap: () {
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
                       child: IconButton(
                           icon: Icon(Icons.favorite,
                           size: ResponsiveFlutter.of(context).moderateScale(24),
                           ),
                           color:fav_poemids.contains(poemModel.id.toString())?iconColor = Colors.red: iconColor = Colors.black,
                           onPressed: () {
                             setState(() {
                               poemid=poemModel.id;
                               if(!fav_poemids.contains(poemModel.id.toString())?true:false){
                                 _insert(poemModel);
                               }else {
                                 _delete(int.parse(poemModel.id));
                                 iconColor = Colors.white;
                               }
                             });
                           })
                   ),

                 ],
               ),
             ),


           ],
         ),
       ),
     );
   }

   Future<void> callpoemlistApi(String id) async {
     var dio = Dio();
     Map<String, dynamic> requestPayload = {
       'apitoken': 'P@EM',
       'category_id': 10
     };
     Map<String, dynamic> params = Map();
     params['apitoken'] = 'P@EM';
     params['category_id'] = id;

     FormData formData = new FormData.fromMap(params);
     var responsedio = await dio.post(
         UrlConstant.Get_top_poem_by_id, data: formData);
     // Map<String, dynamic> map = jsonDecode(responsedio.data);
     if (responsedio.statusCode == 200) {
       //    Map<String, dynamic> map = jsonDecode(responsedio.data);
       String success = responsedio.data['api_action_message'];
       if (success == "success") {
         setState(() {
           list = List<PoemModel>.from(
               responsedio.data['result'].map((x) => PoemModel.fromJson(x)));
         });
       }
     }

   }


   void _insert(PoemModel poemModel) async {
     Map<String, dynamic> row = {
       DatabaseHelper.p_id: poemModel.id,
       DatabaseHelper.poemName: poemModel.written_by,
       DatabaseHelper.poemText: poemModel.poem_text,
       DatabaseHelper.poemimage: poemModel.poem_bg_img,
       DatabaseHelper.poemimagewithtext:poemModel.poem_txtbg_img,
       DatabaseHelper.poem_author:poemModel.written_by,
       DatabaseHelper.location:poemModel.location_name
     };
     final id = await dbHelper.insert(row);
     print('inserted row id: $id');
     _querygetall();
   }

   void _delete(int id) async {

     final rowsDeleted = await dbHelper.delete(id);
     print('deleted $rowsDeleted row(s): row $id');
     setState(() {
       fav_poemids.clear();
       _querygetall();

     });
   }


  Future<bool> _onBackButtonPressed(BuildContext context) {
    Navigator.pop(context);

  }
}
