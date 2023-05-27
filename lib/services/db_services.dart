import 'dart:convert';

import 'package:kitap_dagi/models/book.dart';
import 'package:http/http.dart' as http;

class DbServices {
  String yol = "http://192.168.0.23:3000";
  Future<List<Book>> kitaplariGetir() async {
    List<Book> _books = [];
    final response = await http.get(Uri.parse(yol + "/homepage"));
    List jsonResponse = json.decode(response.body);
    if (jsonResponse is List) {
      _books = jsonResponse.map((e) => Book.fromJson(e)).toList();
    }
    return _books;
  }
}
