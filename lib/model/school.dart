import 'dart:convert';

class School {
  String id;
  String name;
  String description;
  int medium;
  String? logo;
  String? sign;
  School(
      {this.id = "",
      required this.name,
      required this.description,
      required this.medium,
      this.logo,
      this.sign});

  factory School.fromJson(Map<String, dynamic> map) {
    return School(
        id: map["id"],
        name: map["name"],
        description: map["description"],
        medium: map["medium"],
        logo: map["logo"],
        sign: map["sign"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "medium": medium,
      "logo": logo,
      "sign": sign
    };
  }

  @override
  String toString() {
    return 'Profile{id: $id, name: $name, description: $description, medium: $medium, logo: $logo, sign: $sign}';
  }
}

List<School> schoolFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<School>.from(data.map((item) => School.fromJson(item)));
}

String schoolToJson(School data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
