class Favouritepoem {
  int id;
  final int p_id;
  final String poemname;
  final String poemtext;
  //final String featured_image;
  final String poem_bg_img;

  //final String category_name;
  final String poem_txtbg_img;
  final String poem_author;
  final String location;

  Favouritepoem({
    this.id,
    this.p_id,
    this.poemname,
    this.poemtext,
   // this.featured_image,
    this.poem_bg_img,
    //this.category_name,
    this.poem_txtbg_img,
    this.poem_author,
    this.location
  });


  factory Favouritepoem.fromMap(Map<String, dynamic> json) => new Favouritepoem(
    id: json["id"],
    p_id: json["p_id"],
    poemname: json["poemname"],
    poemtext: json["poemtext"],
    poem_bg_img: json["poemimage"],
    poem_txtbg_img:json["poem_txtbg_img"],
      poem_author:json['poem_author'],
      location:json['location']
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "p_id":p_id,
    "poemname": poemname,
    "poemtext": poemtext,
    "poem_bg_img": poem_bg_img,
    "poem_txtbg_img":poem_txtbg_img,
    "poem_author":poem_author,
    "location":location
  };
}