// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:blackcoffer/Vedio/create_post.dart';
import 'package:blackcoffer/Services/functions.dart';
import 'package:blackcoffer/Widgets/ui_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ionicons/ionicons.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'model/vedio_model.dart';
import 'post_detail.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<AuthProvider>(context);

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              Position position = await getGeoLocationPosition();
              uploadFileToFirebase()!.then((value) {
                if (value == null) {
                } else {
                  navigateslide(
                      CreatePost(
                        position: position,
                        imageUrl: value,
                      ),
                      context);
                }
              });
            },
            label: UiHelper.heading("Add Post", 15)),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UiHelper.header(),

              // VideoApp(),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                // height: 335,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Post')
                        .orderBy("timestamp", descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return vedioTile(
                              VideoModel.fromFirestore(
                                  snapshot.data!.docs[index]),
                            );
                          });
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget vedioTile(VideoModel event) {
    return GestureDetector(
      onTap: () {
        navigateslide(VideoApp(model: event), context);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: UiHelper.dashbox(),
              height: 150,
              child: const Icon(Ionicons.videocam, color: Colors.grey),
              // color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(event.photourl),
                        maxRadius: 18,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      UiHelper.heading(event.title, 14),
                      const Spacer(),
                      UiHelper.heading1(event.address.toString(), 14)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      UiHelper.heading1(event.name, 12),
                      UiHelper.heading1("#450views", 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: UiHelper.heading1(
                            "#${timeago.format(event.timestamp).trim()}", 12),
                      ),
                      UiHelper.heading1("#${event.videoCategory}", 12),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
