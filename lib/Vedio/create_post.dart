// ignore_for_file: library_private_types_in_public_api

import 'package:blackcoffer/Widgets/ui_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class CreatePost extends StatefulWidget {
  final String imageUrl;
  final Position position;

  const CreatePost({super.key, required this.position, required this.imageUrl});
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  @override
  void initState() {
    super.initState();

    Position position = widget.position;
    location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
    getAddressFromLatLong(position);
  }

  String location = 'Null, Press Button';
  String address = 'search';

  Future<void> getAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    address = '${place.locality}';
    setState(() {});
  }

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController category = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              UiHelper.customTextfield2(
                title,
                "Enter Title",
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: UiHelper.customTextfield2(
                  category,
                  "Enter Category",
                ),
              ),
              UiHelper.customTextfield2(
                description,
                "Enter Description",
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Container(
                      padding: const EdgeInsets.all(12),
                      decoration: UiHelper.dashbox(),
                      child: const Icon(
                        Ionicons.navigate,
                        size: 22,
                      )),
                  // ignore: unnecessary_brace_in_string_interps
                  UiHelper.heading('  ${address}', 15),
                ],
              ),
              UiHelper.customButton("Upload To Firebase", () async {
                Position position = widget.position;

                var id = const Uuid().v4();
                FirebaseFirestore.instance.collection("Post").doc(id).set({
                  "post_id": id,
                  'videoUrl': widget.imageUrl,
                  'title': title.text,
                  'description': description.text,
                  'videoCategory': category.text,
                  'lat': position.latitude,
                  'long': position.longitude,
                  "userid": "r4e3fdcr34s",
                  "username": "username",
                  "photo_url":
                      "https://play-lh.googleusercontent.com/C9CAt9tZr8SSi4zKCxhQc9v4I6AOTqRmnLchsu1wVDQL0gsQ3fmbCVgQmOVM1zPru8UH=w240-h480-rw",
                  "address": address,
                  "timestamp": DateTime.now()
                }).then((value) {
                  Navigator.pop(context);
                });
              }, context)
            ],
          ),
        ),
      ),
    );
  }
}
