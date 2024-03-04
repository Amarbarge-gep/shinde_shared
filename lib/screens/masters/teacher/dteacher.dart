import 'dart:convert';

import 'package:com_barge_idigital/model/division.dart';
import 'package:com_barge_idigital/model/localization.dart';
import 'package:com_barge_idigital/model/profile.dart';
import 'package:com_barge_idigital/model/school.dart';
import 'package:com_barge_idigital/model/standard.dart';
import 'package:com_barge_idigital/model/teacher.dart';
import 'package:com_barge_idigital/screens/common/customposition.dart';
import 'package:com_barge_idigital/screens/settings/components/profile.dart';
import 'package:com_barge_idigital/screens/settings/photoupload.dart';
import 'package:com_barge_idigital/services/api/division.dart';
import 'package:com_barge_idigital/services/api/school.dart';
import 'package:com_barge_idigital/services/api/standard.dart';
import 'package:com_barge_idigital/services/api/teacher.dart';
import 'package:com_barge_idigital/services/common/meths.dart';
import 'package:com_barge_idigital/services/common/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class TeacherForm extends StatefulWidget {
  final Teacher teacher;
  const TeacherForm({super.key, required this.teacher});

  @override
  State<TeacherForm> createState() => _TeacherFormState();
}

class _TeacherFormState extends State<TeacherForm> {
  ApiTeacher apiTeacher = ApiTeacher();
  late Uint8List _profileImage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _controllerFirstName = TextEditingController();
  final TextEditingController _controllerMiddleName = TextEditingController();
  final TextEditingController _controllerLastName = TextEditingController();
  final TextEditingController _controllerGender = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerRole = TextEditingController();
  final TextEditingController _controllerMobileNo = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();

  late School _selectedObjSchool;

  ApiSchool apiSchool = ApiSchool();
  late Future<List<School>?> _futureSchool;
  String _selectedSchool = "";

  late SMITrigger error;
  late SMITrigger success;
  late SMITrigger confetti;

  bool isShowLoading = false;
  bool isShowConfetti = false;

  void _onCheckRiveInit(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');

    artboard.addController(controller!);
    error = controller.findInput<bool>('Error') as SMITrigger;
    success = controller.findInput<bool>('Check') as SMITrigger;
  }

  void _onConfettiRiveInit(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);

    confetti = controller.findInput<bool>("Trigger explosion") as SMITrigger;
  }

  @override
  void initState() {
    _controllerFirstName.text = widget.teacher.firstname;
    _controllerMiddleName.text = widget.teacher.middlename;
    _controllerLastName.text = widget.teacher.lastname;
    _controllerGender.text = widget.teacher.gender;
    _controllerEmail.text = widget.teacher.email;
    _controllerMobileNo.text = widget.teacher.mobileno;
    _profileImage = widget.teacher.photo != null
        ? base64Decode(widget.teacher.photo.toString())
        : Uint8List(0);
    _selectedDivision = widget.teacher.divisionid;
    _selectedStandard = widget.teacher.standardid;
    _futureStandard = standard.getStandards();
    _futureDivision = division.getDivisions();
    _futureSchool = apiSchool.getSchools();
    _controllerRole.text = widget.teacher.role;
    _controllerPassword.text = widget.teacher.password;
    _controllerConfirmPassword.text = widget.teacher.password;
    super.initState();
  }

  getCurrentRole() {
    String userRole = "S";
    if (_prefs.containsKey("userProfile")) {
      var userProfileData = _prefs.getString("userProfile");
      if (userProfileData != null) {
        var users = profileFromJson(userProfileData);
        userRole = users.role;
        return userRole;
      } else {
        return userRole;
      }
    } else {
      return userRole;
    }
  }

  List<Widget> loadSchool() {
    if (getCurrentRole() != "A") {
      var schoolData = _prefs.getString("school");
      var schoolList = schoolFromJson("[$schoolData]");
      _selectedObjSchool = schoolList.first;
      _selectedSchool = _selectedObjSchool.id;
      return [];
    }
    return [
      Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
          child: Text(
            ILocalization(_prefs).get("school"),
            style: const TextStyle(
              color: Colors.black54,
            ),
          )),
      Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 16),
          child: FutureBuilder<List<School>?>(
              future: _futureSchool, // function where you call your api
              builder: (BuildContext context,
                  AsyncSnapshot<List<School>?> snapshot) {
                // AsyncSnapshot<Your object type>
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: Text('Please wait its loading...'));
                } else {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    var data = snapshot.data;
                    _selectedSchool = (_selectedSchool == ""
                        ? (data?[0].id)
                        : _selectedSchool)!;
                    _selectedObjSchool = data!
                        .where((element) => element.id == _selectedSchool)
                        .first;
                    return DropdownButtonFormField<String>(
                      value: _selectedSchool,
                      items: data
                          .map((e) => DropdownMenuItem(
                                value: e.id,
                                child: Text(e.name),
                              ))
                          .toList(),
                      onChanged: (value) {
                        _selectedObjSchool =
                            data!.where((element) => element.id == value).first;
                        if (_selectedSchool != value) {
                          setState(() {
                            _selectedSchool = value!;
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Select an item',
                      ),
                    );
                  }
                }
              })),
    ];
  }

  loadBody() {
    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "Teachers",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    widget.teacher.id == "" ? "Add" : "Edit",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
                    child: PhotoUpload(
                        image: _profileImage,
                        uploadButtonTitle: "Upload Photo",
                        updateProfile: (p0) {
                          p0?.readAsBytes().then((value) => {
                                setState(() {
                                  _profileImage = value;
                                  debugPrint(base64Encode(_profileImage));
                                  debugPrint(base64Encode(value));
                                }),
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Image Updated Successfully"),
                                ))
                              });
                        })),
                Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...loadFirstName(),
                        ...loadMiddleName(),
                        ...loadLastName(),
                        ...loadGender(),
                        ...loadEmail(),
                        ...loadMobile(),
                        ...loadSchool(),
                        ...loadStandard(),
                        ...loadDivision(),
                        ...loadRole(),
                        ...loadPassword(),
                        ...loadConfirmPassword(),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 8, bottom: 24),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                isShowConfetti = true;
                                isShowLoading = true;
                              });
                              Future.delayed(const Duration(seconds: 2), () {
                                Teacher teacher = Teacher(
                                    firstname:
                                        _controllerFirstName.text.toString(),
                                    middlename:
                                        _controllerMiddleName.text.toString(),
                                    lastname:
                                        _controllerLastName.text.toString(),
                                    gender: _controllerGender.text,
                                    email: _controllerEmail.text.toString(),
                                    mobileno:
                                        _controllerMobileNo.text.toString(),
                                    standardid: _selectedStandard,
                                    divisionid: _selectedDivision,
                                    photo: _profileImage != Uint8List(0)
                                        ? base64Encode(_profileImage)
                                        : "",
                                    school: _selectedObjSchool,
                                    role: _controllerRole.text,
                                    password: _controllerPassword.text);
                                if (widget.teacher.id == "") {
                                  teacher.id = const Uuid().v4();

                                  apiTeacher
                                      .createTeacher(teacher)
                                      .then((isSuccess) {
                                    setState(() {
                                      isShowLoading = false;
                                    });
                                    if (isSuccess) {
                                      success.fire();
                                      navigateBack();
                                    } else {
                                      error.fire();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text("Submit data failed"),
                                      ));
                                    }
                                  });
                                } else {
                                  teacher.id = widget.teacher.id;
                                  apiTeacher
                                      .updateTeacher(teacher)
                                      .then((isSuccess) {
                                    setState(() {
                                      isShowLoading = false;
                                    });
                                    if (isSuccess) {
                                      success.fire();
                                      navigateBack();
                                    } else {
                                      error.fire();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text("Update data failed"),
                                      ));
                                    }
                                  });
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF77D8E),
                              minimumSize: const Size(double.infinity, 56),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(25),
                                  bottomRight: Radius.circular(25),
                                  bottomLeft: Radius.circular(25),
                                ),
                              ),
                            ),
                            icon: const Icon(
                              CupertinoIcons.arrow_right,
                              color: Color(0xFFFE0037),
                            ),
                            label: const Text("Save"),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
          isShowLoading
              ? CustomPositioned(
                  child: RiveAnimation.asset(
                    '$assetsLocation/RiveAssets/check.riv',
                    fit: BoxFit.cover,
                    onInit: _onCheckRiveInit,
                  ),
                )
              : const SizedBox(),
          isShowConfetti
              ? CustomPositioned(
                  scale: 6,
                  child: RiveAnimation.asset(
                    "$assetsLocation/RiveAssets/confetti.riv",
                    onInit: _onConfettiRiveInit,
                    fit: BoxFit.cover,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  late final SharedPreferences _prefs;
  late final _prefsFuture =
      SharedPreferences.getInstance().then((v) => _prefs = v);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _prefsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return loadBody(); // `_prefs` is ready for use.
          }
          // `_prefs` is not ready yet, show loading bar till then.
          return CircularProgressIndicator();
        },
      ),
    );
  }

  List<Widget> loadFirstName() {
    return [
      const Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 8),
          child: Text(
            "First Name",
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.black54,
            ),
          )),
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 16),
        child: TextFormField(
            controller: _controllerFirstName,
            validator: (value) {
              if (value!.isEmpty) {
                return "";
              }
              return null;
            }),
      ),
    ];
  }

  List<Widget> loadMiddleName() {
    return [
      const Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 8),
          child: Text(
            "Middle Name",
            style: TextStyle(
              color: Colors.black54,
            ),
          )),
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 16),
        child: TextFormField(
          controller: _controllerMiddleName,
          validator: (value) {
            if (value!.isEmpty) {
              return "";
            }
            return null;
          },
        ),
      ),
    ];
  }

  List<Widget> loadLastName() {
    return [
      const Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 8),
          child: Text(
            "Last Name",
            style: TextStyle(
              color: Colors.black54,
            ),
          )),
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 16),
        child: TextFormField(
          controller: _controllerLastName,
          validator: (value) {
            if (value!.isEmpty) {
              return "";
            }
            return null;
          },
        ),
      ),
    ];
  }

  List<Widget> loadPassword() {
    return [
      const Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 8),
          child: Text(
            "Password",
            style: TextStyle(
              color: Colors.black54,
            ),
          )),
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 16),
        child: TextFormField(
          controller: _controllerPassword,
          validator: (value) {
            if (value!.isEmpty) {
              return "";
            }
            return null;
          },
        ),
      ),
    ];
  }

  List<Widget> loadConfirmPassword() {
    return [
      const Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 8),
          child: Text(
            "Confirm Password",
            style: TextStyle(
              color: Colors.black54,
            ),
          )),
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 16),
        child: TextFormField(
          controller: _controllerConfirmPassword,
          validator: (value) {
            if (value!.isEmpty || value != _controllerPassword.text) {
              return ILocalization(_prefs).get(
                  "Confirm_Password_should_not_be_empty_and_should_be_match_with_Password");
            }
            return null;
          },
        ),
      ),
    ];
  }

  List<Widget> loadMobile() {
    return [
      const Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 8),
          child: Text(
            "Mobile",
            style: TextStyle(
              color: Colors.black54,
            ),
          )),
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 16),
        child: TextFormField(
          keyboardType: TextInputType.phone,
          autovalidateMode: AutovalidateMode.always,
          controller: _controllerMobileNo,
          validator: validateMobile,
        ),
      ),
    ];
  }

  List<Widget> loadEmail() {
    return [
      const Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 8),
          child: Text(
            "Email",
            style: TextStyle(
              color: Colors.black54,
            ),
          )),
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 16),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          autovalidateMode: AutovalidateMode.always,
          controller: _controllerEmail,
          validator: validateEmail,
        ),
      ),
    ];
  }

  ApiStandard standard = ApiStandard();
  late Future<List<Standard>?> _futureStandard;
  String _selectedStandard = "";

  List<Widget> loadStandard() {
    return [
      const Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 8),
          child: Text(
            "Standard",
            style: TextStyle(
              color: Colors.black54,
            ),
          )),
      Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 16),
          child: FutureBuilder<List<Standard>?>(
              future: _futureStandard, // function where you call your api
              builder: (BuildContext context,
                  AsyncSnapshot<List<Standard>?> snapshot) {
                // AsyncSnapshot<Your object type>
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: Text('Please wait its loading...'));
                } else {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    var data = snapshot.data;
                    _selectedStandard =
                        (_selectedStandard == "" && data!.isNotEmpty
                            ? (data?[0].id)
                            : _selectedStandard)!;

                    return DropdownButtonFormField<String>(
                      value: _selectedStandard,
                      items: data
                          ?.map((e) => DropdownMenuItem(
                                value: e.id,
                                child: Text(e.name),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (_selectedStandard != value) {
                          setState(() {
                            _selectedStandard = value!;
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Select an item',
                      ),
                    );
                  }
                }
              })),
    ];
  }

  ApiDivision division = ApiDivision();
  late Future<List<Division>?> _futureDivision;
  String _selectedDivision = "";

  List<Widget> loadDivision() {
    return [
      const Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 8),
          child: Text(
            "Division",
            style: TextStyle(
              color: Colors.black54,
            ),
          )),
      Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 16),
          child: FutureBuilder<List<Division>?>(
              future: _futureDivision, // function where you call your api
              builder: (BuildContext context,
                  AsyncSnapshot<List<Division>?> snapshot) {
                // AsyncSnapshot<Your object type>
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: Text('Please wait its loading...'));
                } else {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    var data = snapshot.data;
                    _selectedDivision =
                        (_selectedDivision == "" && data!.isNotEmpty
                            ? (data?[0].id)
                            : _selectedDivision)!;

                    return DropdownButtonFormField<String>(
                      value: _selectedDivision,
                      items: data
                          ?.map((e) => DropdownMenuItem(
                                value: e.id,
                                child: Text(e.name),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (_selectedDivision != value) {
                          setState(() {
                            _selectedDivision = value!;
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Select an item',
                      ),
                    );
                  }
                }
              })),
    ];
  }

  List<Widget> loadGender() {
    return [
      const Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 8),
          child: Text(
            "Gender",
            style: TextStyle(
              color: Colors.black54,
            ),
          )),
      Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 16),
          child: DropdownButtonFormField<String>(
            value: _controllerGender.text == "" ? "M" : _controllerGender.text,
            items: const [
              DropdownMenuItem(
                value: "M",
                child: Text("Male"),
              ),
              DropdownMenuItem(
                value: "F",
                child: Text("Female"),
              ),
              DropdownMenuItem(
                value: "T",
                child: Text("Trans"),
              )
            ],
            onChanged: (value) {
              if (_controllerGender.text != value) {
                setState(() {
                  _controllerGender.text = value!;
                });
              }
            },
            decoration: const InputDecoration(
              labelText: 'Select an item',
            ),
          )),
    ];
  }

  List<Widget> loadRole() {
    if (getCurrentRole() != "A") {
      _controllerRole.text = "T";
      return [];
    }
    return [
      const Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 8),
          child: Text(
            "Role",
            style: TextStyle(
              color: Colors.black54,
            ),
          )),
      Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 16),
          child: DropdownButtonFormField<String>(
            value: _controllerRole.text == "" ? "T" : _controllerRole.text,
            items: const [
              DropdownMenuItem(
                value: "T",
                child: Text("Teacher"),
              ),
              DropdownMenuItem(
                value: "H",
                child: Text("Principle"),
              )
            ],
            onChanged: (value) {
              if (_controllerRole.text != value) {
                setState(() {
                  _controllerRole.text = value!;
                });
              }
            },
            decoration: const InputDecoration(
              labelText: 'Select an item',
            ),
          )),
    ];
  }

  navigateBack() {
    Navigator.pop(context, true);
  } // snapshot.data  :- get your object which is pass from your downloadData() function
}
