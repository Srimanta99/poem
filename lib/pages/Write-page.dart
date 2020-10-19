import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:poems/pages/HomePage.dart';
import 'package:poems/pages/settings-page.dart';
import 'package:poems/utils/ShowAdd.dart';
import 'package:poems/utils/UrlConstant.dart';
import 'package:poems/utils/alert.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
//import 'package:line_icons/line_icons.dart';

void main() => runApp(
  MaterialApp(
    home: WritePoemPage(),
  )
);

class WritePoemPage extends StatefulWidget {
  @override
  _WritePoemPageState createState() => _WritePoemPageState();
}

class _WritePoemPageState extends State<WritePoemPage> with SingleTickerProviderStateMixin {

    int currentIndex = 0;
    int textcount=1500;
    final poemformKey = GlobalKey<FormState>();
    String _content;
    String _name;
    String _location;
    final contentController = new TextEditingController();
    final nameController = new TextEditingController();
    final locationController = new TextEditingController();
    TextEditingController _count_controller = TextEditingController();
    final FocusNode fncontent = FocusNode();
    @override
    void dispose() {
      super.dispose();
    }
    @override
    void initState() {
      super.initState();
    }
  @override
  Widget build(BuildContext context) {
    Future<bool> _onBackButtonPressed(BuildContext context) {
     // _timer.cancel();
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          HomePage()), (Route<dynamic> route) => false);
    }
    return WillPopScope(
      onWillPop:()=> _onBackButtonPressed(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor, //Color.fromRGBO(255, 233, 232, 1),
        appBar: AppBar(
          backgroundColor: Theme.of(context).accentColor, //Color.fromRGBO(227, 99, 135, 1),
          title:Text('Create',
          style: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1),
            //fontWeight: FontWeight.w700,
            fontFamily: 'whitneybold',
            fontSize: ResponsiveFlutter.of(context).fontSize(2.2), //20
            ),),
            automaticallyImplyLeading: false,
          leading: IconButton(icon: Icon(Icons.close,
          size: ResponsiveFlutter.of(context).moderateScale(22),
          color: Color.fromRGBO(255, 255, 255, 1),),
          onPressed: (){
              Navigator.push(context,
              MaterialPageRoute(builder: (context) =>HomePage()),
              );
          }),
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
        resizeToAvoidBottomPadding: true,
        body: SingleChildScrollView(
          child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    // count
                    Container(
                      margin: EdgeInsets.only(top:10, right: 15),
                      padding: EdgeInsets.only(top: 3, bottom: 3, left: 7, right: 7,),
                      color: Theme.of(context).accentColor, //Color.fromRGBO(227, 99, 115, 1),
                      child: Text("$textcount",
                        style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        //fontWeight: FontWeight.w700,
                        fontFamily: 'whitneybold',
                        fontSize: ResponsiveFlutter.of(context).fontSize(1.5), //14
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox( height: 10,),
              Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Form(
                  key: poemformKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //Write your own Poem here!
                      TextFormField(
                        focusNode: fncontent,
                        maxLength: 1500,
                        maxLengthEnforced: true,
                        controller: contentController,
                        onChanged: ((String contentController) {
                          setState(() {
                            textcount=1500-contentController.characters.length<0?0:1500-contentController.characters.length;
                            _content = contentController;
                         //   showtextcount(textcount);
                            return _content;
                            //print(_content);
                          });
                        }),
                        decoration: InputDecoration(
                          hintText: "Write your own Poem here!",
                          counterText: "",
                          hintStyle: TextStyle(
                            fontFamily: 'whitneybold',
                            fontSize: ResponsiveFlutter.of(context).fontSize(2),
                            color: Color.fromRGBO(121, 121, 121, 1)
                          ),
                          labelStyle: TextStyle(
                            fontFamily: 'whitneymedium',
                            fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //18,
                            color: Color.fromRGBO(51, 51, 51, 1),
                          ),
                          fillColor: Color.fromRGBO(255, 255, 255, 0.01),
                          filled: true,
                          contentPadding: new EdgeInsets.all(15.0),
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(0.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(color: Color.fromRGBO(255, 255, 255, 0.1), width: 0.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromRGBO(255, 233, 232, 1), width: 0),
                          ),
                          
                        ),
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: ResponsiveFlutter.of(context).fontSize(2.2), //20
                        ),
                        maxLines: 18,
                      ),
                      SizedBox(height: 5,),
                      //name field
                      Container(
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Color.fromRGBO(51, 51, 51, 1), width: 1)),
                        ),
                        child: TextFormField(
                        controller: nameController,
                        onChanged: ((String nameController) {
                          setState(() {
                            _name = nameController;
                            return _name;
                            //print(_name);
                          });
                        }),
                        decoration: InputDecoration(
                          hintText: "Name:",
                          hintStyle: TextStyle(
                            //fontWeight: FontWeight.w700,
                            fontFamily: 'whitneybold',
                            fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //16.0,
                            color: Color.fromRGBO(121, 121, 121, 1)
                          ),
                          labelStyle: TextStyle(
                            //fontWeight: FontWeight.w400,
                            fontFamily: 'whitneymedium',
                            fontSize: ResponsiveFlutter.of(context).fontSize(2.3) ,
                            color: Color.fromRGBO(51, 51, 51, 1),
                          ),
                          fillColor: Color.fromRGBO(255, 255, 255, 0.01),
                          filled: true,
                          contentPadding: new EdgeInsets.all(15.0),
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(0.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(color: Color.fromRGBO(255, 255, 255, 0.1), width: 0.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromRGBO(255, 233, 232, 1), width: 0),
                          ),
                        ),
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: ResponsiveFlutter.of(context).fontSize(2), //16
                        ),
                         // maxLength: 1500,
                      ),
                      ),

                      SizedBox(height: 5,),
                      // location field
                      Container(
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Color.fromRGBO(51, 51, 51, 1), width: 1)),

                        ),
                        child: TextFormField(
                        controller: locationController,
                        onChanged: ((String locationController) {
                          setState(() {
                            _location = locationController;
                            return _location;
                            //print(_name);
                          });
                        }),
                        decoration: InputDecoration(
                          hintText: "Location: State, Country(eg: California,USA)",
                          hintStyle: TextStyle(
                            //fontWeight: FontWeight.w700,
                            fontFamily: 'whitneybold',
                            fontSize: ResponsiveFlutter.of(context).fontSize(1.8),
                            color: Color.fromRGBO(121, 121, 121, 1)
                          ),
                          labelStyle: TextStyle(
                            //fontWeight: FontWeight.w400,
                            fontFamily: 'whitneymedium',
                            fontSize: ResponsiveFlutter.of(context).fontSize(1.8) ,
                            color: Color.fromRGBO(51, 51, 51, 1),
                          ),
                          fillColor: Color.fromRGBO(255, 255, 255, 0.01),
                          filled: true,
                          contentPadding: new EdgeInsets.all(15.0),
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(0.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(color: Color.fromRGBO(255, 255, 255, 0.1), width: 0.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromRGBO(255, 233, 232, 1), width: 0),
                          ),
                        ),
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: ResponsiveFlutter.of(context).fontSize(2), //16
                        ),
                      ),
                      ),
                      
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          //margin: EdgeInsets.only(top: -10),
                          padding: EdgeInsets.all(10),
                          width: ResponsiveFlutter.of(context).moderateScale(70), //70,
                          height: ResponsiveFlutter.of(context).moderateScale(70), //70,
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                           //Color.fromRGBO(255, 233, 232, 1),
                          child: FloatingActionButton(
                          onPressed: (){
                            if(_content?.trim()?.isEmpty ?? true) {
                             // _showMyDialog(context, "Write your poem");
                              Alert.showalertDialog(context, "Write your poem");
                              //  savepoem(context,_content,_name,_location);
                            }else
                              checkInternet(context, _content, _name, _location,contentController,nameController,locationController,fncontent,textcount);

                             },
                          child: Icon(Icons.email,
                          size: ResponsiveFlutter.of(context).moderateScale(24),),
                          backgroundColor: Color.fromRGBO(227, 99, 135, 1),
                        ),
                        ),
                      ),

                      SizedBox(height: 30,),


                    ],
                  )
                ),
              )

           ],
          ),
        ),
        )


      ),
    );
  }
    Future<void> checkInternet(BuildContext context, String _content,String _name,String _location, TextEditingController contentController, TextEditingController nameController, TextEditingController locationController, FocusNode fncontent, int textcount ) async {

      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          savepoem(context,_content,_name,_location,contentController,nameController,locationController,fncontent);
        }else{
          // _showMyDialog(context,"No Internet connection.");
          Alert.showalertDialog(context, "No Internet connection.");
        }
      } on SocketException catch (_) {
        // print('not connected');
        //  _showMyDialog(context,"No Internet connection");
        Alert.showalertDialog(context, "No Internet connection.");
      }
    }
    Future<void> savepoem(BuildContext context, String content,String name,String location, TextEditingController contentController, TextEditingController nameController, TextEditingController locationController, FocusNode fncontent) async {

      var dio = Dio();
      Map<String, dynamic> params = Map();
      params['apitoken'] = 'P@EM';
      params['category_id'] = '10';
      params['written_by'] = name;
      params['location_name']=location;
      params['poem_text'] = content;

      FormData formData = new FormData.fromMap(params);
      var responsedio = await dio.post(UrlConstant.add_poem, data: formData);
      if (responsedio.statusCode == 200) {
        String message = responsedio.data['message'];
        if (message=="success") {
          contentController.clear();
          nameController.clear();
          locationController.clear();
          FocusScope.of(context).requestFocus(fncontent);
          Alert.showalertDialog(context, "Poem submitted successfully. Waiting for approval.");
          setState(() {
            textcount=1500;
          });

        }else
          Alert.showalertDialog(context,message.replaceAll("<p>", "").replaceAll("</p>", ""));
      }
}

}








