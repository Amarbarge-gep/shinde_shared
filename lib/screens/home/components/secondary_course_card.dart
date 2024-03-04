import 'dart:typed_data';

import 'package:com_barge_idigital/screens/entryPoint/entry_point.dart';
import 'package:com_barge_idigital/screens/settings/components/profile.dart';
import 'package:com_barge_idigital/screens/settings/photoupload.dart';
import 'package:com_barge_idigital/services/common/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SecondaryCourseCard extends StatelessWidget {
  final Function(bool) swithForm;
  final String routeName;
  const SecondaryCourseCard(
      {Key? key,
      required this.swithForm,
      required this.routeName,
      required this.title,
      this.highlightImage,
      this.subtitle = "",
      this.iconsSrc = "/icons/ios.svg",
      this.colorl = const Color(0xFF7553F6),
      this.data})
      : super(key: key);

  final String title, subtitle, iconsSrc;
  final Color colorl;
  final dynamic data;
  final Uint8List? highlightImage;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          highlightImage != null
              ? PhotoUpload(
                  image: highlightImage,
                  uploadButtonTitle: "",
                  updateProfile: null,
                  smallImage: true,
                )
              : Container(),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EntryPoint(
                            inRouteName: routeName,
                            data: data,
                          ))).then((value) => {swithForm(true)});
            },
            padding: EdgeInsets.zero,
            icon: SvgPicture.asset(
              "$assetsLocation/icons/divisions.svg",
              height: 75,
              width: 75,
            ),
          )
        ],
      ),
    );
    // return Container(
    //   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    //   decoration: BoxDecoration(
    //       color: colorl,
    //       borderRadius: const BorderRadius.all(Radius.circular(20))),
    //   child: Row(
    //     children: [
    //       Expanded(
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text(
    //               title,
    //               style: Theme.of(context).textTheme.headlineSmall!.copyWith(
    //                     color: Colors.white,
    //                     fontWeight: FontWeight.w600,
    //                   ),
    //             ),
    //             const SizedBox(height: 4),
    //             Text(
    //               subtitle,
    //               style: const TextStyle(
    //                 color: Colors.white60,
    //                 fontSize: 16,
    //               ),
    //             )
    //           ],
    //         ),
    //       ),
    //       const SizedBox(
    //         height: 40,
    //         child: VerticalDivider(
    //           // thickness: 5,
    //           color: Colors.white70,
    //         ),
    //       ),
    //       const SizedBox(width: 8),
    //       IconButton(
    //         onPressed: () {
    //           Navigator.push(
    //               context,
    //               MaterialPageRoute(
    //                   builder: (context) => EntryPoint(
    //                         inRouteName: "ddivision",
    //                         data: data,
    //                       ))).then((value) => {swithForm(true)});
    //         },
    //         padding: EdgeInsets.zero,
    //         icon: SvgPicture.asset(
    //           "$assetsLocation/icons/divisions.svg",
    //           height: 75,
    //           width: 75,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
