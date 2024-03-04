import 'dart:convert';

import 'package:com_barge_idigital/model/school.dart';

class Teacher {
  String id;
  String firstname;
  String middlename;
  String lastname;
  String gender;
  String divisionid;
  String standardid;
  String email;
  String mobileno;
  String? photo;
  School school;
  String password;
  String role;
  Teacher(
      {this.id = "",
      required this.firstname,
      required this.middlename,
      required this.lastname,
      required this.gender,
      required this.email,
      required this.mobileno,
      required this.standardid,
      required this.divisionid,
      this.photo,
      required this.school,
      required this.role,
      required this.password});

  factory Teacher.fromJson(Map<String, dynamic> map) {
    return Teacher(
        id: map["_id"],
        firstname: map["firstname"],
        middlename: map["middlename"],
        lastname: map["lastname"],
        gender: map["gender"] ?? "",
        email: map["email"],
        mobileno: map["mobileno"],
        standardid: map["standardid"],
        divisionid: map["divisionid"],
        photo: map["photo"],
        school: School.fromJson(map["school"]),
        role: map["role"],
        password: map["password"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "firstname": firstname,
      "middlename": middlename,
      "lastname": lastname,
      "gender": gender,
      "email": email,
      "mobileno": mobileno,
      "standardid": standardid,
      "divisionid": divisionid,
      "photo": photo,
      "school": school.toJson(),
      "role": role,
      "password": password
    };
  }

  @override
  String toString() {
    return '{_id: $id, firstname: $firstname, middlename: $middlename, lastname: $lastname, gender: $gender email: $email, mobileno: $mobileno, standardid: $standardid, divisionid: $divisionid, photo: $photo, school: ${school.toString()}, role: $role, password: $password}';
  }
}

List<Teacher> teacherFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Teacher>.from(data.map((item) => Teacher.fromJson(item)));
}

String teacherToJson(Teacher data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
