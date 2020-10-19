import 'package:flutter/material.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

void main() => runApp(
  MaterialApp(
    home: AboutUsPage(),
  )
);

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage>
    with SingleTickerProviderStateMixin {

    Color iconColor = Colors.white;
    int currentIndex = 2;
  @override
  Widget build(BuildContext context) {

    

    return Scaffold(     
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,//Color.fromRGBO(255, 233, 232, 1),
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,//Color.fromRGBO(227, 99, 135, 1),
        title:Text('About Us',
        style: TextStyle( 
          color: Color.fromRGBO(255, 255, 255, 1), 
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
          fontSize: ResponsiveFlutter.of(context).fontSize(2.2), //20
          ),),
          //automaticallyImplyLeading: false,
        
      ),

      body: Container(
        child: Column(
          children: <Widget>[
            
            SizedBox(height: 10,),
            


          ],
        ),
      ),

    );
  }

}




