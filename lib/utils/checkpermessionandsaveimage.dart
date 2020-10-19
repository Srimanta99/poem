import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

import 'package:save_in_gallery/save_in_gallery.dart';

class CheckpermessionAndSaveImage{
  static final PermissionHandler _permissionHandler = PermissionHandler();
  static final key = new GlobalKey<ScaffoldState>();
  static Map<PermissionGroup, PermissionStatus> permissions;
 static Future<void> requestPermission(PermissionGroup permission, String poem_bg_img, GlobalKey<ScaffoldState> key, GlobalKey<State<StatefulWidget>> globalKey) async {
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      _onImageSaveButtonPressed(poem_bg_img,key,globalKey);
      // return true;
    }else
      getPermission();
  }

  static void _onImageSaveButtonPressed(String url, GlobalKey<ScaffoldState> key, GlobalKey<State<StatefulWidget>> globalKey) async {
   // print("_onImageSaveButtonPressed");
   // var response = await http
       // .get(url);

    //  debugPrint(response.statusCode.toString());
    try {
      // print('inside');
      List<Uint8List> bytesList = [];
      RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
    //  bytesList.add(byteData.buffer.asUint8List());
     // var filePath = await ImagePickerSaver.saveFile(fileData: pngBytes);
      //await  ImageSaver().saveImages(imageBytes: bytesList);
      //var savedFile= File.fromUri(Uri.file(filePath));
      var bs64 = base64Encode(pngBytes);
      final _imageSaver =  ImageSaver();
      /*final res =  await _imageSaver.saveImage(
        imageBytes: pngBytes,
        //directoryName:  "poem",
      );
      print(pngBytes);*/
      final result = await ImageGallerySaver.saveImage(pngBytes, quality: 70,);

     /* GallerySaver.saveImage(filePath).then((String path) {
        setState(() {

        });
      });*/
      //print(bs64);
      //return pngBytes;
    } catch (e) {
     // print(e);
    }
   /* var filePath = await ImagePickerSaver.saveFile(fileData: pngBytes);
    var savedFile= File.fromUri(Uri.file(filePath));*/
   /* await Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text("Image Copied"),
    ));*/
    key.currentState.showSnackBar(new SnackBar(
      content: LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
        backgroundColor: Colors.white,)
      //new Text("Image saved in gallery"),
    ));
    key.currentState.showSnackBar(new SnackBar( content:new Text("Image saved in gallery.")));
  }
  static getPermission() async {
    permissions = await PermissionHandler().requestPermissions([
      // PermissionGroup.location,
      // PermissionGroup.camera,
      // PermissionGroup.locationAlways,
      // PermissionGroup.phone,
      // PermissionGroup.sensors,
      PermissionGroup.storage,
      // PermissionGroup.microphone,
    ]);
  }
}