import 'dart:convert';
import 'dart:typed_data';

import 'package:com_barge_idigital/model/profile.dart';
import 'package:com_barge_idigital/screens/entryPoint/entry_point.dart';
import 'package:com_barge_idigital/services/api/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/menu.dart';
import '../../../utils/rive_utils.dart';
import 'info_card.dart';
import 'side_menu.dart';

class SideBar extends StatefulWidget {
  final String inRouteName;
  const SideBar({super.key, required this.inRouteName});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  late Menu? selectedSideMenu;
  late String userType = "S";

  late final SharedPreferences _prefs;
  late final _prefsFuture =
      SharedPreferences.getInstance().then((v) => _prefs = v);

  @override
  void initState() {
    selectedSideMenu = sidebarMenus.any((element) =>
            element.routeName == widget.inRouteName ||
            element.detailRoute == widget.inRouteName)
        ? sidebarMenus
            .where((element) =>
                element.routeName == widget.inRouteName ||
                element.detailRoute == widget.inRouteName)
            .first
        : null;
    // TODO: implement initState
    super.initState();
  }

  getuserType() {
    String? username = _prefs.getString("username");
    var profileData = _prefs.getString("userProfile");
    if (profileData != null) {
      var profileList = profileFromJson(profileData);
      userType = profileList.role;
    }
  }

  loadBody() {
    return Container(
      width: 288,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF17203A),
        borderRadius: BorderRadius.all(
          Radius.circular(0),
        ),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getUserInfo(),
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
              child: Text(
                "Browse".toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.white70),
              ),
            ),
            ...sidebarMenus
                .where((element) => element.applicableUsers.contains(userType))
                .map((menu) => SideMenu(
                      menu: menu,
                      selectedMenu: selectedSideMenu,
                      press: () {
                        //RiveUtils.chnageSMIBoolState(menu.rive.status!);
                        setState(() {
                          selectedSideMenu = menu;
                        });
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EntryPoint(
                                  inRouteName: menu.routeName, data: null),
                            ));
                      },
                      riveOnInit: (artboard) {
                        menu.rive.status = RiveUtils.getRiveInput(artboard,
                            stateMachineName: menu.rive.stateMachineName);
                      },
                    ))
                .toList(),
            // Padding(
            //   padding: const EdgeInsets.only(left: 24, top: 40, bottom: 16),
            //   child: Text(
            //     "History".toUpperCase(),
            //     style: Theme.of(context)
            //         .textTheme
            //         .titleMedium!
            //         .copyWith(color: Colors.white70),
            //   ),
            // ),
            ...sidebarMenus2
                .map((menu) => SideMenu(
                      menu: menu,
                      selectedMenu: selectedSideMenu!,
                      press: () {
                        RiveUtils.chnageSMIBoolState(menu.rive.status!);
                        setState(() {
                          selectedSideMenu = menu;
                        });
                      },
                      riveOnInit: (artboard) {
                        menu.rive.status = RiveUtils.getRiveInput(artboard,
                            stateMachineName: menu.rive.stateMachineName);
                      },
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: _prefsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            getuserType();
            return loadBody(); // `_prefs` is ready for use.
          }
          // `_prefs` is not ready yet, show loading bar till then.
          return CircularProgressIndicator();
        },
      ),
    );
  }

  late Future<List<Profile>?> _future;
  AuthApi api = AuthApi();
  FutureBuilder<List<Profile>?> getUserInfo() {
    _future = api.profile();
    return FutureBuilder<List<Profile>?>(
        future: _future, // function where you call your api
        builder:
            (BuildContext context, AsyncSnapshot<List<Profile>?> snapshot) {
          // AsyncSnapshot<Your object type>
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text('Please wait its loading...'));
          } else {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return InfoCard(
                name:
                    "${snapshot.data!.first.firstname} ${snapshot.data!.first.lastname}",
                bio: snapshot.data!.first.firstname,
                profileImage: snapshot.data!.first.photo != null
                    ? base64Decode(snapshot.data!.first.photo.toString())
                    : null,
              );
            }
          }
        });
  }
}
