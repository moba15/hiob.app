import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/manager/file_manager.dart';
import 'package:smart_home/manager/manager.dart';
import 'package:smart_home/manager/notification/custom_notification.dart';

class NotificationManager with WidgetsBindingObserver {
  static AwesomeNotifications awesomeNotifications = AwesomeNotifications();
  static const String ioBrokerConnectionNotificationChannelKey =
      "ioBroker_connection_notification";
  static const String ioBrokerConnectionNotificationChannelGroupKey =
      "ioBroker_connection_notification_group";
  static const String ioBrokerConnectionNotificationChannelGroupName =
      "IoBroker Connection Notification Group";
  static const String ioBrokerConnectionNotificationChannelName =
      "IoBroker Connection Notification";
  static int ioBrokerConnectionNotificationId = 1;

  static const String ioBrokerNotificationChannelKey = "ioBroker_notification";
  static const String ioBrokerNotificationChannelGroupKey =
      "ioBroker_notification_group";
  static const String ioBrokerNotificationChannelGroupName =
      "IoBroker Notification Group";
  static const String ioBrokerNotificationChannelName = "IoBroker Notification";
  static int ioBrokerNotificationId = 1;

  static bool backgroundNotificationsEnabled = false;

  final FileManager fileManager;
  final String notificationSettingsKey = "notificationsettings";
  NotificationManager({required this.fileManager}) {
    readSettings();
    WidgetsBinding.instance.addObserver(this);
  }

  static void init() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    awesomeNotifications.initialize(
        'resource://drawable/ic_launcher',
        [
          NotificationChannel(
            channelKey: ioBrokerConnectionNotificationChannelKey,
            channelGroupKey: ioBrokerConnectionNotificationChannelGroupKey,
            channelName: ioBrokerConnectionNotificationChannelName,
            channelDescription: "Displays your connections status",
            defaultColor: const Color(0xffffffff),
            ledColor: Colors.blue,
          ),
          NotificationChannel(
            channelKey: ioBrokerNotificationChannelKey,
            channelGroupKey: ioBrokerNotificationChannelGroupKey,
            channelName: ioBrokerNotificationChannelName,
            channelDescription: "Displays your ioBroker Notifications",
            defaultColor: const Color(0xffffffff),
            ledColor: Colors.blue,
            enableLights: true,
            playSound: true,
          ),
        ],
        channelGroups: [
          NotificationChannelGroup(
              channelGroupKey: ioBrokerConnectionNotificationChannelGroupKey,
              channelGroupName: ioBrokerConnectionNotificationChannelGroupName)
        ],
        debug: true);
  }

  ///Must be all static because of Isolate

  static void showConnectionNotification(String contentraw) {
    awesomeNotifications.createNotification(
        content: NotificationContent(
      id: ioBrokerConnectionNotificationId,
      channelKey: ioBrokerConnectionNotificationChannelKey,
      actionType: ActionType.KeepOnTop,
      title: 'HioB Connection Status!',
      body: contentraw,
      locked: true,
    ));
  }

  static void showIoBNotification(String contentraw) {
    ioBrokerNotificationId += 1;
    ioBrokerNotificationId %= 500;
    try {
      Map<String, dynamic> content = jsonDecode(contentraw);
      _showIoBNotificationMap(content);
    } on FormatException catch (e) {
      _showIoBNotificationSimple(contentraw);
    }
  }

  static void _showIoBNotificationMap(Map<String, dynamic> content) {
    awesomeNotifications.createNotification(
        content: CustomNotification.fromJSON(content).getNotificationContent(
      id: ioBrokerNotificationId,
      channelKey: ioBrokerNotificationChannelKey,
      groupKey: ioBrokerNotificationChannelGroupKey,
    ));
  }

  static void _showIoBNotificationSimple(String body) {
    awesomeNotifications.createNotification(
        content: NotificationContent(
      id: ioBrokerNotificationId,
      channelKey: ioBrokerNotificationChannelKey,
      actionType: ActionType.Default,
      title: 'Notification',
      body: body,
      color: Colors.red,
      groupKey: ioBrokerNotificationChannelGroupKey,
    ));
  }

  void readSettings() async {
    Map<String, dynamic>? loadedSettings =
        await fileManager.getMap(notificationSettingsKey);
    if (loadedSettings == null) {
      _loadDefaultSettings();
    } else {
      backgroundNotificationsEnabled =
          loadedSettings["backgroundNotificationsEnabled"];
    }
  }

  void _loadDefaultSettings() {
    _save();
  }

  void _save() {
    Map<String, dynamic> settings = {
      "backgroundNotificationsEnabled": backgroundNotificationsEnabled
    };
    fileManager.writeJSON(notificationSettingsKey, settings);
  }

  void changeBackgroundNotificationsEnabled(
      bool backgroundNotificationsEnabled) {
    NotificationManager.backgroundNotificationsEnabled =
        backgroundNotificationsEnabled;
    _save();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        print("detached");
        break;
      case AppLifecycleState.inactive:
        print("inactive");
        break;
      case AppLifecycleState.paused:
        print("paused");
        if (backgroundNotificationsEnabled) {
          Manager.instance.backgroundRunner.startService();
        }
        break;
      case AppLifecycleState.resumed:
        Manager.instance.backgroundRunner.stopService();
        break;
      case AppLifecycleState.hidden:
        print("hidden");
        break;
    }
  }
}
