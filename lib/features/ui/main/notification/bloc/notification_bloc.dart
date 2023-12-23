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
    on<MarkNotificationRead>(_markNotificationRead);
    on<MarkNotificationReadAll>(_markNotificationReadAll);
    on<ClearList>(_clearList);
  }

  final DatabaseRepository _dbRepo;
  DateTime? _timeOffset;
  int? _idOffset;
  bool _firstAttempt = true;
  bool _loadAgain = true;

  void _getNotificationCount(event, emit) async {
    final total = await _dbRepo.getNotificationCount();

    emit(state.copyWith(totalNotif: total));
  }

  void _getNotificationList(event, emit) async {
    if (_firstAttempt) {
      _timeOffset = DateTime.now();
      _idOffset = await _dbRepo.checkLastRow();
      _firstAttempt = false;
    }

    if (_idOffset == null || _timeOffset == null) return;

    final dataList = await _dbRepo.getNotificationList(
      _timeOffset!.toIso8601String(),
      _idOffset!,
    );

    if (dataList.length < 25) _loadAgain = false;

    if (_loadAgain) {
      _timeOffset = dataList.last.date;
      _idOffset = dataList.last.id;
    }

    emit(
      state.copyWith(
        listNotif: (dataList.isNotEmpty) ? dataList : List.empty(),
      ),
    );
  }

  void _markNotificationRead(MarkNotificationRead event, emit) async {
    await _dbRepo.updateNotificationIsRead(event.notifData.id!);
    var oldDataList = state.listNotif.toList(growable: true);
    var newModel = event.notifData.copyWith(isRead: true);
    oldDataList[event.idx] = newModel;
    emit(state.copyWith(listNotif: oldDataList));
    add(GetNotificationCount());
  }

  void _markNotificationReadAll(event, emit) async {
    await _dbRepo.updateNotificationIsReadAll();
    add(GetNotificationCount());
    add(GetNotificationList());
  }

  void _clearList(event, emit) async {
    emit(state.copyWith(listNotif: List.empty()));
    _timeOffset = null;
    _idOffset = null;
    _firstAttempt = true;
    _loadAgain = true;
  }
}
