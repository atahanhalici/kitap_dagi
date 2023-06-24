import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kitap_dagi/models/book.dart';
import 'package:http/http.dart' as http;
import 'package:kitap_dagi/models/comment.dart';
import 'package:twitter_login_v2/twitter_login_v2.dart';

import '../models/user.dart';

class DbServices {
  String yol = "https://kitapdagi.onrender.com";
  final GoogleSignIn googleSignIn = GoogleSignIn();
  Future<List<Book>> kitaplariGetir() async {
    List<Book> _books = [];
    final response = await http.get(Uri.parse(yol + "/mobile/homepage"));
    List jsonResponse = json.decode(response.body);
    print(jsonResponse.runtimeType);
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
    try {
      var box = await Hive.openBox("informations");

      final GoogleSignInAccount? account = await googleSignIn.signIn();
      List isim = account!.displayName!.split(" ");
      String ad = "";
      String soyad = "";
      if (isim.length > 2) {
        for (int i = 0; i < isim.length; i++) {
          ad += " ${isim[i]}";
        }
        soyad = isim.last;
      } else {
        ad = isim[0];
        soyad = isim[1];
      }
      Users user = Users(
          mesaj: "",
          user: {
            "name": ad,
            "email": account.email,
            "password": account.id,
            "surname": soyad
          },
          durum: true);
      await box.put("user", user.user);
      await box.put("durum", user.durum);
      await box.put("password", account.id);
      await box.put("mesaj", "");
      await http.post(Uri.parse("$yol/mobile/auth/google"),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json"
          },
          body: jsonEncode({
            "name": ad,
            "email": account.email,
            "password": account.id,
            "surname": soyad
          }));

      googleSignIn.signOut();
      return user;
    } catch (e) {
      return Users(mesaj: "", user: {}, durum: false);
    }
  }

  twitterGiris() async {
    var box = await Hive.openBox("informations");
    final twitterLogin = TwitterLoginV2(
      clientId: "REtFQnRvd1VpUzQ4SUwtU2dKUk06MTpjaQ",
      redirectURI: '$yol/auth/twitter/callback',
    );
    try {
      final accessToken = await twitterLogin.loginV2();
      print('login successed');
      print(accessToken.toJson());
      return Users(mesaj: "", user: {}, durum: false);
    } catch (e) {
      print('login failed');
      print(e);
      return Users(mesaj: "", user: {}, durum: false);
    }
  }

  kategoriKitapGetir(String id) async {
    try {
      final response = await http.get(
        Uri.parse("$yol/mobile/page/$id"),
      );
      var jsonResponse = json.decode(response.body);
      List sa = jsonResponse["book"];
      var asd = sa.map((e) => Book.fromJson(e)).toList();
      Map son = {"title": jsonResponse["title"], "book": asd};
      return son;
    } catch (e) {}
  }
}
