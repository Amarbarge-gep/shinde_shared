import 'package:com_barge_idigital/screens/onboding/components/register_form.dart';
import 'package:com_barge_idigital/screens/onboding/components/sign_in_form.dart';
import 'package:com_barge_idigital/services/common/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignInStateForm extends StatefulWidget {
  const SignInStateForm({Key? key}) : super(key: key);

  @override
  State<SignInStateForm> createState() => _SignInStateFormState();
}

class _SignInStateFormState extends State<SignInStateForm> {
  bool showRegister = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(visible: showRegister, child: getRegisterForm(context)),
        Visibility(visible: !showRegister, child: getLogInForm(context))
      ],
    );
  }

  getRegisterForm(BuildContext context) {
    return const Column(
      children: [
        Text(
          "Register",
          style: TextStyle(
            fontSize: 34,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            "Access to 240+ hours of content. Learn design and code, by building real apps with Flutter and Swift.",
            textAlign: TextAlign.center,
          ),
        ),
        RegisterForm(),
      ],
    );
  }

  getLogInForm(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Sign in",
          style: TextStyle(
            fontSize: 34,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            "Access to 240+ hours of content. Learn design and code, by building real apps with Flutter and Swift.",
            textAlign: TextAlign.center,
          ),
        ),
        SignInForm(swithForm: (bool value) => {}),
        const Row(
          children: [
            Expanded(
              child: Divider(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "OR",
                style: TextStyle(
                  color: Colors.black26,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Text(
            "Sign up with Email, Apple or Google",
            style: TextStyle(color: Colors.black54),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  showRegister = true;
                });
              },
              padding: EdgeInsets.zero,
              icon: SvgPicture.asset(
                "$assetsLocation/icons/email_box.svg",
                height: 64,
                width: 64,
              ),
            ),
            IconButton(
              onPressed: () {},
              padding: EdgeInsets.zero,
              icon: SvgPicture.asset(
                "$assetsLocation/icons/apple_box.svg",
                height: 64,
                width: 64,
              ),
            ),
            IconButton(
              onPressed: () {},
              padding: EdgeInsets.zero,
              icon: SvgPicture.asset(
                "$assetsLocation/icons/google_box.svg",
                height: 64,
                width: 64,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
