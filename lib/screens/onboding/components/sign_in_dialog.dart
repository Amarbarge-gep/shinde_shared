import 'package:com_barge_idigital/screens/onboding/components/register_form.dart';
import 'package:com_barge_idigital/screens/onboding/components/sign_in_state.dart';
import 'package:com_barge_idigital/services/common/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'sign_in_form.dart';

bool showRegister = false;

void showCustomDialog(BuildContext context, {required ValueChanged onValue}) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Container(
          height: 640,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 30),
                blurRadius: 60,
              ),
              const BoxShadow(
                color: Colors.black45,
                offset: Offset(0, 30),
                blurRadius: 60,
              ),
            ],
          ),
          child: const Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: Stack(
              clipBehavior: Clip.none,
              children: [
                SignInStateForm(),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: -48,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      // if (anim.status == AnimationStatus.reverse) {
      //   tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
      // } else {
      //   tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
      // }

      tween = Tween(begin: const Offset(0, -1), end: Offset.zero);

      return SlideTransition(
        position: tween.animate(
          CurvedAnimation(parent: anim, curve: Curves.easeInOut),
        ),
        // child: FadeTransition(
        //   opacity: anim,
        //   child: child,
        // ),
        child: child,
      );
    },
  ).then(onValue);
}

getRegisterForm(BuildContext context) {
  return Visibility(
      visible: showRegister,
      child: const Column(
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
      ));
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
              showRegister = true;
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
