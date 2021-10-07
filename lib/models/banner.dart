class Banners {
  final int id;
  final String url;
  final String imageUrl;

  Banners({this.id, this.url, this.imageUrl});

  factory Banners.fromJson(Map<String, dynamic> json) {
    return Banners(id: json['id'], url: json['link'], imageUrl: json['banner'],
        // imageUrl: json['banner']['guid']
        );
  }
}
