
import 'dart:async';

import 'package:poems/model/PoemModel.dart';
class TopCategoryModel{
  final String id;
  final String category_name;
  final String parent_id;
  final String listing_position;
  final String featured_image;
  final String status;
  final String is_deleted;
  final String category_bg_img;
  final List<PoemModel> poems;

  TopCategoryModel({this.id, this.category_name, this.parent_id, this.listing_position,
  this.featured_image, this.status, this.is_deleted, this.category_bg_img,this.poems});


  TopCategoryModel.fromJson(Map jsonMap)
      : id = jsonMap['id'],
        category_name = jsonMap['category_name'],
        parent_id = jsonMap['parent_id'],
        listing_position =  jsonMap['listing_position'],
        featured_image = jsonMap['featured_image'],
        status = jsonMap['status'],
        is_deleted = jsonMap['is_deleted'],
        category_bg_img = jsonMap['category_bg_img'],
        poems = (jsonMap['poems'] as List).map((i) => PoemModel.fromJson(i)).toList()
  ;
}

class Childs {
  final String id;
  final String category_name;
  final String parent_id;
  final String listing_position;
  final String featured_image;
  final String status;
  final String is_deleted;
  final String category_bg_img;
  final List<PoemModel> poems;
  const Childs(this.id, this.category_name, this.parent_id, this.listing_position, this.featured_image, this.status,
      this.is_deleted, this.category_bg_img,this.poems);

  Childs.fromJson(Map jsonMap)
      : id = jsonMap['id'],
        category_name = jsonMap['category_name'],
        parent_id = jsonMap['parent_id'],
        listing_position = jsonMap['listing_position'],
        featured_image = jsonMap['featured_image'],
        status = jsonMap['status'],
        is_deleted = jsonMap['is_deleted'],
        category_bg_img = jsonMap['category_bg_img'],
        poems = (jsonMap['poems'] as List).map((i) => PoemModel.fromJson(i)).toList();

}
