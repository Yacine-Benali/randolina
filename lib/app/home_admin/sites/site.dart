class Site {
  Site({
    required this.id,
    required this.url,
    required this.title,
  });
  String id;
  String url;
  String title;

  factory Site.fromMap(Map<String, dynamic> data, String id) {
    final String url = data['url'] as String;
    final String title = data['title'] as String;

    return Site(
      id: id,
      url: url,
      title: title,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'title': title,
    };
  }
}
