import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kitap_dagi/models/book.dart';
import 'package:http/http.dart' as http;

class DbServices {
  String yol = "http://192.168.0.23:3000";
  Future<List> kitaplariGetir() async {
    List<Book> _books = [];
    //var response = await Dio().get(yol + "/homepage");
    final response = await http.get(Uri.parse(yol + "/homepage"));
    List jsonResponse = json.decode(response.body);
    return jsonResponse;
    /* for (var singleBook in jsonResponse) {
      //  print(singleBook["success"]);

      /*Book book = Book(
          status: singleBook["status"],
          success: Success(
              id: singleBook["success"]["id"],
              buyLinks: singleBook["success"]["buyLinks"],
              author: singleBook["success"]["author"],
              bookImage: singleBook["success"]["bookImage"],
              bookImageWidth: singleBook["success"]["bookImageWidth"],
              bookImageHeight: singleBook["success"]["bookImageHeight"],
              description: singleBook["success"]["description"],
              price: singleBook["success"]["price"],
              publisher: singleBook["success"]["publisher"],
              title: singleBook["success"]["title"],
              rating: singleBook["success"]["rating"],
              createdAt: singleBook["success"]["createdAt"],
              updatedAt: singleBook["success"]["updatedAt"],
              v: singleBook["success"]["v"]));

      _books.add(book);
      print(singleBook["success"]["id"]);*/
    }
*/
  }
}
