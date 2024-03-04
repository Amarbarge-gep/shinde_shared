import 'package:com_barge_idigital/model/school.dart';
import 'package:com_barge_idigital/screens/entryPoint/entry_point.dart';
import 'package:com_barge_idigital/services/api/auth.dart';
import 'package:com_barge_idigital/services/api/school.dart';
import 'package:com_barge_idigital/services/common/meths.dart';
import 'package:com_barge_idigital/services/common/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rive/rive.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerUserName = TextEditingController();
  final TextEditingController _controllerPass = TextEditingController();
  bool isShowLoading = false;
  bool isShowConfetti = false;
  late SMITrigger error;
  late SMITrigger success;
  late SMITrigger reset;

  late SMITrigger confetti;

  void _onCheckRiveInit(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');

    artboard.addController(controller!);
    error = controller.findInput<bool>('Error') as SMITrigger;
    success = controller.findInput<bool>('Check') as SMITrigger;
    reset = controller.findInput<bool>('Reset') as SMITrigger;
  }

  void _onConfettiRiveInit(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);

    confetti = controller.findInput<bool>("Trigger explosion") as SMITrigger;
  }

  void register(BuildContext context, Map<String, String> mapObj) {
    // confetti.fire();
    setState(() {
      isShowConfetti = true;
      isShowLoading = true;
    });

    AuthApi auth = AuthApi();
    auth.register(mapObj).then((value) => {
          Future.delayed(
            const Duration(seconds: 1),
            () {
              if (value) {
                success.fire();
                setState(() {
                  isShowLoading = false;
                });
                confetti.fire();
                // Navigate & hide confetti
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const EntryPoint(inRouteName: "setting", data: null),
                  ),
                );
              } else {
                error.fire();
                Future.delayed(
                  const Duration(seconds: 2),
                  () {
                    setState(() {
                      isShowLoading = false;
                    });
                    reset.fire();
                  },
                );
              }
            },
          )
        });
  }

  ApiSchool school = ApiSchool();
  School _selectedItem = School(name: "", description: "", medium: 1);
  late Future<List<School>?> _future;
  @override
  void initState() {
    super.initState();
    _future = school.getSchools();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "School",
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  child: FutureBuilder<List<School>?>(
                      future: _future, // function where you call your api
                      builder: (BuildContext context,
                          AsyncSnapshot<List<School>?> snapshot) {
                        // AsyncSnapshot<Your object type>
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: Text('Please wait its loading...'));
                        } else {
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else {
                            var data = snapshot.data;
                            _selectedItem = (_selectedItem.name == ""
                                ? (data?[0])
                                : _selectedItem)!;

                            return DropdownButtonFormField<String>(
                              value: _selectedItem.id,
                              items: data
                                  ?.map((e) => DropdownMenuItem(
                                        value: e.id,
                                        child: Text(e.name),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                if (_selectedItem != value) {
                                  setState(() {
                                    _selectedItem = data!
                                        .where((element) => element.id == value)
                                        .first;
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
              const Text(
                "Mobile No.",
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: TextFormField(
                  controller: _controllerUserName,
                  autovalidateMode: AutovalidateMode.always,
                  keyboardType: TextInputType.number,
                  validator: validateMobile,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child:
                          SvgPicture.asset("$assetsLocation/icons/email.svg"),
                    ),
                  ),
                ),
              ),
              const Text(
                "Password",
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: TextFormField(
                  controller: _controllerPass,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SvgPicture.asset(
                          "$assetsLocation/icons/password.svg"),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 24),
                child: ElevatedButton.icon(
                  onPressed: () {
                    register(context, {
                      "school": _selectedItem.toString(),
                      "username": _controllerUserName.text,
                      "password": _controllerPass.text,
                      "firstname": "",
                      "middlename": "",
                      "lastname": "",
                      "role": "S"
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
                  label: const Text("Register"),
                ),
              ),
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
    );
  }
}

class CustomPositioned extends StatelessWidget {
  const CustomPositioned({super.key, this.scale = 1, required this.child});

  final double scale;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          const Spacer(),
          SizedBox(
            height: 100,
            width: 100,
            child: Transform.scale(
              scale: scale,
              child: child,
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
