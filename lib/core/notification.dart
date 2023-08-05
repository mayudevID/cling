import 'package:cling/core/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationClass {
  static const appId = "95f9e85c-44e9-4559-ae29-ffab2ce791f1";

  static void init() {
    //Remove this method to stop OneSignal Debugging
    if (kDebugMode) {
      OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    }

    OneSignal.shared.setAppId(appId);

    // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared
        .promptUserForPushNotificationPermission(
      fallbackToSettings: true,
    )
        .then((accepted) {
      if (kDebugMode) print("Accepted permission: $accepted");
    });

    //* Listener

    //??? Handle when notification opened on Mobile
    OneSignal.shared.setNotificationOpenedHandler(
      NotificationHandler.handleNotificationOpened,
    );

    //??? Handle when notification received on Mobile
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
      NotificationHandler.handleNotificationReceived,
    );
  }
}

class NotificationHandler {
  static handleNotificationOpened(OSNotificationOpenedResult result) {
    Logger.White.log("Handle Notification Opened");
  }

  static void handleNotificationReceived(OSNotificationReceivedEvent event) {
    Logger.White.log("Handle Notification Received");
    event.complete(event.notification);
  }
}

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
