import 'dart:convert';

import 'package:kitap_dagi/models/book.dart';
import 'package:http/http.dart' as http;
import 'package:kitap_dagi/models/comment.dart';
import 'package:kitap_dagi/models/yorum.dart';

class DbServices {
  String yol = "http://192.168.0.23:3000";
  Future<List<Book>> kitaplariGetir() async {
    List<Book> _books = [];
    final response = await http.get(Uri.parse(yol + "/mobile/homepage"));
    List jsonResponse = json.decode(response.body);
    if (jsonResponse is List) {
      _books = jsonResponse.map((e) => Book.fromJson(e)).toList();
    }
    return _books;
  }

  yorumlariGetir(String id) async {
    var body = {"id": id};
    final response = await http.post(Uri.parse(yol + "/mobile/comment"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: jsonEncode(body));
    var jsonResponse = json.decode(response.body);

    Comments comments = Comments.fromJson(jsonResponse);
    print(comments.yorumlar);
    return comments;
  }

  yorumYap(String title, String desc, int verilenYildiz, String bookId) async {
    var body = {
      "title": title,
      "desc": desc,
      "rank": verilenYildiz,
      "id": bookId
    };
    final response = await http.post(Uri.parse(yol + "/mobile/newcomment"),
        headers: {
          // "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: jsonEncode(body));
  }
}
