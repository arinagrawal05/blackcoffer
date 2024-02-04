import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  String userid;
  String name;
  String photourl;
  String videoUrl;
  String title;
  String description;
  String videoCategory;
  String address;
  double lat;
  double long;
  DateTime timestamp;

  VideoModel({
    required this.videoUrl,
    required this.title,
    required this.description,
    required this.videoCategory,
    required this.lat,
    required this.long,
    required this.photourl,
    required this.name,
    required this.timestamp,
    required this.userid,
    required this.address,
  });

  // Convert Hive object to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'videoUrl': videoUrl,
      'title': title,
      'description': description,
      'videoCategory': videoCategory,
      'lat': lat,
      'long': long,
      'userid': userid,
      'username': name,
      'profile_pic': photourl,
      'timestamp': timestamp,
      'address': address,
    };
  }

  // Create a VideoModel from a Firestore document
  factory VideoModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return VideoModel(
      videoUrl: data['videoUrl'] ??
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      photourl: data['profile_pic'] ??
          'https://play-lh.googleusercontent.com/C9CAt9tZr8SSi4zKCxhQc9v4I6AOTqRmnLchsu1wVDQL0gsQ3fmbCVgQmOVM1zPru8UH=w240-h480-rw',
      userid: data['userid'] ?? '',
      address: data['address'] ?? 'nearby',
      name: data['username'] ?? 'username',
      timestamp: data['timestamp'] == null
          ? DateTime.now().subtract(const Duration(minutes: 15))
          : data['timestamp'].toDate(),
      title: data['title'] ?? '',
      description: data['description'] ?? 'very nice',
      videoCategory: data['videoCategory'] ?? 'sports',
      lat: (data['lat'] as num?)?.toDouble() ?? 0.0,
      long: (data['long'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // String toJson() => json.encode(toMap());

  factory VideoModel.fromJson(String source) =>
      VideoModel.fromFirestore(json.decode(source));
}

// FirebaseFirestore.instance
//                             .collection("events")
//                             .doc("1003")
//                             .set({
//                           "event_name": "Muj Hackathon Conference 2021",
//                           "timestamp":
//                               "Fri, Nov 18, 2021, 6:30 PM IST",
//                           "event_venue": "Online Event",
//                           "Description":
//                               "2020 marks the year of disruption through technology. The 7th annual MIT FinTech Conference is a student-run event that brings together over 1,000 leaders, companies, and students dedicated to transforming and innovating the FinTech space across the globe. Join us in understanding what this critical juncture means for FinTech's trajectory over the next 10 years.",
//                           "event_attendee_count": 5,
//                           "event_id": "1003",
//                           "event_register_link":
//                               "https://www.eventbrite.com/e/mit-sloan-fintech-conference-2021-tickets-124594929789?aff=ebdssbonlinesearch",
//                           "isVisible": true,
//                           "event_cover_image":
//                               "https://img.evbuc.com/https%3A%2F%2Fcdn.evbuc.com%2Fimages%2F120100739%2F485586024857%2F1%2Foriginal.20201204-212244?h=2000&w=720&auto=format%2Ccompress&q=75&sharp=10&s=bbd7d4240d4e7bea6e7e7dddc2b9d9b6"


//                         });
