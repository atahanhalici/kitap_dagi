import 'dart:convert';

import 'package:kitap_dagi/models/yorum.dart';

List<Comments> commentFromJson(String str) =>
    List<Comments>.from(json.decode(str).map((x) => Comments.fromJson(x)));
String commentToJson(List<Comments> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Comments {
  final int yorumSayisi;
  final List yorumlar;

  Comments({
    required this.yorumSayisi,
    required this.yorumlar,
  });
  factory Comments.fromJson(Map<String, dynamic> json) =>
      Comments(yorumSayisi: json["yorum_Sayisi"], yorumlar: json["yorumlar"]);
  Map<String, dynamic> toJson() => {
        "yorumSayisi": yorumSayisi,
        "yorumlar": yorumlar,
      };

  Comments.fromMap(Map<String, dynamic> map)
      : yorumSayisi = map["yorumSayisi"],
        yorumlar = map["yorumlar"];
  Map<String, dynamic> toMap() {
    return {'yorumSayisi': yorumSayisi, 'yorumlar': yorumlar};
  }

  @override
  String toString() {
    return "Comments {yorumSayisi: $yorumSayisi, yorumlar: $yorumlar";
  }
}
