import 'dart:convert';
import 'dart:typed_data';

import 'package:com_barge_idigital/model/localization.dart';
import 'package:com_barge_idigital/model/school.dart';
import 'package:com_barge_idigital/screens/common/customposition.dart';
import 'package:com_barge_idigital/screens/settings/photoupload.dart';
import 'package:com_barge_idigital/services/api/school.dart';
import 'package:com_barge_idigital/services/common/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchoolForm extends StatefulWidget {
  final School school;
  const SchoolForm({super.key, required this.school});

  @override
  State<SchoolForm> createState() => _SchoolFormState();
}

class _SchoolFormState extends State<SchoolForm> {
  ApiSchool apiSchool = ApiSchool();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerDesc = TextEditingController();
  final TextEditingController _controllerMedium = TextEditingController();
  late Uint8List _profileLogo;
  late Uint8List _profileSign;

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
    _controllerName.text = widget.school.name;
    _controllerDesc.text = widget.school.description;
    _profileLogo = widget.school.logo != null
        ? base64Decode(widget.school.logo.toString())
        : Uint8List(0);
    _profileSign = widget.school.sign != null
        ? base64Decode(widget.school.sign.toString())
        : Uint8List(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _prefsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
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
                    "Schools",
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
                    widget.school.id == "" ? "Add" : "Edit",
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
                            child: PhotoUpload(
                                image: _profileLogo,
                                uploadButtonTitle: "Upload Logo",
                                updateProfile: (p0) {
                                  p0?.readAsBytes().then((value) => {
                                        setState(() {
                                          _profileLogo = value;
                                          debugPrint(
                                              base64Encode(_profileLogo));
                                          debugPrint(base64Encode(value));
                                        }),
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(ILocalization(_prefs)
                                              .get(
                                                  "image_updated_successfully")),
                                        ))
                                      });
                                })),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 8),
                            child: PhotoUpload(
                                image: _profileSign,
                                uploadButtonTitle: "Upload Sign",
                                updateProfile: (p0) {
                                  p0?.readAsBytes().then((value) => {
                                        setState(() {
                                          _profileSign = value;
                                          debugPrint(
                                              base64Encode(_profileSign));
                                          debugPrint(base64Encode(value));
                                        }),
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(ILocalization(_prefs)
                                              .get(
                                                  "image_updated_successfully")),
                                        ))
                                      });
                                })),
                        const Padding(
                            padding:
                                EdgeInsets.only(left: 20, right: 20, top: 8),
                            child: Text(
                              "Name",
                              textAlign: TextAlign.left,
                              style: TextStyle(
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
                        const Padding(
                            padding:
                                EdgeInsets.only(left: 20, right: 20, top: 8),
                            child: Text(
                              "Description",
                              style: TextStyle(
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
                        ...loadMedium(),
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
                                int medium = int.parse(_controllerMedium.text);
                                School school = School(
                                    name: name,
                                    description: desc,
                                    medium: medium,
                                    logo: _profileLogo != Uint8List(0)
                                        ? base64Encode(_profileLogo)
                                        : "",
                                    sign: _profileSign != Uint8List(0)
                                        ? base64Encode(_profileSign)
                                        : "");
                                if (widget.school.id == "") {
                                  apiSchool
                                      .createSchool(school)
                                      .then((isSuccess) {
                                    setState(() {
                                      isShowLoading = false;
                                    });
                                    if (isSuccess) {
                                      success.fire();
                                      navigateBack(context);
                                    } else {
                                      error.fire();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text("Submit data failed"),
                                      ));
                                    }
                                  });
                                } else {
                                  school.id = widget.school.id;
                                  apiSchool
                                      .updateSchool(school)
                                      .then((isSuccess) {
                                    setState(() {
                                      isShowLoading = false;
                                    });
                                    if (isSuccess) {
                                      success.fire();
                                      navigateBack(context);
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

  List<Widget> loadMedium() {
    return [
      Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
          child: Text(
            ILocalization(_prefs).get("medium"),
            style: const TextStyle(
              color: Colors.black54,
            ),
          )),
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 16),
        child: DropdownButtonFormField<String>(
          value: _controllerMedium.text == "" ? "1" : _controllerMedium.text,
          items: [
            DropdownMenuItem(
                value: "1", child: Text(ILocalization(_prefs).get("english"))),
            DropdownMenuItem(
                value: "2", child: Text(ILocalization(_prefs).get("marathi"))),
          ],
          onChanged: (value) {
            if (_controllerMedium.text != value) {
              setState(() {
                _controllerMedium.text = value!;
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

  navigateBack(context) {
    Navigator.pop(context, true);
  } // snapshot.data  :- get your object which is pass from your downloadData() function
}
