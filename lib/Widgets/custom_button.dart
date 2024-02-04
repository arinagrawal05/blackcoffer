import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:upes_go/Shared/colors.dart';

import 'colors.dart';

Widget customButton(
  String text,
  void Function()? ontap,
  BuildContext context, {
  bool isExpanded = true,
  double? height,
  Color color = ColorPalatte.primaryColor,
}) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: MaterialButton(
      // height: ,
      height: height,
      minWidth: isExpanded ? MediaQuery.of(context).size.width : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: color,
      onPressed: ontap,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: buttonText(text, 14),
      ),
    ),
  );
}

Widget buttonText(
  String text,
  double fontSize, {
  Color color = Colors.white,
}) {
  return Text(
    text,
    style: GoogleFonts.nunito(
        color: color, fontSize: fontSize, fontWeight: FontWeight.w500),
  );
}

Widget customSquareButton(
  IconData? icon,
  Color bgColor,
  void Function()? ontap,
  BuildContext context, {
  double? size = 45,
}) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: MaterialButton(
      height: size,
      minWidth: size,
      // minWidth: isExpanded ? MediaQuery.of(context).size.width : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: bgColor,
      onPressed: ontap,
      child: Center(
        // padding: EdgeInsets.all(size! / 5),
        child: Icon(
          icon,
          size: 16,
        ),
      ),
    ),
  );
}
