import 'package:com_barge_idigital/model/school.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ILocalization {
  late SharedPreferences? _prefs;
  ILocalization(SharedPreferences? pref) {
    this._prefs = pref;
  }
  Map<String, dynamic> object = {
    "school": {"en": "School", "ma": "शाळा"},
    "mobileno": {"en": "Mobile No.", "ma": "मोबाइल क्र"},
    "password": {"en": "Password", "ma": "पासवर्ड"},
    "register": {"en": "Register", "ma": "नोंदणी करणे"},
    "home": {"en": "Home", "ma": "मुख्य पृष्ठ"},
    "standard": {"en": "Standard", "ma": "मानक"},
    "standards": {"en": "Standards", "ma": "मानक"},
    "division": {"en": "Division", "ma": "विभाग"},
    "divisions": {"en": "Divisions", "ma": "विभाग"},
    "staff": {"en": "Staff", "ma": "कर्मचारी"},
    "teacher": {"en": "Teacher", "ma": "शिक्षक"},
    "headmaster": {"en": "Principal", "ma": "मुख्याध्यापक"},
    "headmistress": {"en": "Principal", "ma": "मुख्याध्यापिका"},
    "student": {"en": "Student", "ma": "विद्यार्थी"},
    "students": {"en": "Students", "ma": "विद्यार्थी"},
    "profile": {"en": "Profile", "ma": "प्रोफाइल"},
    "idcard": {"en": "Id Card", "ma": "ओळखपत्र"},
    "name": {"en": "Name", "ma": "नाव"},
    "add": {"en": "Add", "ma": "नवीन"},
    "edit": {"en": "Edit", "ma": "संकलन"},
    "first_name": {"en": "First Name", "ma": "पहिले नाव"},
    "middle_name": {"en": "Middle Name", "ma": "मधले नाव"},
    "last_name": {"en": "Last Name", "ma": "आडनाव"},
    "email": {"en": "Email", "ma": "ईमेल"},
    "medium": {"en": "Medium", "ma": "मध्यम"},
    "english": {"en": "English", "ma": "इंग्रजी"},
    "marathi": {"en": "Marathi", "ma": "मराठी"},
    "grno": {"en": "GR No", "ma": ""},
    "aadharno": {"en": "Aadhar No", "ma": "आधार क्रमऻक"},
    "rollno": {"en": "Roll No", "ma": "पटक्रमांक"},
    "blood_group": {"en": "Blood Group", "ma": "रक्तगट"},
    "address": {"en": "Address", "ma": "पत्ता"},
    "value_can_not_be_empty": {
      "en": "Value Can not be empty",
      "ma": "मूल्य रिकामे असू शकत नाही"
    },
    "description": {"en": "Description", "ma": "वर्णन"},
    "save": {"en": "Save", "ma": "जतन"},
    "image_updated_successfully": {
      "en": "Image Updated Successfully",
      "ma": "प्रतिमा यशस्वीरित्या अद्ययावत"
    },
    "update_data_failed": {
      "en": "Update data failed",
      "ma": "माहिती अद्यतन करण्यात अयशस्वी"
    },
    "submit_data_failed": {
      "en": "Submit data failed",
      "ma": "माहिती जमा करण्यात अयशस्वी"
    },
    "select_an_item": {"en": "Select an item", "ma": "घटक निवडा"},
    "please_wait_its_loading": {
      "en": "Please wait its loading",
      "ma": "दाखलन करीता कृपया थांबा"
    },
    "error": {"en": "Error", "ma": "त्रुटी"},
    "a+": {"en": "A+", "ma": "अ+"},
    "a-": {"en": "A-", "ma": "अ-"},
    "b+": {"en": "B+", "ma": "बा+"},
    "b-": {"en": "B-", "ma": "बा-"},
    "ab+": {"en": "AB+", "ma": "अबा+"},
    "ab-": {"en": "AB-", "ma": "अबा-"},
    "o+": {"en": "O+", "ma": "ओ+"},
    "o-": {"en": "O+", "ma": "ओ-"},
    "dob": {"en": "Date of Birth", "ma": "dob"},
    "extra": {"en": "", "ma": ""},
    "Confirm_Password_should_not_be_empty_and_should_be_match_with_Password": {
      "en":
          "Confirm Password should not be empty and should be match with Password",
      "ma": ""
    }
  };

  String get(String key) {
    String medium = "en";
    if (_prefs!.containsKey("school")) {
      var schoolData = _prefs!.getString("school");
      if (schoolData != null) {
        var schoolList = schoolFromJson("[$schoolData]");
        medium = (schoolList.first.medium == 2 ? "ma" : "en");
      }
    }
    return object.containsKey(key.toLowerCase())
        ? object[key.toLowerCase()][medium]
        : key.toLowerCase();
  }

  String convert(int language, String key) {
    if (object.containsKey(key.toLowerCase())) {
      return object[key.toLowerCase()][language == 2 ? "ma" : "en"];
    } else {
      return key.toLowerCase();
    }
  }
}
