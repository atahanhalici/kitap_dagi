class Yorumlar {
  final String id;
  final String title;
  final String bookId;
  final String rank;
  final String desc;
  final String createdAt;
  final String updatedAt;
  final int v;

  Yorumlar({
    required this.id,
    required this.title,
    required this.bookId,
    required this.rank,
    required this.desc,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });
  factory Yorumlar.fromJson(Map<String, dynamic> json) => Yorumlar(
        id: json["_id"],
        bookId: json["bookId"],
        createdAt: json["createdAt"],
        rank: json["rank"],
        title: json["title"],
        updatedAt: json["updatedAt"],
        v: json["__v"],
        desc: json["desc"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "bookId": bookId,
        "createdAt": createdAt,
        "rank": rank,
        "title": title,
        "updatedAt": updatedAt,
        "v": v,
        "desc": desc,
      };
  Yorumlar.fromMap(Map<String, dynamic> map)
      : id = map["_id"],
        bookId = map["bookId"],
        createdAt = map["createdAt"],
        rank = map["rank"],
        title = map["title"],
        updatedAt = map["updatedAt"],
        v = map["__v"],
        desc = map["desc"];
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookId': bookId,
      'createdAt': createdAt,
      'rank': rank,
      'title': title,
      'updatedAt': updatedAt,
      'v': v,
      'desc': desc
    };
  }
}
