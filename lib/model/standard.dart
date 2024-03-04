import 'dart:convert';

import 'package:com_barge_idigital/model/school.dart';

class Standard {
  String id;
  String name;
  String description;
  School school;
  Standard(
      {this.id = "",
      required this.name,
      required this.description,
      required this.school});

  factory Standard.fromJson(Map<String, dynamic> map) {
    return Standard(
        id: map["id"],
        name: map["name"],
        description: map["description"],
        school: School.fromJson(map["school"]));
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "school": school.toJson()
    };
  }

  @override
  String toString() {
    return 'Profile{id: $id, name: $name, description: $description, school: ${school.toString()}}';
  }
}

List<Standard> standardFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Standard>.from(data.map((item) => Standard.fromJson(item)));
}

String standardToJson(Standard data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
