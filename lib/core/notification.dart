import 'package:cling/core/logger.dart';
import 'package:cling/env.dart';
import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationClass {
  static void init() async {
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
