import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class Alert{
  static void showalertDialog(BuildContext context,String message) async{
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context){

          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              content: Container(
                  padding: EdgeInsets.all(15),
                  width: ResponsiveFlutter.of(context).moderateScale(350),
                  height:    ResponsiveFlutter.of(context).moderateScale(240),
                child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    "Poems",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color.fromRGBO(58, 58, 58, 1),
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Roboto',
                                        fontSize:  ResponsiveFlutter.of(context).fontSize(2.2)),
                                  ),
                                ),

                                SizedBox(height: 20,),
                                Container(
                                  child:  Text(message,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        //fontWeight: FontWeight.w400,
                                        fontFamily: 'whitneymedium',
                                        fontSize: ResponsiveFlutter.of(context).fontSize(2.2),
                                      )
                                  ),
                                ),
                                SizedBox(height: 40,),
                              ],
                            )
                        ),


                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: ResponsiveFlutter.of(context).moderateScale(60),
                            color: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(108, 99, 255, 1),
                                  borderRadius: BorderRadius.circular(5.0)
                              ),
                              child: InkWell(
                                onTap: () async {
                                  Navigator.of(context).pop();
                                },
                                child: Center(
                                    child: Text('DONE',
                                      style: TextStyle(
                                          color: Color.fromRGBO(255, 255, 255, 1),
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Roboto',
                                          fontSize: ResponsiveFlutter.of(context).fontSize(2)),
                                    )
                                ),
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
  static Future<void> showMyDialog(BuildContext context,String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
          ),
          title: Text('Poems',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                //fontWeight: FontWeight.w700,
                fontFamily: 'whitneybold',
                fontSize: ResponsiveFlutter.of(context).fontSize(2.4),
              )
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      //fontWeight: FontWeight.w400,
                      fontFamily: 'whitneymedium',
                      fontSize: ResponsiveFlutter.of(context).fontSize(2.2),
                    )
                ),
                // Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            Expanded(
              flex: 10,
              child: FlatButton(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(227, 99, 135, 1),
                      borderRadius: BorderRadius.circular(2.0)
                  ),
                  child: Center(
                      child: Text('DONE',
                        style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            //fontWeight: FontWeight.w700,
                            fontFamily: 'whitneybold',
                            fontSize: ResponsiveFlutter.of(context).fontSize(2)),
                      )
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),

            )

          ],
        );
      },
    );
  }
}