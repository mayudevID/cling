// ignore_for_file: must_be_immutable

part of 'notification_bloc.dart';

class NotificationState extends Equatable {
  int totalNotif;
  List<NotificationModelClass> listNotif;
  RefreshController refreshController = RefreshController();

  NotificationState({
    this.totalNotif = 0,
    RefreshController? refreshController,
    List<NotificationModelClass>? listNotif,
  })  : listNotif = listNotif ?? List.empty(),
        refreshController = refreshController ?? RefreshController();

  @override
  List<Object> get props => [
        totalNotif,
        listNotif,
        refreshController,
      ];

  NotificationState copyWith({
    int? totalNotif,
    List<NotificationModelClass>? listNotif,
    RefreshController? refreshController,
  }) {
    return NotificationState(
      totalNotif: totalNotif ?? this.totalNotif,
      listNotif: listNotif ?? this.listNotif,
      refreshController: refreshController ?? this.refreshController,
    );
  }
}
