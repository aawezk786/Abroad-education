class Notifications{
  final int id;
  final String url;
  final String title;
  final String body;

  Notifications({this.id,this.url,this.title,this.body});

  factory Notifications.fromJson(Map<String,dynamic>json){
    return Notifications(
      id: json['id'],
      url: json['url'],
      title: json['title'],
      body: json['body']
    );
  }
}