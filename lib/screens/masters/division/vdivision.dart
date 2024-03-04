import 'package:com_barge_idigital/model/division.dart';
import 'package:com_barge_idigital/model/school.dart';
import 'package:com_barge_idigital/screens/common/extensions.dart';
import 'package:com_barge_idigital/screens/common/sliver_search_app_bar.dart';
import 'package:com_barge_idigital/screens/entryPoint/entry_point.dart';
import 'package:com_barge_idigital/screens/home/components/secondary_course_card.dart';
import 'package:com_barge_idigital/services/api/division.dart';
import 'package:com_barge_idigital/services/common/variables.dart';
import 'package:flutter/material.dart';
import 'package:com_barge_idigital/constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VDivision extends StatefulWidget {
  const VDivision({super.key});

  @override
  State<VDivision> createState() => _VDivisionState();
}

class _VDivisionState extends State<VDivision>
    with SingleTickerProviderStateMixin {
  ApiDivision api = ApiDivision();
  late Future<List<Division>?> _future;

  late final SharedPreferences _prefs;
  late final _prefsFuture =
      SharedPreferences.getInstance().then((v) => _prefs = v);

  late AnimationController _animationController;
  late Animation<double> scalAnimation;
  late Animation<double> animation;

  // This controller will store the value of the search bar
  final TextEditingController _searchController = TextEditingController();
  late List<Division> _divisionData;
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
    _future = api.advanceSearchDivision(_searchController.text);

    super.initState();
  }

  var listNo = 0;
  getNextNumber() {
    listNo = (listNo == 0 ? 1 : 0);
    return listNo;
  }

  loadBody() {
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: <Widget>[
          const SliverPersistentHeader(
            delegate: SliverSearchAppBar("Division(s)"),
            pinned: true,
          ),
          loadFutureList()
        ],
      ),
    );
  }

  loadBottomNavigationBar() {
    return Transform.translate(
      offset: Offset(0, 100 * animation.value),
      child: SafeArea(
        child: Container(
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                                        inRouteName: "ddivision",
                                        data: Division(
                                            name: "",
                                            description: "",
                                            school: School(
                                                name: "",
                                                description: "",
                                                medium: 1))))).then((value) => {
                                  setState(() {
                                    _divisionData = [];

                                    _future = api.advanceSearchDivision(
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
                        _divisionData = [];
                        _future =
                            api.advanceSearchDivision(_searchController.text);
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
                            _divisionData = [];
                            _future = api
                                .advanceSearchDivision(_searchController.text);
                          })
                        },
                      ),
                      // Add a search icon or button to the search bar
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            _divisionData = [];
                            _future = api
                                .advanceSearchDivision(_searchController.text);
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
      bottomNavigationBar: loadBottomNavigationBar(),
    );
  }

  Widget loadFutureList() {
    var colorSchems = [const Color(0xFF7553F6), "#9cc5ff".toColor()];
    return FutureBuilder<List<Division>?>(
      future: _future, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<List<Division>?> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverToBoxAdapter(
              child: Center(child: Text('Please wait its loading...')));
        } else {
          if (snapshot.hasError) {
            return SliverToBoxAdapter(
                child: Center(child: Text('Error: ${snapshot.error}')));
          } else {
            _divisionData = snapshot != null && snapshot.data != null
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
    return (_divisionData.isNotEmpty
        ? _divisionData
            .map((division) => Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 2),
                  child: SecondaryCourseCard(
                    swithForm: (p0) {
                      setState(() {
                        _divisionData = [];
                        _future =
                            api.advanceSearchDivision(_searchController.text);
                      });
                    },
                    routeName: "ddivision",
                    title: division.name,
                    subtitle: division.description,
                    iconsSrc: "$assetsLocation/icons/divisions.svg",
                    data: division,
                  ),
                ))
            .toList()
        : [Container()]);
  }
}
