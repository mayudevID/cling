part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class GetNotificationCount extends NotificationEvent {}

class GetNotificationList extends NotificationEvent {}

class ClearList extends NotificationEvent {}
