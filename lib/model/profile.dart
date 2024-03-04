import 'dart:convert';

import 'package:com_barge_idigital/model/school.dart';

class Profile {
  String id;
  String firstname;
  String middlename;
  String lastname;
  String username;
  String password;
  School school;
  String? photo;
  String role;
  Profile(
      {this.id = "",
      required this.firstname,
      required this.middlename,
      required this.lastname,
      required this.password,
      required this.photo,
      required this.school,
      required this.role,
      this.username = ""});

  factory Profile.fromJson(Map<String, dynamic> map) {
    return Profile(
        id: map["_id"].toString(),
        firstname: map["firstname"],
        middlename: map["middlename"],
        lastname: map["lastname"],
        password: map["password"],
        school: map.containsKey("school") && map["school"] != ""
            ? School.fromJson(map["school"])
            : School(name: "", description: "", medium: 0),
        photo: map["photo"],
        role: map["role"],
        username: map["username"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "id": id,
      "firstname": firstname,
      "middlename": middlename,
      "lastname": lastname,
      "password": password,
      "school": school.toJson(),
      "role": role,
      "username": username,
      "photo": photo,
    };
  }

  @override
  String toString() {
    return '{_id: $id, firstname: $firstname, middlename: $middlename, lastname: $lastname, school: ${school.toString()}, password: $password, role: $role, username: $username, photo: $photo}';
  }
}

List<Profile> profileListFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Profile>.from(data.map((item) => Profile.fromJson(item)));
}

Profile profileFromJson(String jsonData) {
  // final data = json.decode(jsonData);
  final data = jsonDecode(jsonData);
  return Profile.fromJson(data);
}

String profileToJson(Profile data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
