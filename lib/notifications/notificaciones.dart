// ignore_for_file: prefer_const_constructors, prefer_const_declarations

import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notificaciones {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails(
    'MYID',
    'NOTIFICATION',
    channelDescription: 'Description',
    playSound: true,
    priority: Priority.defaultPriority,
    importance: Importance.defaultImportance,
  );

  static Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final IOSInitializationSettings initializationSettingsIOS =
        const IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: null,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    final bool? result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  mostrar(String titulo, String descripcion) async {
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: _androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
      Random().nextInt(9000),
      titulo,
      descripcion,
      platformChannelSpecifics,
    );
  }
}
