//Manish

import 'model.dart';

class ArticleItem extends Model {
  static String table = 'article_iems';

  String category;
  String heading;
  String heading_link;
  String heading_type;
  String image_link;

  ArticleItem(
      {this.heading,
      this.heading_link,
      this.category,
      this.heading_type,
      this.image_link});

//  Map<String, dynamic> toMap() {
//    Map<String, dynamic> map = {'heading': heading, 'url': url};
//    return map;
//  }

//  static ArticleItem fromMap(Map<String, dynamic> map) {
//    return ArticleItem(heading: map['heading'], url: map['url']);
//  }

  factory ArticleItem.fromJson(Map<String, dynamic> json) {
    return ArticleItem(
      heading: json['heading'],
      heading_link: json['heading_link'],
      // heading_type: json['heading_type'],
      category: json['category'],
      image_link: json['image_link'],
    );
  }
}
