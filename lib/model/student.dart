import 'dart:convert';

import 'package:com_barge_idigital/model/division.dart';
import 'package:com_barge_idigital/model/school.dart';
import 'package:com_barge_idigital/model/standard.dart';

class Student {
  String id;
  String qrid;
  String firstname;
  String middlename;
  String lastname;
  String email;
  String mobileno;
  String grno;
  String aadharno;
  String standardid;
  String divisionid;
  String? photo;
  String address;
  String udise;
  String bloodgroup;
  String house;
  String rollno;
  Division? division;
  Standard? standard;
  School? school;
  DateTime dob;

  Student(
      {this.id = "",
      required this.qrid,
      required this.firstname,
      required this.middlename,
      required this.lastname,
      required this.email,
      required this.mobileno,
      required this.aadharno,
      required this.grno,
      required this.standardid,
      required this.divisionid,
      this.photo,
      required this.address,
      required this.bloodgroup,
      required this.house,
      required this.rollno,
      required this.udise,
      this.school,
      this.standard,
      this.division,
      required this.dob});

  factory Student.fromJson(Map<String, dynamic> map) {
    return Student(
        id: map["_id"],
        qrid: map["qrid"],
        firstname: map["firstname"],
        middlename: map["middlename"],
        lastname: map["lastname"],
        email: map["email"],
        mobileno: map["mobileno"],
        aadharno: map["aadharno"],
        grno: map["grno"],
        standardid: map["standardid"],
        divisionid: map["divisionid"],
        photo: map["photo"],
        address: map["address"],
        bloodgroup: map["bloodgroup"],
        house: map["house"],
        rollno: map["rollno"],
        udise: map["udise"],
        school: School.fromJson(map["school"]),
        standard: Standard.fromJson(map["standard"]),
        division: Division.fromJson(map["division"]),
        dob: DateTime.parse(map["dob"]));
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "id": id,
      "qrid": qrid,
      "firstname": firstname,
      "middlename": middlename,
      "lastname": lastname,
      "email": email,
      "mobileno": mobileno,
      "aadharno": aadharno,
      "grno": grno,
      "standardid": standardid,
      "divisionid": divisionid,
      "photo": photo,
      "address": address,
      "bloodgroup": bloodgroup,
      "house": house,
      "rollno": rollno,
      "udise": udise,
      "school": school?.toJson(),
      "standard": standard?.toJson(),
      "division": division?.toJson(),
      "dob": dob.toIso8601String()
    };
  }

  @override
  String toString() {
    return '{_id: $id, qrid: $qrid, firstname: $firstname, middlename: $middlename, lastname: $lastname, email: $email, mobileno: $mobileno, aadharno: $aadharno, grno: $grno, standardid: $standardid, divisionid: $divisionid, photo: $photo, address: $address, bloodgroup: $bloodgroup, house: $house, rollno: $rollno, udise: $udise, school: ${school.toString()}, standard: ${standard.toString()}, division: ${division.toString()}, dob: $dob}';
  }
}

List<Student> studentFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Student>.from(data.map((item) => Student.fromJson(item)));
}

String studentToJson(Student data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
