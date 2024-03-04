import 'dart:convert';

import 'package:com_barge_idigital/model/profile.dart';
import 'package:com_barge_idigital/screens/common/customposition.dart';
import 'package:com_barge_idigital/screens/settings/components/profile.dart';
import 'package:com_barge_idigital/services/api/profile.dart';
import 'package:com_barge_idigital/services/common/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:image/image.dart' as img;

class ProfileForm extends StatefulWidget {
  final Profile profile;
  const ProfileForm({super.key, required this.profile});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  ApiProfile apiProfile = ApiProfile();

  late Uint8List _profileImage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _controllerFirstName = TextEditingController();
  final TextEditingController _controllerMiddleName = TextEditingController();
  final TextEditingController _controllerLastName = TextEditingController();
  final TextEditingController _controllerRole = TextEditingController();

  late SMITrigger error;
  late SMITrigger success;
  late SMITrigger confetti;

  bool isShowLoading = false;
  bool isShowConfetti = false;

  String _selectedRole = "";

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
    _controllerFirstName.text = widget.profile.firstname;
    _controllerMiddleName.text = widget.profile.middlename;
    _controllerLastName.text = widget.profile.lastname;
    _profileImage = widget.profile.photo != null
        ? base64Decode(widget.profile.photo.toString())
        : Uint8List(0);
    _controllerRole.text = widget.profile.role;
    // var photo = img.decodeImage(_profileImage.buffer.asUint8List());
    // int pixel32 = photo!.getPixelSafe(10, 10) as int;
    // int hex = abgrToArgb(pixel32);
    // debugPrint("Value of Hex: $hex");
    super.initState();
  }

  int abgrToArgb(int argbColor) {
    int r = (argbColor >> 16) & 0xFF;
    int b = argbColor & 0xFF;
    return (argbColor & 0xFF00FF00) | (b << 16) | r;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                      "Profiles",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(
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
                      widget.profile.id == "" ? "Add" : "Edit",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(
                              color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 8),
                      child: ProfileWidget(
                          image: _profileImage,
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
                          const Padding(
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 8),
                              child: Text(
                                "First Name",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 8, bottom: 16),
                            child: TextFormField(
                                controller: _controllerFirstName,
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
                                "Middle Name",
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 8, bottom: 16),
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
                          const Padding(
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 8),
                              child: Text(
                                "Last Name",
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 8, bottom: 16),
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
                          const Padding(
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 8),
                              child: Text(
                                "Role",
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 8, bottom: 16),
                            child: DropdownButtonFormField(
                              items: const [
                                DropdownMenuItem(
                                    value: "T", child: Text("Teacher")),
                                DropdownMenuItem(
                                    value: "H", child: Text("Head")),
                                DropdownMenuItem(
                                    value: "S", child: Text("Student"))
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedRole = value!;
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "T";
                                }
                                return null;
                              },
                            ),
                          ),
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
                                  Profile profile = Profile(
                                      firstname:
                                          _controllerFirstName.text.toString(),
                                      middlename:
                                          _controllerMiddleName.text.toString(),
                                      lastname:
                                          _controllerLastName.text.toString(),
                                      role: _selectedRole,
                                      school: widget.profile.school,
                                      username: widget.profile.username,
                                      password: widget.profile.password,
                                      photo: _profileImage != Uint8List(0)
                                          ? base64Encode(_profileImage)
                                          : "");
                                  if (widget.profile.id == "") {
                                    apiProfile
                                        .createProfile(profile)
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
                                    profile.id = widget.profile.id;
                                    apiProfile
                                        .updateProfile(profile)
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
      ),
    );
  }

  navigateBack() {
    Navigator.pop(context, true);
  } // snapshot.data  :- get your object which is pass from your downloadData() function
}
