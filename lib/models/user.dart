class Users {
  final bool durum;
  final String mesaj;
  final Map user;
  final bool mailgiris;

  Users({
    required this.mesaj,
    required this.user,
    required this.durum,
    required this.mailgiris,
  });
  factory Users.fromJson(Map<String, dynamic> json) => Users(
        durum: json["durum"],
        mesaj: json["mesaj"],
        mailgiris: json["mailgiris"],
        user: json["user"]["user"],
      );
  Map<String, dynamic> toJson() =>
      {"durum": durum, "mesaj": mesaj, "user": user, "mailgiris": mailgiris};
  Users.fromMap(Map<String, dynamic> map)
      : durum = map["durum"],
        mesaj = map["mesaj"],
        user = map["user"]["user"],
        mailgiris = map["mailgiris"];
  Map<String, dynamic> toMap() {
    return {
      "durum": durum,
      "mesaj": mesaj,
      "user": user,
      "mailgiris": mailgiris
    };
  }
}

/*class User {
  final String id;
  final String name;
  final String surname;
  final String email;
  final bool emailIsActive;
  final String password;
  final String createdAt;
  final String updatedAt;
  final int v;

  User({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.emailIsActive,
    required this.password,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        name: json["name"],
        surname: json["surname"],
        email: json["email"],
        emailIsActive: json["emailIsActive"],
        password: json["password"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        v: json["__v"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "surname": v,
        "email": email,
        "emailIsActive": emailIsActive,
        "password": password,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "v": v,
      };
  User.fromMap(Map<String, dynamic> map)
      : id = map["_id"],
        name = map["name"],
        surname = map["surname"],
        email = map["email"],
        emailIsActive = map["emailIsActive"],
        password = map["password"],
        createdAt = map["createdAt"],
        updatedAt = map["updatedAt"],
        v = map["__v"];
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "surname": v,
      "email": email,
      "emailIsActive": emailIsActive,
      "password": password,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "v": v,
    };
  }
}*/
