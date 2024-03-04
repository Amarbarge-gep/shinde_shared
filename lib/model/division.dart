import 'dart:convert';

import 'package:com_barge_idigital/model/school.dart';

class Division {
  String id;
  String name;
  String description;
  School school;
  Division(
      {this.id = "",
      required this.name,
      required this.description,
      required this.school});

  factory Division.fromJson(Map<String, dynamic> map) {
    return Division(
        id: map["_id"],
        name: map["name"],
        description: map["description"],
        school: School.fromJson(map["school"]));
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "description": description,
      "school": school.toJson()
    };
  }

  @override
  String toString() {
    return '{_id: $id, name: $name, description: $description, school: ${school.toString()}}';
  }
}

List<Division> divisionFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Division>.from(data.map((item) => Division.fromJson(item)));
}

String divisionToJson(Division data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
