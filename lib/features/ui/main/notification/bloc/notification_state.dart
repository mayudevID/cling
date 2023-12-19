// ignore_for_file: must_be_immutable

part of 'notification_bloc.dart';

class NotificationState extends Equatable {
  int totalNotif;
  List<NotificationModelClass> listNotif;

  NotificationState({
    this.totalNotif = 0,
    List<NotificationModelClass>? listNotif,
  }) : listNotif = listNotif ?? List.empty();

  @override
  List<Object> get props => [totalNotif, listNotif];

  NotificationState copyWith({
    int? totalNotif,
    List<NotificationModelClass>? listNotif,
  }) {
    return NotificationState(
      totalNotif: totalNotif ?? this.totalNotif,
      listNotif: listNotif ?? this.listNotif,
    );
  }
}
