import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../env.dart';
import '../features/ui/app_bloc/app_bloc.dart';
import '../main.dart';
import 'logger.dart';
import 'route.dart';

class PushNotificationClass {
  static Future<void> init() async {
    if (kDebugMode) {
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    }

    OneSignal.initialize(EnvApp.oneSignalAppId);

    // ignore: unused_local_variable
    var permissionNative = await OneSignal.Notifications.permissionNative();
    // ignore: unused_local_variable
    var canRequest = await OneSignal.Notifications.canRequest();

    OneSignal.Notifications.requestPermission(true).then((accepted) {
      if (kDebugMode) print("Accepted permission: $accepted");
    });

    OneSignal.User.pushSubscription.optIn();

    //* Listener

    //??? Handle when notification opened on Mobile

    OneSignal.Notifications.addClickListener((event) {
      Logger.White.log('NOTIFICATION CLICK LISTENER CALLED WITH EVENT: $event');
      //OSNotification notification = event.notification;
    });

    //??? Handle when notification received on Mobile

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      event.notification.display();
    });

    //* LOCAL NOTIFICATION

    await AwesomeNotifications().initialize(
      'resource://drawable/ic_stat_onesignal_default',
      [
        NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Warning Notification',
          importance: NotificationImportance.Max,
          channelDescription:
              'Warning Notification when user limited monthly budget',
          defaultColor: Colors.blue,
          ledColor: Colors.blue,
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: kDebugMode,
    );
  }
}

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
    ReceivedNotification receivedNotification,
  ) async {}

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {}

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {}

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    // Navigate into pages, avoiding to open the notification details page over another details page already opened
    var context = MainApp.navKeyGlobal.currentContext;
    if (context != null && context.read<AppBloc>().isRedirect) {
      MainApp.navKeyGlobal.currentState?.pushNamedAndRemoveUntil(
        RouteName.notification,
        (route) =>
            (route.settings.name != RouteName.notification) || route.isFirst,
        arguments: receivedAction,
      );
    }
  }
}

// class NotificationHandler {
//   static handleNotificationOpened(OSNotificationOpenedResult result) {
//     Logger.White.log("Handle Notification Opened");
//   }

//   static void handleNotificationReceived(OSNotificationReceivedEvent event) {
//     Logger.White.log("Handle Notification Received");
//     event.complete(event.notification);
//   }
// }

// static handleNotificationOpened(OSNotificationOpenedResult result) async {
//     OSNotification notification = result.notification; // Notification object
//     // Data / Payload inside notification object
//     var data = notification.additionalData;
//     var payload = NotificationPayload.fromJson(data ?? {});
//     debugPrint("NOTIFICATION JSON OPEN =>" + payload.toJson().toString());
//     debugPrint("NOTIFICATION additional OPEN =>" +
//         notification.additionalData.toString());
//     // Mark the corresponding notification as read first
//     await markAsReadNotification(payload.notificationUuid ?? "").then(
//       (value) async {
//         // Refreshing API call on Notification page when success marking notification as read
//         Future.wait([
//           Get.find<NotificationController>().getStatistics(),
//           Get.find<NotificationController>().refreshNotification(),
//         ]);

//         AnalyticsService().setCurrentScreen(
//           screenName: "Notification Detail",
//           root:
//               notificationNavigation[payload.notificationType] ?? PageName.HOME,
//         );

//         /// Navigate to corresponding detail screen based on [payload.notificationType]
//         goTo(payload);
//       },
//     );
//   }
