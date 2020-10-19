class PoemModel{
  final String id;
  final String category_id;
  final String written_by;
  final String poem_text;
  final String poem_text_wm_image;
  final String featured_image;
  final String location_name;
  final String posted_dateime;
  final String is_approved;
  final String status;
  final String last_update_datetime;
  final String is_deleted;
  final String poem_bg_img;
  final String category_name;
  final String poem_txtbg_img;

  PoemModel(this.id, this.category_id, this.written_by, this.poem_text,this.poem_text_wm_image, this.featured_image, this.location_name, this.posted_dateime, this.is_approved, this.status, this.last_update_datetime, this.is_deleted, this.poem_bg_img, this.category_name,
      this.poem_txtbg_img);

  PoemModel.fromJson(Map jsonMap)
      : id = jsonMap['id'],
        category_id = jsonMap['category_id'],
        written_by = jsonMap['written_by'],
        poem_text =  jsonMap['poem_text'],
        poem_text_wm_image=jsonMap['poem_text_wm_image'],
        featured_image = jsonMap['featured_image'],
        location_name = jsonMap['location_name'],
        posted_dateime = jsonMap['posted_dateime'],
        is_approved = jsonMap['is_approved'],
        status = jsonMap['status'],
        last_update_datetime = jsonMap['last_update_datetime'],
        is_deleted = jsonMap['is_deleted'],
        poem_bg_img = jsonMap['poem_bg_img'],
        category_name = jsonMap['category_name'],
        poem_txtbg_img=jsonMap['poem_txtbg_img']
  ;

}