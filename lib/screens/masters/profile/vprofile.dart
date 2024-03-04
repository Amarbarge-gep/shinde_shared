import 'dart:convert';

import 'package:com_barge_idigital/model/profile.dart';
import 'package:com_barge_idigital/model/school.dart';
import 'package:com_barge_idigital/screens/common/sliver_search_app_bar.dart';
import 'package:com_barge_idigital/screens/entryPoint/entry_point.dart';
import 'package:com_barge_idigital/screens/home/components/secondary_course_card.dart';
import 'package:com_barge_idigital/services/api/profile.dart';
import 'package:com_barge_idigital/services/common/variables.dart';
import 'package:flutter/material.dart';
import 'package:com_barge_idigital/constants.dart';
import 'package:flutter_svg/svg.dart';

class VProfile extends StatefulWidget {
  const VProfile({super.key});

  @override
  State<VProfile> createState() => _VProfileState();
}

class _VProfileState extends State<VProfile>
    with SingleTickerProviderStateMixin {
  ApiProfile api = ApiProfile();
  late Future<List<Profile>?> _future;

  late AnimationController _animationController;
  late Animation<double> scalAnimation;
  late Animation<double> animation;

  // This controller will store the value of the search bar
  final TextEditingController _searchController = TextEditingController();
  late List<Profile> _profileData;
  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(
        () {
          setState(() {});
        },
      );
    scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    _future = api.advanceSearch(_searchController.text);
    super.initState();
  }

  var listNo = 0;
  getNextNumber() {
    listNo = (listNo == 0 ? 1 : 0);
    return listNo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: <Widget>[
            const SliverPersistentHeader(
              delegate: SliverSearchAppBar("Profile(s)"),
              pinned: true,
            ),
            loadFutureList()
          ],
        ),
      ),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0, 100 * animation.value),
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            padding:
                const EdgeInsets.only(left: 0, top: 12, right: 0, bottom: 12),
            //margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: backgroundColor2.withOpacity(0.8),
              //borderRadius: const BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: backgroundColor2.withOpacity(0.3),
                  offset: const Offset(0, 20),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 5, 20),
                    child: IconButton(
                        onPressed: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EntryPoint(
                                          inRouteName: "dprofile",
                                          data: Profile(
                                              firstname: "",
                                              lastname: "",
                                              middlename: "",
                                              password: "",
                                              school: School(
                                                  name: "",
                                                  description: "",
                                                  medium: 1),
                                              photo: "",
                                              role: "",
                                              id: "",
                                              username: "")))).then((value) => {
                                    setState(() {
                                      _profileData = [];
                                      _future = api.advanceSearch(
                                          _searchController.text);
                                    }),
                                  })
                            },
                        padding: EdgeInsets.zero,
                        icon: SvgPicture.asset(
                          "$assetsLocation/icons/add.svg",
                          height: 75,
                          width: 75,
                        ))),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 20, 20, 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.9,
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _profileData = [];
                          _future = api.advanceSearch(_searchController.text);
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search',
                        // Add a clear button to the search bar
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => {
                            _searchController.clear(),
                            setState(() {
                              _profileData = [];
                              _future =
                                  api.advanceSearch(_searchController.text);
                            })
                          },
                        ),
                        // Add a search icon or button to the search bar
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            setState(() {
                              _profileData = [];
                              _future =
                                  api.advanceSearch(_searchController.text);
                            });
                            // Perform the search here
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loadFutureList() {
    return FutureBuilder<List<Profile>?>(
      future: _future, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<List<Profile>?> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverToBoxAdapter(
              child: Center(child: Text('Please wait its loading...')));
        } else {
          if (snapshot.hasError) {
            return SliverToBoxAdapter(
                child: Center(child: Text('Error: ${snapshot.error}')));
          } else {
            _profileData = snapshot != null && snapshot.data != null
                ? snapshot.data! ?? []
                : [];
            return SliverToBoxAdapter(
                child: Container(
                    child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: listObject()))));
          } // snapshot.data  :- get your object which is pass from your downloadData() function
        }
      },
    );
  }

  listObject() {
    return (_profileData.isNotEmpty
        ? _profileData
            .map((profile) => Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 2),
                  child: SecondaryCourseCard(
                    swithForm: (p0) {
                      setState(() {
                        _profileData = [];
                        _future = api.advanceSearch(_searchController.text);
                      });
                    },
                    routeName: "dprofile",
                    highlightImage: profile.photo != null
                        ? base64Decode(profile.photo.toString())
                        : null,
                    title:
                        "${profile.firstname} ${profile.middlename} ${profile.lastname}",
                    subtitle: getRole(profile.role),
                    iconsSrc: "$assetsLocation/icons/profiles.svg",
                    data: profile,
                  ),
                ))
            .toList()
        : [Container()]);
  }

  String getRole(String role) {
    if (role == "T") {
      return "Teacher";
    } else if (role == "S") {
      return "Student";
    } else if (role == "H") {
      return "Head";
    } else {
      return "Admin";
    }
  }
}
