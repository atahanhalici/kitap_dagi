import 'dart:convert';

List<Book> bookFromJson(String str) =>
    List<Book>.from(json.decode(str).map((x) => Book.fromJson(x)));
String bookToJson(List<Book> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Book {
  final String id;
  final List buyLinks;
  final String author;
  final String bookImage;
  final String bookImageWidth;
  final String bookImageHeight;
  final String description;
  final String price;
  final String publisher;
  final String title;
  final String rating;
  final String createdAt;
  final String updatedAt;
  final int v;

  Book({
    required this.id,
    required this.buyLinks,
    required this.author,
    required this.bookImage,
    required this.bookImageWidth,
    required this.bookImageHeight,
    required this.description,
    required this.price,
    required this.publisher,
    required this.title,
    required this.rating,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });
  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json["_id"],
        buyLinks: json["buy_links"],
        description: json["description"],
        author: json["author"],
        bookImage: json["book_image"],
        bookImageHeight: json["book_image_height"],
        bookImageWidth: json["book_image_width"],
        createdAt: json["createdAt"],
        price: json["price"],
        publisher: json["publisher"],
        rating: json["rating"],
        title: json["title"],
        updatedAt: json["updatedAt"],
        v: json["__v"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "buyLinks": buyLinks,
        "description": description,
        "author": author,
        "bookImage": bookImage,
        "bookImageHeight": bookImageHeight,
        "bookImageWidth": bookImageWidth,
        "createdAt": createdAt,
        "price": price,
        "publisher": publisher,
        "rating": rating,
        "title": title,
        "updatedAt": updatedAt,
        "v": v,
      };
}

class BuyLink {
  final Name name;
  final String url;
  final String id;
  final String linkPrice;

  BuyLink({
    required this.name,
    required this.url,
    required this.id,
    required this.linkPrice,
  });
}

enum Name {
  AMAZON,
  APPLE_BOOKS,
  BARNES_AND_NOBLE,
  BOOKS_A_MILLION,
  BOOKSHOP,
  INDIE_BOUND
}
