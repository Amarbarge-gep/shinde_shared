import 'dart:typed_data';

import 'package:com_barge_idigital/screens/entryPoint/entry_point.dart';
import 'package:com_barge_idigital/services/common/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final Uint8List? profileImage;
  const InfoCard(
      {Key? key, required this.name, required this.bio, this.profileImage})
      : super(key: key);

  final String name, bio;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: profileImage != null && profileImage!.length != 0
          ? CircleAvatar(
              backgroundColor: Colors.white24,
              backgroundImage: MemoryImage(profileImage!),
            )
          : CircleAvatar(
              backgroundColor: Colors.white24,
              backgroundImage:
                  AssetImage("$assetsLocation/avaters/profile.jpg"),
            ),
      title: Text(
        name,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        bio,
        style: const TextStyle(color: Colors.white70),
      ),
      onTap: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const EntryPoint(inRouteName: "setting", data: null),
            ));
      },
    );
  }
}
