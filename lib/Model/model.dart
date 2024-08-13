// To parse this JSON data, do
//
//     final User = UserFromJson(jsonString);

import 'dart:convert';

List<User> UserFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String UserToJson(List<User> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
    String name;
    String email;
    int phoneNumber;
    String location;
    String id;
    String? UserName;
    String? UserEmail;
    String? UserPhoneNumber;

    User({
        required this.name,
        required this.email,
        required this.phoneNumber,
        required this.location,
        required this.id,
        this.UserName,
        this.UserEmail,
        this.UserPhoneNumber,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["Name"],
        email: json["Email"],
        phoneNumber: json["PhoneNumber"],
        location: json["location"],
        id: json["id"],
        UserName: json["name"],
        UserEmail: json["email"],
        UserPhoneNumber: json["phoneNumber"],
    );

    Map<String, dynamic> toJson() => {
        "Name": name,
        "Email": email,
        "PhoneNumber": phoneNumber,
        "location": location,
        "id": id,
        "name": UserName,
        "email": UserEmail,
        "phoneNumber": UserPhoneNumber,
    };
}
