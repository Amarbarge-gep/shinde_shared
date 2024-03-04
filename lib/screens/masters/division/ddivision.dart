import 'package:com_barge_idigital/model/division.dart';
import 'package:com_barge_idigital/model/localization.dart';
import 'package:com_barge_idigital/model/profile.dart';
import 'package:com_barge_idigital/model/school.dart';
import 'package:com_barge_idigital/screens/common/customposition.dart';
import 'package:com_barge_idigital/services/api/division.dart';
import 'package:com_barge_idigital/services/api/school.dart';
import 'package:com_barge_idigital/services/common/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DivisionForm extends StatefulWidget {
  final Division division;
  const DivisionForm({super.key, required this.division});

  @override
  State<DivisionForm> createState() => _DivisionFormState();
}

class _DivisionFormState extends State<DivisionForm> {
  ApiDivision apiDivision = ApiDivision();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerDesc = TextEditingController();

  late School _selectedObjSchool;

  ApiSchool apiSchool = ApiSchool();
  late final Future<List<School>?> _futureSchool = apiSchool.getSchools();
  String _selectedSchool = "";

  late final SharedPreferences _prefs;
  late final _prefsFuture =
      SharedPreferences.getInstance().then((v) => _prefs = v);

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
    _controllerName.text = widget.division.name;
    _controllerDesc.text = widget.division.description;
    _selectedSchool = widget.division.school.id;
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
                  return Center(
                      child: Text(
                          '${ILocalization(_prefs).get("please_wait_its_loading")}...'));
                } else {
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                            '${ILocalization(_prefs).get("Error")}: ${snapshot.error}'));
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
                      decoration: InputDecoration(
                        labelText: ILocalization(_prefs).get('select_an_item'),
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
                    ILocalization(_prefs).get("divisions"),
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
                    widget.division.id == ""
                        ? ILocalization(_prefs).get("add")
                        : ILocalization(_prefs).get("edit"),
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 8),
                            child: Text(
                              ILocalization(_prefs).get("name"),
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Colors.black54,
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 8, bottom: 16),
                          child: TextFormField(
                              controller: _controllerName,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "";
                                }
                                return null;
                              }),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 8),
                            child: Text(
                              ILocalization(_prefs).get("description"),
                              style: const TextStyle(
                                color: Colors.black54,
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 8, bottom: 16),
                          child: TextFormField(
                            controller: _controllerDesc,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "";
                              }
                              return null;
                            },
                          ),
                        ),
                        ...loadSchool(),
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
                                String name = _controllerName.text.toString();
                                String desc = _controllerDesc.text.toString();
                                Division division = Division(
                                    name: name,
                                    description: desc,
                                    school: _selectedObjSchool);
                                if (widget.division.id == "") {
                                  apiDivision
                                      .createDivision(division)
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
                                          .showSnackBar(SnackBar(
                                        content: Text(ILocalization(_prefs)
                                            .get("submit_data_failed")),
                                      ));
                                    }
                                  });
                                } else {
                                  division.id = widget.division.id;
                                  apiDivision
                                      .updateDivision(division)
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
                                          .showSnackBar(SnackBar(
                                        content: Text(ILocalization(_prefs)
                                            .get("update_data_failed")),
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

  navigateBack() {
    Navigator.pop(context, true);
  } // snapshot.data  :- get your object which is pass from your downloadData() function
}
