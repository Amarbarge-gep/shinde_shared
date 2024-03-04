import 'dart:convert';
import 'package:com_barge_idigital/model/division.dart';
import 'package:com_barge_idigital/model/localization.dart';
import 'package:com_barge_idigital/model/profile.dart';
import 'package:com_barge_idigital/model/school.dart';
import 'package:com_barge_idigital/model/standard.dart';
import 'package:com_barge_idigital/model/student.dart';
import 'package:com_barge_idigital/screens/common/customposition.dart';
import 'package:com_barge_idigital/screens/entryPoint/entry_point.dart';
import 'package:com_barge_idigital/screens/settings/components/profile.dart';
import 'package:com_barge_idigital/screens/settings/photoupload.dart';
import 'package:com_barge_idigital/services/api/division.dart';
import 'package:com_barge_idigital/services/api/school.dart';
import 'package:com_barge_idigital/services/api/standard.dart';
import 'package:com_barge_idigital/services/api/student.dart';
import 'package:com_barge_idigital/services/common/meths.dart';
import 'package:com_barge_idigital/services/common/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rive/rive.dart';
import 'package:image/image.dart' as img;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class StudentForm extends StatefulWidget {
  final Student student;
  const StudentForm({super.key, required this.student});

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  ApiStudent apiStudent = ApiStudent();

  ApiStandard standard = ApiStandard();
  late Future<List<Standard>?> _futureStandard;
  String _selectedStandard = "";

  ApiDivision division = ApiDivision();
  late Future<List<Division>?> _futureDivision;
  String _selectedDivision = "";

  ApiSchool apiSchool = ApiSchool();
  late Future<List<School>?> _futureSchool;
  String _selectedSchool = "";

  late Uint8List _profileImage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _controllerFirstName = TextEditingController();
  final TextEditingController _controllerMiddleName = TextEditingController();
  final TextEditingController _controllerLastName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerMobileNo = TextEditingController();
  final TextEditingController _controllerAadharNo = TextEditingController();
  final TextEditingController _controllerGrNo = TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();
  final TextEditingController _controllerUDISE = TextEditingController();
  final TextEditingController _controllerBloodGroup = TextEditingController();
  final TextEditingController _controllerHouse = TextEditingController();
  final TextEditingController _controllerRollNo = TextEditingController();
  final TextEditingController _controllerDOB = TextEditingController();

  late School _selectedObjSchool;
  late Standard _selectedObjStandard;
  late Division _selectedObjDivision;

  late final SharedPreferences _prefs;
  late final _prefsFuture =
      SharedPreferences.getInstance().then((v) => _prefs = v);

  String currentUserRole = "";

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
    _controllerFirstName.text = widget.student.firstname;
    _controllerMiddleName.text = widget.student.middlename;
    _controllerLastName.text = widget.student.lastname;
    _controllerEmail.text = widget.student.email;
    _controllerMobileNo.text = widget.student.mobileno;
    _selectedDivision = widget.student.divisionid;
    _selectedStandard = widget.student.standardid;
    _controllerAadharNo.text = widget.student.aadharno;
    _controllerGrNo.text = widget.student.grno;
    _profileImage = widget.student.photo != null
        ? base64Decode(widget.student.photo.toString())
        : Uint8List(0);
    _controllerAddress.text = widget.student.address;
    _controllerUDISE.text = widget.student.udise;
    _controllerBloodGroup.text = widget.student.bloodgroup;
    _controllerHouse.text = widget.student.house;
    _controllerRollNo.text = widget.student.rollno;
    _controllerDOB.text = DateFormat('dd/MM/yyyy').format(widget.student.dob);
    _futureStandard = standard.getStandards();
    _futureDivision = division.getDivisions();
    _futureSchool = apiSchool.getSchools();
    // if (!_profileImage.isEmpty && _profileImage.length > 0) {
    //   var photo = img.decodeImage(_profileImage.buffer.asUint8List());
    //   int pixel32 = photo!.getPixelSafe(10, 10).hashCode as int;
    //   int hex = abgrToArgb(pixel32);
    //   debugPrint("Value of Hex: $hex");
    // }
    super.initState();
  }

  int abgrToArgb(int argbColor) {
    print("abgrToArgb");
    int r = (argbColor >> 16) & 0xFF;
    int b = argbColor & 0xFF;
    return (argbColor & 0xFF00FF00) | (b << 16) | r;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _prefsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (currentUserRole == "") {
              currentUserRole = getCurrentRole();
            }
            return loadForm(); // `_prefs` is ready for use.
          }

          // `_prefs` is not ready yet, show loading bar till then.
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  loadForm() {
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
                    ILocalization(_prefs).get("students"),
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
                    widget.student.id == ""
                        ? ILocalization(_prefs).get("add")
                        : ILocalization(_prefs).get("edit"),
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
                                    .showSnackBar(SnackBar(
                                  content: Text(ILocalization(_prefs)
                                      .get("image_updated_successfully")),
                                ))
                              });
                        })),
                Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 8),
                            child: Text(
                              ILocalization(_prefs).get("first_name"),
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Colors.black54,
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 8, bottom: 16),
                          child: TextFormField(
                              controller: _controllerFirstName,
                              validator: (value) {
                                if (value!.isEmpty && currentUserRole == "S") {
                                  return ILocalization(_prefs)
                                      .get("value_can_not_be_empty");
                                }
                                return null;
                              }),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 8),
                            child: Text(
                              ILocalization(_prefs).get("middle_name"),
                              style: const TextStyle(
                                color: Colors.black54,
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 8, bottom: 16),
                          child: TextFormField(
                            controller: _controllerMiddleName,
                            validator: (value) {
                              if (value!.isEmpty && currentUserRole == "S") {
                                return ILocalization(_prefs)
                                    .get("value_can_not_be_empty");
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 8),
                            child: Text(
                              ILocalization(_prefs).get("last_name"),
                              style: const TextStyle(
                                color: Colors.black54,
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 8, bottom: 16),
                          child: TextFormField(
                            controller: _controllerLastName,
                            validator: (value) {
                              if (value!.isEmpty && currentUserRole == "S") {
                                return ILocalization(_prefs)
                                    .get("value_can_not_be_empty");
                              }
                              return null;
                            },
                          ),
                        ),
                        //...loadEmail(),
                        ...loadMobile(),
                        ...loadAadharNo(),
                        ...loadGrNo(),
                        ...loadSchool(),
                        ...loadStandard(),
                        ...loadDivision(),
                        ...loadAddress(),
                        ...loadDob(),
                        ...loadBloodGroup(),
                        ...loadHouse(),
                        ...loadRollNo(),
                        ...loadUdise(),
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
                                if (!_formKey.currentState!.validate()) {
                                  error.fire();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Invalid Form Details"),
                                  ));
                                  Future.delayed(const Duration(seconds: 2),
                                      () {
                                    setState(() {
                                      isShowConfetti = false;
                                      isShowLoading = false;
                                    });
                                  });
                                  return;
                                }
                                Student student = Student(
                                    id: widget.student.id,
                                    qrid: "",
                                    firstname:
                                        _controllerFirstName.text.toString(),
                                    middlename:
                                        _controllerMiddleName.text.toString(),
                                    lastname:
                                        _controllerLastName.text.toString(),
                                    email: _controllerEmail.text.toString(),
                                    mobileno:
                                        _controllerMobileNo.text.toString(),
                                    aadharno:
                                        _controllerAadharNo.text.toString(),
                                    grno: _controllerGrNo.text.toString(),
                                    standardid: _selectedStandard,
                                    divisionid: _selectedDivision,
                                    photo: _profileImage != Uint8List(0)
                                        ? base64Encode(_profileImage)
                                        : "",
                                    address: _controllerAddress.text.toString(),
                                    bloodgroup:
                                        _controllerBloodGroup.text.toString(),
                                    house: _controllerHouse.text.toString(),
                                    rollno: _controllerRollNo.text.toString(),
                                    udise: _controllerUDISE.text.toString(),
                                    dob: DateFormat("dd/MM/yyyy")
                                        .parse(_controllerDOB.text.toString()),
                                    school: _selectedObjSchool,
                                    division: _selectedObjDivision,
                                    standard: _selectedObjStandard);
                                if (widget.student.id == "") {
                                  student.id = const Uuid().v4();
                                  apiStudent
                                      .createStudent(student)
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
                                  student.id = widget.student.id;
                                  student.qrid = widget.student.qrid;
                                  apiStudent
                                      .updateStudent(student)
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
                            label: Text(ILocalization(_prefs).get("save")),
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

  navigateBack() {
    Navigator.pop(context, true);
  }

  List<Widget> loadAddress() {
    return [
      Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
          child: Text(
            ILocalization(_prefs).get("address"),
            style: const TextStyle(
              color: Colors.black54,
            ),
          )),
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 16),
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: 4,
          controller: _controllerAddress,
          validator: (value) {
            if (value!.isEmpty && currentUserRole == "S") {
              return ILocalization(_prefs).get("value_can_not_be_empty");
            }
            return null;
          },
        ),
      ),
    ];
  }

  List<Widget> loadBloodGroup() {
    return [
      Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
          child: Text(
            ILocalization(_prefs).get("blood_group"),
            style: const TextStyle(
              color: Colors.black54,
            ),
          )),
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 16),
        child: DropdownButtonFormField<String>(
          value: _controllerBloodGroup.text == ""
              ? "A+"
              : _controllerBloodGroup.text,
          items: [
            DropdownMenuItem(
                value: "A+", child: Text(ILocalization(_prefs).get("A+"))),
            DropdownMenuItem(
                value: "A-", child: Text(ILocalization(_prefs).get("A-"))),
            DropdownMenuItem(
                value: "AB+", child: Text(ILocalization(_prefs).get("AB+"))),
            DropdownMenuItem(
                value: "AB-", child: Text(ILocalization(_prefs).get("AB-"))),
            DropdownMenuItem(
                value: "B+", child: Text(ILocalization(_prefs).get("B+"))),
            DropdownMenuItem(
                value: "O+", child: Text(ILocalization(_prefs).get("O+"))),
            DropdownMenuItem(
                value: "O-", child: Text(ILocalization(_prefs).get("O-")))
          ],
          onChanged: (value) {
            if (_controllerBloodGroup.text != value) {
              setState(() {
                _controllerBloodGroup.text = value!;
              });
            }
          },
          decoration: InputDecoration(
            labelText: ILocalization(_prefs).get("select_an_item"),
          ),
        ),
      ),
    ];
  }

  List<Widget> loadHouse() {
    return [
      const Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 8),
          child: Text(
            "House",
            style: TextStyle(
              color: Colors.black54,
            ),
          )),
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 16),
        child: TextFormField(
          controller: _controllerHouse,
        ),
      ),
    ];
  }

  List<Widget> loadRollNo() {
    return [
      Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
          child: Text(
            ILocalization(_prefs).get("rollno"),
            style: const TextStyle(
              color: Colors.black54,
            ),
          )),
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 16),
        child: TextFormField(
          controller: _controllerRollNo,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) {
              return ILocalization(_prefs).get("value_can_not_be_empty");
            }
            return null;
          },
        ),
      ),
    ];
  }

  List<Widget> loadUdise() {
    return [
      const Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 8),
          child: Text(
            "UDISE",
            style: TextStyle(
              color: Colors.black54,
            ),
          )),
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 16),
        child: TextFormField(
          keyboardType: TextInputType.number,
          controller: _controllerUDISE,
          maxLength: 22,
        ),
      ),
    ];
  }

  List<Widget> loadDob() {
    return [
      Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
          child: Text(
            ILocalization(_prefs).get("dob"),
            style: const TextStyle(
              color: Colors.black54,
            ),
          )),
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 16),
        child: TextFormField(
          controller: _controllerDOB,
          decoration: const InputDecoration(
            labelText: "Date of birth",
            hintText: "Ex. Insert your dob",
          ),
          onTap: () async {
            DateTime? date = DateTime(1900);
            FocusScope.of(context).requestFocus(FocusNode());

            date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100));

            _controllerDOB.text = DateFormat('dd/MM/yyyy').format(date!);
          },
        ),
      ),
    ];
  }

  List<Widget> loadAadharNo() {
    return [
      Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
          child: Text(
            ILocalization(_prefs).get("aadharno"),
            style: const TextStyle(
              color: Colors.black54,
            ),
          )),
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 16),
        child: TextFormField(
          controller: _controllerAadharNo,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty && currentUserRole == "S") {
              return ILocalization(_prefs).get("value_can_not_be_empty");
            }
            return null;
          },
        ),
      ),
    ];
  }

  List<Widget> loadGrNo() {
    return [
      Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
          child: Text(
            ILocalization(_prefs).get("grno"),
            style: const TextStyle(
              color: Colors.black54,
            ),
          )),
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 16),
        child: TextFormField(
          controller: _controllerGrNo,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) {
              return ILocalization(_prefs).get("value_can_not_be_empty");
            }
            return null;
          },
        ),
      ),
    ];
  }

  List<Widget> loadMobile() {
    return [
      Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
          child: Text(
            ILocalization(_prefs).get("mobileno"),
            style: const TextStyle(
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
      Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
          child: Text(
            ILocalization(_prefs).get("email"),
            style: const TextStyle(
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

  List<Widget> loadDivision() {
    return [
      Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
          child: Text(
            ILocalization(_prefs).get("division"),
            style: const TextStyle(
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
                    _selectedDivision = (_selectedDivision == ""
                        ? data != null
                            ? (data[0].id)
                            : ""
                        : _selectedDivision);
                    _selectedObjDivision = data != null
                        ? data
                            .where((element) => element.id == _selectedDivision)
                            .first
                        : Division(
                            name: "",
                            description: "",
                            school:
                                School(name: "", description: "", medium: 0));
                    return DropdownButtonFormField<String>(
                      value: _selectedDivision,
                      items: data
                          ?.map((e) => DropdownMenuItem(
                                value: e.id,
                                child: Text(e.name),
                              ))
                          .toList(),
                      onChanged: (value) {
                        _selectedObjDivision =
                            data!.where((element) => element.id == value).first;
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
  } // snapshot.data  :- get your object which is pass from your downloadData() function

  List<Widget> loadStandard() {
    return [
      Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
          child: Text(
            ILocalization(_prefs).get("standard"),
            style: const TextStyle(
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
                    _selectedStandard = (_selectedStandard == ""
                        ? data != null
                            ? (data[0].id)
                            : ""
                        : _selectedStandard);
                    _selectedObjStandard = data != null
                        ? data
                            .where((element) => element.id == _selectedStandard)
                            .first
                        : Standard(
                            name: "",
                            description: "",
                            school:
                                School(name: "", description: "", medium: 1));
                    return DropdownButtonFormField<String>(
                      value: _selectedStandard,
                      items: data
                          ?.map((e) => DropdownMenuItem(
                                value: e.id,
                                child: Text(e.name),
                              ))
                          .toList(),
                      onChanged: (value) {
                        _selectedObjStandard =
                            data!.where((element) => element.id == value).first;
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
  } // snapshot.data  :- get your object which is pass from your downloadData() function
}
