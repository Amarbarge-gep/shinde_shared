import 'package:com_barge_idigital/model/localization.dart';
import 'package:com_barge_idigital/services/common/variables.dart';

import 'rive_model.dart';

class Menu {
  final String title;
  final String routeName;
  final String detailRoute;
  final String iconName;
  final List<String> applicableUsers;
  final RiveModel rive;

  Menu(
      {required this.title,
      required this.routeName,
      required this.detailRoute,
      required this.applicableUsers,
      required this.iconName,
      required this.rive});
}

List<Menu> sidebarMenus = [
  Menu(
    title: "home",
    routeName: "home",
    detailRoute: "",
    applicableUsers: ["A", "T", "S", "H"],
    iconName: "013_school",
    rive: RiveModel(
        src: "$assetsLocation/RiveAssets/icons.riv",
        artboard: "HOME",
        stateMachineName: "HOME_interactivity"),
  ),
  Menu(
    title: "standard",
    routeName: "standard",
    detailRoute: "dstandard",
    applicableUsers: ["A", "T", "H"],
    iconName: "006_network",
    rive: RiveModel(
        src: "$assetsLocation/RiveAssets/icons.riv",
        artboard: "BELL",
        stateMachineName: "BELL_Interactivity"),
  ),
  Menu(
    title: "division",
    routeName: "division",
    detailRoute: "ddivision",
    applicableUsers: ["A", "T", "H"],
    iconName: "007_presentation",
    rive: RiveModel(
        src: "$assetsLocation/RiveAssets/icons.riv",
        artboard: "SEARCH",
        stateMachineName: "SEARCH_Interactivity"),
  ),
  Menu(
    title: "school",
    routeName: "school",
    detailRoute: "dschool",
    applicableUsers: ["A"],
    iconName: "010_school",
    rive: RiveModel(
        src: "$assetsLocation/RiveAssets/icons.riv",
        artboard: "LIKE/STAR",
        stateMachineName: "STAR_Interactivity"),
  ),
  Menu(
    title: "staff",
    routeName: "teacher",
    detailRoute: "dteacher",
    applicableUsers: ["A", "H"],
    iconName: "008_teacher",
    rive: RiveModel(
        src: "$assetsLocation/RiveAssets/icons.riv",
        artboard: "TIMER",
        stateMachineName: "TIMER_Interactivity"),
  ),
  Menu(
    title: "student",
    routeName: "student",
    applicableUsers: ["A", "T", "H"],
    detailRoute: "dstudent",
    iconName: "004_students-1",
    rive: RiveModel(
        src: "$assetsLocation/RiveAssets/icons.riv",
        artboard: "TIMER",
        stateMachineName: "TIMER_Interactivity"),
  ),
  Menu(
    title: "profile",
    routeName: "profile",
    detailRoute: "",
    applicableUsers: ["A"],
    iconName: "003_students",
    rive: RiveModel(
        src: "$assetsLocation/RiveAssets/icons.riv",
        artboard: "TIMER",
        stateMachineName: "TIMER_Interactivity"),
  ),
  Menu(
    title: "idcard",
    routeName: "igenerate",
    detailRoute: "",
    applicableUsers: ["A"],
    iconName: "009_virtual-class",
    rive: RiveModel(
        src: "$assetsLocation/RiveAssets/icons.riv",
        artboard: "TIMER",
        stateMachineName: "TIMER_Interactivity"),
  ),
];
List<Menu> sidebarMenus2 = [
  // Menu(
  //   title: "Help",
  //   routeName: "",
  //   rive: RiveModel(
  //       src: "$assetsLocation/RiveAssets/icons.riv",
  //       artboard: "CHAT",
  //       stateMachineName: "CHAT_Interactivity"),
  // ),
  // Menu(
  //   title: "Notifications",
  //   routeName: "",
  //   rive: RiveModel(
  //       src: "$assetsLocation/RiveAssets/icons.riv",
  //       artboard: "BELL",
  //       stateMachineName: "BELL_Interactivity"),
  // ),
];

List<Menu> bottomNavItems = [
  Menu(
    title: "Chat",
    routeName: "",
    detailRoute: "",
    applicableUsers: ["A"],
    iconName: "",
    rive: RiveModel(
        src: "$assetsLocation/RiveAssets/icons.riv",
        artboard: "CHAT",
        stateMachineName: "CHAT_Interactivity"),
  ),
  Menu(
    title: "Search",
    routeName: "",
    detailRoute: "",
    applicableUsers: ["A"],
    iconName: "",
    rive: RiveModel(
        src: "$assetsLocation/RiveAssets/icons.riv",
        artboard: "SEARCH",
        stateMachineName: "SEARCH_Interactivity"),
  ),
  Menu(
    title: "Timer",
    routeName: "",
    detailRoute: "",
    applicableUsers: ["A"],
    iconName: "",
    rive: RiveModel(
        src: "$assetsLocation/RiveAssets/icons.riv",
        artboard: "TIMER",
        stateMachineName: "TIMER_Interactivity"),
  ),
  Menu(
    title: "Notification",
    routeName: "",
    detailRoute: "",
    applicableUsers: ["A"],
    iconName: "",
    rive: RiveModel(
        src: "$assetsLocation/RiveAssets/icons.riv",
        artboard: "BELL",
        stateMachineName: "BELL_Interactivity"),
  ),
  Menu(
    title: "Profile",
    routeName: "",
    detailRoute: "",
    applicableUsers: ["A"],
    iconName: "",
    rive: RiveModel(
        src: "$assetsLocation/RiveAssets/icons.riv",
        artboard: "USER",
        stateMachineName: "USER_Interactivity"),
  ),
];
