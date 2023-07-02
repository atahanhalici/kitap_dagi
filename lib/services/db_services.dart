import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kitap_dagi/models/book.dart';
import 'package:http/http.dart' as http;
import 'package:kitap_dagi/models/comment.dart';
import 'package:twitter_login_v2/twitter_login_v2.dart';

import '../models/user.dart';

class DbServices {
  String yol = "https://www.kitapdagi.com.tr";
  final GoogleSignIn googleSignIn = GoogleSignIn();
  Future<List<Book>> kitaplariGetir() async {
    // ignore: no_leading_underscores_for_local_identifiers
    List<Book> _books = [];
    final response = await http.get(Uri.parse("$yol/mobile/homepage"));
    List jsonResponse = json.decode(response.body);
    // ignore: unnecessary_type_check
    if (jsonResponse is List) {
      _books = jsonResponse.map((e) => Book.fromJson(e)).toList();
    }
    return _books;
  }

  yorumlariGetir(String id) async {
    var body = {"id": id};
    final response = await http.post(Uri.parse("$yol/mobile/comment"),
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
    await http.post(Uri.parse("$yol/mobile/newcomment"),
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
    bool mailgiris = false;
    box.get("mailgiris") == null
        ? mailgiris = false
        : mailgiris = box.get("mailgiris");
    Users users =
        Users(mesaj: "", user: user, durum: durum, mailgiris: mailgiris);
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
    return jsonResponse;
  }

  Future<Users> googleGiris() async {
    try {
      var box = await Hive.openBox("informations");

      final GoogleSignInAccount? account = await googleSignIn.signIn();
      Map<String, String> body = {
        "email": account!.email,
      };
      var response = await http.post(
          Uri.parse("$yol/mobile/auth/getGoogleInfo"),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json"
          },
          body: jsonEncode(body));
      var jsonResponse = json.decode(response.body);
      if (jsonResponse["durum"] == true) {
        Users user = Users.fromJson(jsonResponse);
        await box.put("user", user.user);
        await box.put("durum", user.durum);
        await box.put("password", account.id);
        await box.put("mesaj", "");
        await box.put("mailgiris", false);
        googleSignIn.signOut();
        return user;
      } else {
        await http.post(Uri.parse("$yol/mobile/auth/google"),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json"
            },
            body: jsonEncode({
              "name": account.displayName,
              "email": account.email,
              "password": account.id,
              "surname": ""
            }));
        Users user =
            await giris({"email": account.email, "password": account.id});
        await box.put("user", user);
        await box.put("durum", user.durum);
        await box.put("mesaj", "");
        await box.put("mailgiris", false);
        googleSignIn.signOut();
        return user;
      }
    } catch (e) {
      return Users(mesaj: "", user: {}, durum: false, mailgiris: false);
    }
  }

  twitterGiris() async {
    // ignore: unused_local_variable
    var box = await Hive.openBox("informations");
    final twitterLogin = TwitterLoginV2(
      clientId: "REtFQnRvd1VpUzQ4SUwtU2dKUk06MTpjaQ",
      redirectURI: '$yol/auth/twitter/callback',
    );
    try {
      // ignore: unused_local_variable
      final accessToken = await twitterLogin.loginV2();

      return Users(mesaj: "", user: {}, durum: false, mailgiris: false);
    } catch (e) {
      return Users(mesaj: "", user: {}, durum: false, mailgiris: false);
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
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<List<Book>> favoriGetir(String id) async {
    try {
      final response = await http.get(
        Uri.parse("$yol/mobile/auth/favorites/$id"),
      );
      var jsonResponse = json.decode(response.body);
      List sa = jsonResponse["book"];
      for (int i = 0; i < sa.length; i++) {
        sa[i]["createdAt"] = "";
        sa[i]["updatedAt"] = "";
      }
      List<Book> asd = sa.map((e) => Book.fromJson(e)).toList();
      return asd;
    } catch (e) {
      return [];
    }
  }

  favoriKaldir(String id, String bookid) async {
    try {
      final response = await http.get(
        Uri.parse("$yol/mobile/auth/deletefavorite/$id/$bookid"),
      );
      var jsonResponse = json.decode(response.body);
      return jsonResponse;
    } catch (e) {
      return false;
    }
  }

  favoriEkle(String userId, String bookId) async {
    Map<String, String> body = {"book": bookId, "user": userId};

    try {
      var response = await http.post(Uri.parse("$yol/mobile/auth/addfavorite"),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json"
          },
          body: jsonEncode(body));
      var jsonResponse = json.decode(response.body);
      return jsonResponse;
    } catch (e) {
      return {"durum": false, "mesaj": "HATA"};
    }
  }

  guncelle(String text, String text2, String user) async {
    Map<String, String> body = {"email": user, "name": text, "surname": text2};

    try {
      var response = await http.post(Uri.parse("$yol/mobile/auth/profile"),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json"
          },
          body: jsonEncode(body));
      var jsonResponse = json.decode(response.body);
      return jsonResponse;
    } catch (e) {
      return {"durum": false, "mesaj": "HATA"};
    }
  }

  gununKitabi() async {
    try {
      var response = await http.get(Uri.parse("$yol/mobile/book-of-the-day"));
      var jsonResponse = json.decode(response.body);
      return Book.fromJson(jsonResponse["book"][0]);
      // ignore: empty_catches
    } catch (e) {}
  }

  sifreGuncelle(String isim, String soyisim, String user) async {
    Map<String, String> body = {
      "email": user,
      "oldpass": isim,
      "newpass": soyisim
    };

    try {
      var response = await http.post(
          Uri.parse("$yol/mobile/auth/updatePassword"),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json"
          },
          body: jsonEncode(body));
      var jsonResponse = json.decode(response.body);

      return jsonResponse;
    } catch (e) {
      return {"durum": false, "mesaj": "HATA", "password": ""};
    }
  }

  aramaKitapGetir(String isim) async {
    try {
      final response = await http.get(
        Uri.parse("$yol/mobile/search/$isim"),
      );
      var jsonResponse = json.decode(response.body);
      List sa = jsonResponse["book"];
      var asd = sa.map((e) => Book.fromJson(e)).toList();
      Map son = {"title": jsonResponse["title"], "book": asd};
      return son;
      // ignore: empty_catches
    } catch (e) {}
  }
}
