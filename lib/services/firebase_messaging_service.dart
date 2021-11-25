import 'dart:core';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:randolina/services/database.dart';
import 'package:randolina/utils/logger.dart';

import 'api_path.dart';

class FirebaseMessagingService {
  FirebaseMessagingService();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> _configLocalNotification() async {
    final initializationSettingsAndroid =
        AndroidInitializationSettings('launcher_icon');
    final initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) {
      // this is for iphone usings ios under 10

      // didReceiveLocalNotificationSubject.add(ReceivedNotification(
      //     id: id, title: title, body: body, payload: payload));
    });
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (dynamic payload) async {
      if (payload != null) {
        //! clicking on the notif callback
        logger.info('onMessage Clicked: ');
        logger.info(payload);
      }
    });
  }

  Future<void> configFirebaseNotification(String uid, Database database) async {
    //logger.info('configuring FIREBASE MESSAGING');
    _configLocalNotification();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logger.info('Got a message whilst in the foreground!');
      logger.info('Message data: ${message.data}');

      if (message.notification != null) {
        logger.info(
            'Message also contained a notification: ${message.notification}');
        logger.info("onMessage: $message");

        _showNotification(message.notification);
      }
    });

    await _firebaseMessaging.requestPermission();

    _firebaseMessaging.getToken().then((String? newToken) async {
      logger.info('************user token*************');
      logger.info(newToken);
      //oldToken != newToken
      if (true) {
        database.setData(
          path: APIPath.userDocument(uid),
          data: {'pushToken': newToken},
        );
      }
    });
  }

  Future<void> _showNotification(RemoteNotification? message) async {
    final int id = Random().nextInt(1000);
    logger.info('showing notification called*****************');
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      Platform.isAndroid ? 'com.merine.randolina' : 'com.merine.randolina',
      'Randolina',
    );
    final iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      id,
      message?.title,
      message?.body,
      platformChannelSpecifics,
    );
  }
}
