import 'dart:io';
import 'dart:typed_data';

import 'package:com_barge_idigital/services/common/variables.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileWidget extends StatefulWidget {
  final Function(XFile?)? updateProfile;
  late final Uint8List? image;
  final bool smallImage;
  ProfileWidget(
      {super.key,
      required this.image,
      required this.updateProfile,
      this.smallImage = false});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfileWidget> {
  bool circular = false;
  XFile? _imageFile;
  final _globalkey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return imageProfile();
  }

  Widget imageProfile() {
    var profileFromMem;
    if (widget.image != null &&
        widget.image != Uint8List(0) &&
        widget.image!.length > 0) {
      debugPrint("Getting image data 1.");
      profileFromMem =
          MemoryImage(Uint8List.fromList(widget.image as List<int>));
    }
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: widget.smallImage ? 40.0 : 80.0,
          backgroundImage: _imageFile == null && profileFromMem == null
              ? AssetImage("$assetsLocation/avaters/profile.jpg")
              : _imageFile != null
                  ? FileImage(File(_imageFile!.path))
                  : profileFromMem,
        ),
        widget.updateProfile != null
            ? Positioned(
                bottom: 20.0,
                right: 20.0,
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: ((builder) => bottomSheet()),
                    );
                  },
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.teal,
                    size: 28.0,
                  ),
                ),
              )
            : Container(),
      ]),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            IconButton(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
            ),
            IconButton(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      imageQuality: 25,
      source: source,
      preferredCameraDevice: CameraDevice.front,
    );
    setState(() {
      widget.updateProfile!(pickedFile);
      _imageFile = pickedFile;
    });
  }
}
