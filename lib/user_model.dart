// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str)); // JSON string -> JSON object (User)

String userToJson(User data) => json.encode(data.toJson()); // JSON object (User) -> JSON string

class User {
  Info info;
  String error;
  int id;

  User({
    required this.info,
    required this.error,
    required this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        info: Info.fromJson(json["info"]),
        error: json["error"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "info": info.toJson(),
        "error": error,
        "id": id,
      };
}

class Info {
  String id;
  int infoId;
  String firstName;
  String lastName;
  String email;
  Tracked tracked;
  String password;

  Info({
    required this.id,
    required this.infoId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.tracked,
    required this.password,
  });

  factory Info.fromJson(Map<String, dynamic> json) => Info(
        id: json["_id"],
        infoId: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        tracked: Tracked.fromJson(json["tracked"]),
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "id": infoId,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "tracked": tracked.toJson(),
        "password": password,
      };
}

class Tracked {
  String? calories;
  String? protein;
  String? fat;
  String? water;
  String? carbs;
  String? steps;

  Tracked({
    this.calories,
    this.protein,
    this.fat,
    this.water,
    this.carbs,
    this.steps,
  });

  factory Tracked.fromJson(Map<String, dynamic> json) => Tracked(
        calories: json["calories"],
        protein: json["protein"],
        fat: json["fat"],
        water: json["water"],
        carbs: json["carbs"],
        steps: json["steps"],
      );

  Map<String, dynamic> toJson() => {
        "calories": calories,
        "protein": protein,
        "fat": fat,
        "water": water,
        "carbs": carbs,
        "steps": steps,
      };
}
