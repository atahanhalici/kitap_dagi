import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kitap_dagi/models/book.dart';
import 'package:http/http.dart' as http;
import 'package:kitap_dagi/models/comment.dart';
import 'package:kitap_dagi/models/yorum.dart';

import '../models/user.dart';

class DbServices {
  String yol = "http://192.168.0.23:3000";
  final GoogleSignIn googleSignIn = GoogleSignIn();
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
    return comments;
  }

  yorumYap(String title, String desc, int verilenYildiz, String bookId,
      String adSoyad) async {
    var body = {
      "title": title,
      "desc": desc,
      "rank": verilenYildiz,
      "id": bookId,
      "nameSurname": adSoyad
    };
    await http.post(Uri.parse(yol + "/mobile/newcomment"),
        headers: {
          // "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: jsonEncode(body));
  }

  Future<bool> kayit(Map<String, String> bilgiler) async {
    var response = await http.post(Uri.parse("$yol/mobile/auth/register"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: jsonEncode(bilgiler));
    var jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  Future<Users> giris(Map<String, String> bilgiler) async {
    print(bilgiler);
    var response = await http.post(Uri.parse("$yol/mobile/auth/login"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: jsonEncode(bilgiler));
    var jsonResponse = json.decode(response.body);

    Users users = Users.fromJson(jsonResponse);
    return users;
  }

  beniHatirlaKontrol() async {
    var box = await Hive.openBox("informations");
    bool durum = false;
    box.get("durum") == null ? durum = false : durum = box.get("durum");
    Map user = {};
    box.get("user") == null ? user = {} : user = box.get("user");
    Users users = Users(mesaj: "", user: user, durum: durum);
    return users;
  }

  cikisYap() async {
    try {
      final response = await http.get(
        Uri.parse("$yol/mobile/auth/logout"),
      );
      var jsonResponse = json.decode(response.body);

      if (jsonResponse == true) {
        var box = await Hive.openBox("informations");
        box.clear();
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map> sifremiUnuttum(String email) async {
    Map<String, String> body = {
      "email": email,
    };
    var response = await http.post(
        Uri.parse("$yol/mobile/auth/forget-password"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: jsonEncode(body));
    var jsonResponse = json.decode(response.body);
    print(jsonResponse);
    return jsonResponse;
  }

  userKontrol(Users users) async {
    Map<String, String> body = {
      "email": users.user["email"],
    };
    var response = await http.post(Uri.parse("$yol/mobile/auth/localDb"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: jsonEncode(body));
    var jsonResponse = json.decode(response.body);
    print(jsonResponse);
    return jsonResponse;
  }

  Future<Users> googleGiris() async {
    var box = await Hive.openBox("informations");

    final GoogleSignInAccount? account = await googleSignIn.signIn();
    Users user = Users(
        mesaj: "",
        user: {
          "name": account!.displayName,
          "email": account.email,
          "password": account.id,
          "surname": ""
        },
        durum: true);
    await box.put("user", user.user);
    await box.put("durum", user.durum);
    await box.put("mesaj", "");
    googleSignIn.signOut();
    return user;
  }
}
