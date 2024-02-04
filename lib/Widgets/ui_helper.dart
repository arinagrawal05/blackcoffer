import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

class UiHelper {
  static Widget customButton(
    String text,
    void Function()? ontap,
    BuildContext context, {
    bool isExpanded = true,
    double? height,
    Color color = Colors.blueAccent,
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

  static Widget buttonText(
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

  static BoxDecoration dashbox() {
    return BoxDecoration(
      color: Colors.grey.shade300.withOpacity(0.5),
      borderRadius: BorderRadius.circular(12),
    );
  }

  static Widget customTextfield2(
      TextEditingController controller, String labelText,
      {bool isExpanded = false, onChange, double wid = 500, double hgt = 40}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Container(
        decoration: dashbox(),
        width: isExpanded ? double.infinity : wid,
        height: hgt,
        // padding: const EdgeInsets.all(6),
        child: TextField(
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.w300,
          ),
          onChanged: onChange,
          keyboardType: TextInputType.text,
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: labelText,
            // isDense: true,
            contentPadding: const EdgeInsets.all(4),
          ),
        ),
      ),
    );
  }

  static Widget header() {
    TextEditingController search = TextEditingController();
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          // margin: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  height: 35,
                  width: 35,
                  child: Image.network(
                      "https://cdn.logo.com/hotlink-ok/logo-social-sq.png")),
              const Icon(
                Ionicons.notifications_circle_outline,
                size: 30,
              )
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
                flex: 5,
                child: customTextfield2(search, "Search", isExpanded: false)),
            Expanded(
                flex: 1,
                child: AspectRatio(
                    aspectRatio: 1, child: symbolBox(Ionicons.filter)))
          ],
        ),
      ],
    );
  }

  static Widget symbolBox(IconData icon) {
    return Container(
      decoration: dashbox(),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      child: Icon(
        icon,
        color: Colors.grey,
      ),
    );
  }

  static Widget heading(String text, double fontSize,
      {Color? color, bool center = false}) {
    return Text(text,
        textAlign: center ? TextAlign.center : null,
        style: GoogleFonts.montserrat(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.none,
        ));
  }

// TextStyle fontStyle(double fontSize) {
//   return );
// }

  static Widget heading1(String text, double fontSize,
      {TextOverflow overF = TextOverflow.ellipsis,
      bool center = false,
      Color? color}) {
    return Text(
      text,
      maxLines: 2,
      style: GoogleFonts.nunito(
          color: color ?? Colors.grey,
          fontSize: fontSize,
          fontWeight: FontWeight.w500),
      overflow: overF,
      textAlign: center ? TextAlign.center : TextAlign.justify,
    );
  }

  static Widget productTileText(String text, double fontSize,
      {TextOverflow overF = TextOverflow.ellipsis,
      bool center = false,
      Color? color}) {
    return Text(
      text,
      softWrap: true,
      overflow: overF,
      textAlign: center ? TextAlign.center : TextAlign.justify,
      style: GoogleFonts.nunito(
          fontSize: fontSize, fontWeight: FontWeight.w500, color: color),
    );
  }

  static Widget simpleText(String text, double fontSize,
      {TextAlign align = TextAlign.left}) {
    return Text(
      text,
      textAlign: align,
      style: GoogleFonts.nunito(
        fontSize: fontSize,
      ),
    );
  }
}
