import 'dart:convert';



List<Comments> commentFromJson(String str) =>
    List<Comments>.from(json.decode(str).map((x) => Comments.fromJson(x)));
String commentToJson(List<Comments> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Comments {
  final int yorumSayisi;
  final List yorumlar;
  final List onerilenKitap;

  Comments({
    required this.onerilenKitap,
    required this.yorumSayisi,
    required this.yorumlar,
  });
  factory Comments.fromJson(
    Map<String, dynamic> json,
  ) =>
      Comments(
          yorumSayisi: json["yorum_Sayisi"],
          yorumlar: json["yorumlar"],
          onerilenKitap: json["onerilenKitap"]);
  Map<String, dynamic> toJson() => {
        "yorumSayisi": yorumSayisi,
        "yorumlar": yorumlar,
        "onerilenKitap": onerilenKitap
      };

  Comments.fromMap(Map<String, dynamic> map)
      : yorumSayisi = map["yorumSayisi"],
        yorumlar = map["yorumlar"],
        onerilenKitap = map["onerilenKitap"];
  Map<String, dynamic> toMap() {
    return {
      'yorumSayisi': yorumSayisi,
      'yorumlar': yorumlar,
      "onerilenKitap": onerilenKitap
    };
  }

  @override
  String toString() {
    return "Comments {yorumSayisi: $yorumSayisi, yorumlar: $yorumlar, onerilenKitap: $onerilenKitap";
  }
}
