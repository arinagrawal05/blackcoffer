import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firabase_storage;

class AppUtils {
  static String getFirstWord(String fullName) {
    List local = fullName.split(" ");
    return local[0];
  }

  // static String getStatsControllerTag() {
  //   ProductType type = Get.find<DashProvider>().currentDashBoard;

  //   // GeneralStatsProvider statsController =
  //   //     Get.find<GeneralStatsProvider>(tag: 'statsFor${type.name}');

  //   return 'statsFor${type.name}';
  // }

  // static String formatAmount(int number) {
  //   final NumberFormat numberFormat = NumberFormat("#,##0", "en_US");
  //   return numberFormat.format(number);
  // }

  static void showSnackMessage(String title) {
    final snackBar = SnackBar(
      content: Text(title),

      // action: SnackBarAction(
      //   label: 'Undo',
      //   onPressed: () {
      //     print("object");
      //    },
      // ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);

    // Get.snackbar(title, subtitle,
    //     snackPosition: SnackPosition.BOTTOM,
    //     barBlur: 3,
    //     margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20));
  }

  static String dateTimetoText(DateTime dateTime) {
    // final format = DateFormat('E, MMM d, y, h:mm a z', 'en_US');
    // Define day and month names
    List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    // Extract date components
    int year = dateTime.year;
    int month = dateTime.month;
    int day = dateTime.day;
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    String period = hour < 12 ? 'AM' : 'PM';

    // Adjust hour for PM format
    if (hour > 12) {
      hour -= 12;
    }

    // Get the day of the week and month
    String dayOfWeek = days[dateTime.weekday - 1];
    String monthName = months[month - 1];

    // Create the formatted string
    String formattedDateTime =
        '$dayOfWeek, $monthName $day, $year, $hour:${minute.toString().padLeft(2, '0')} $period IST';

    // int month = date.month < 10
    //     ? int.parse(date.month.toString().padLeft(2, "0"))
    //     : date.month;
    return formattedDateTime;
    // return format.format(date);
  }

  static String dateTimetoTime(DateTime dateTime) {
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    String period = hour < 12 ? 'AM' : 'PM';

    // Adjust hour for PM format
    if (hour > 12) {
      hour -= 12;
    }

    // Create the formatted string
    String formattedDateTime =
        '$hour:${minute.toString().padLeft(2, '0')} $period IST';

    // int month = date.month < 10
    //     ? int.parse(date.month.toString().padLeft(2, "0"))
    //     : date.month;
    return formattedDateTime;
    // return format.format(date);
  }

  // static String todayTextFormat() {
  //   DateTime date = DateTime.now();
  //   int month = date.month;
  //   // < 10
  //   //     ? int.parse(date.month.toString().padLeft(2, "0"))
  //   //     : date.month;
  //   return "${date.day}/$month/${date.year}";
  // }

  static DateTime textToDateTime(String text) {
    List data = text.split("/");

    return DateTime(
      int.parse(data[2]),
      int.parse(data[1]),
      int.parse(data[0]),
    );
  }

  static launchURL(String url) async {
    var link = Uri.parse(url);
    if (!await launchUrl(link)) {
      throw Exception('Could not launch $link');
    }
  }
}

String getRefCode(String a, String b) {
  if (a.length >= 4 && b.length >= 3) {
    String firstPart = a.substring(0, 4).toLowerCase();
    String secondPart = b.substring(b.length - 3);
    return firstPart + secondPart;
  } else {
    // Handle cases where the input strings are too short
    return "Input strings are too short.";
  }
}

void navigateslide(Widget page, BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

Future<String?>? uploadFileToFirebase() async {
  String imageUrl = '';

  XFile? video =
      // ignore: invalid_use_of_visible_for_testing_member
      await ImagePicker.platform.getVideo(source: ImageSource.camera);
  File file = File(video!.path);
  AppUtils.showSnackMessage("Please Wait");

  try {
    firabase_storage.UploadTask uploadTask;

    firabase_storage.Reference ref = firabase_storage.FirebaseStorage.instance
        .ref()
        .child('Vedios')
        .child('/${Timestamp.now().millisecondsSinceEpoch}');

    final metadata =
        firabase_storage.SettableMetadata(contentType: 'video/mp4');

    //uploadTask = ref.putFile(File(file.path));
    uploadTask = ref.putFile(file, metadata);

    await uploadTask.whenComplete(() {});
    imageUrl = await ref.getDownloadURL();

    // ignore: empty_catches
  } catch (e) {}
  return imageUrl;
}

Future<Position> getGeoLocationPosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    await Geolocator.openLocationSettings();
    return Future.error('Location services are disabled.');
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}

Future<String> getAddressFromLatLong(
  double latitude,
  double longitude,
) async {
  List<Placemark> placemarks =
      await placemarkFromCoordinates(latitude, longitude);
  Placemark place = placemarks[0];
  String address =
      '${place.subThoroughfare}, ${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}';
  return address;
}
