import 'package:bloc/bloc.dart';
import 'package:cling/features/model/notification_model_class.dart';
import 'package:cling/features/repository/database_repository.dart';
import 'package:equatable/equatable.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc({required DatabaseRepository dbRepo})
      : _dbRepo = dbRepo,
        super(NotificationState()) {
    on<GetNotificationCount>(_getNotificationCount);
    on<GetNotificationList>(_getNotificationList);
  }

  final DatabaseRepository _dbRepo;

  void _getNotificationCount(event, emit) async {
    final total = await _dbRepo.getNotificationCount();
    emit(state.copyWith(totalNotif: total));
  }

  void _getNotificationList(event, emit) async {
    final dataList = await _dbRepo.getNotificationList();
    emit(
      state.copyWith(
        listNotif: (dataList.isNotEmpty) ? dataList : List.empty(),
      ),
    );
  }
}
