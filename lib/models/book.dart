class Book {
    final String id;
    final List<BuyLink> buyLinks;
    final String author;
    final String bookImage;
    final String bookImageWidth;
    final String bookImageHeight;
    final String description;
    final String price;
    final String publisher;
    final String title;
    final String rating;
    final DateTime createdAt;
    final DateTime updatedAt;
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

enum Name { AMAZON, APPLE_BOOKS, BARNES_AND_NOBLE, BOOKS_A_MILLION, BOOKSHOP, INDIE_BOUND }
