part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class GetNotificationList extends NotificationEvent {}

class MarkNotificationRead extends NotificationEvent {
  final int idx;
  final NotificationModelClass notifData;

  const MarkNotificationRead(this.idx, this.notifData);
}

class MarkNotificationReadAll extends NotificationEvent {}

class ClearList extends NotificationEvent {}
