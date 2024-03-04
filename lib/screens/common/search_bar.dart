import 'package:com_barge_idigital/services/common/variables.dart';
import 'package:flutter/material.dart';

class CSearchBar extends StatelessWidget {
  final String title;
  final pink = const Color(0xFFFACCCC);
  final grey = const Color(0xFFF2F2F7);

  const CSearchBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width - 32,
        child: Row(
          children: [
            // Padding(
            //     padding: EdgeInsets.only(left: 40, right: 20),
            //     child: Image.asset(assetsLocation + "/avaters/idigitalLogo.png",
            //         height: 80)),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderSide: BorderSide(width: 0.5, color: color),
        borderRadius: BorderRadius.circular(12),
      );
}
