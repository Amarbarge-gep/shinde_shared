import 'package:com_barge_idigital/model/localization.dart';
import 'package:com_barge_idigital/model/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/menu.dart';

class SideMenu extends StatefulWidget {
  final Menu menu;
  final VoidCallback press;
  final ValueChanged<Artboard> riveOnInit;
  final Menu? selectedMenu;

  const SideMenu(
      {super.key,
      required this.menu,
      required this.press,
      required this.riveOnInit,
      required this.selectedMenu});

  @override
  State<SideMenu> createState() => _SideMenuFormState();
}

class _SideMenuFormState extends State<SideMenu> {
  @override
  void initState() {
    super.initState();
  }

  late String userType = "S";

  late final SharedPreferences _prefs;
  late final _prefsFuture =
      SharedPreferences.getInstance().then((v) => _prefs = v);

  loadBody() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 24),
          child: Divider(color: Colors.white24, height: 1),
        ),
        Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              width: widget.selectedMenu == widget.menu ? 288 : 0,
              height: 56,
              left: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF6792FF),
                  //borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            ListTile(
              onTap: widget.press,
              leading: SizedBox(
                height: 36,
                width: 36,
                child: SvgPicture.asset(
                    "assets/icons/${widget.menu.iconName}.svg",
                    height: 36,
                    width: 36),
              ),
              title: Text(
                ILocalization(_prefs).get(widget.menu.title),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _prefsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return loadBody(); // `_prefs` is ready for use.
        }
        // `_prefs` is not ready yet, show loading bar till then.
        return CircularProgressIndicator();
      },
    );
  }
}
