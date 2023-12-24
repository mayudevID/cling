import 'package:bloc/bloc.dart';
import 'package:cling/core/logger.dart';
import 'package:cling/features/model/notification_model_class.dart';
import 'package:cling/features/repository/database_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

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
    if (_loadAgain == false) {
      Logger.Yellow.log("Loader: No DATA");
      state.refreshController.loadNoData();
      return;
    }

    NotificationModelClass? lastRowData;
    if (_firstAttempt) {
      Logger.Green.log("FIRST ATTEMPT");
      lastRowData = await _dbRepo.checkLastRow();
      if (lastRowData == null) {
        state.refreshController.loadNoData();
        return;
      } else {
        _timeOffset = lastRowData.date;
        _idOffset = lastRowData.id;
      }
    }

    if (_idOffset == null || _timeOffset == null) {
      Logger.Yellow.log("Loader: FAIL");
      state.refreshController.loadFailed();
      return;
    }

    final dataList = await _dbRepo.getNotificationList(
      _timeOffset!.toIso8601String(),
      _idOffset!,
    );

    await Future.delayed(const Duration(milliseconds: 250));

    if (dataList.isNotEmpty) {
      var dataListNew = state.listNotif.toList(growable: true);
      if (_firstAttempt) {
        _firstAttempt = false;
        dataListNew.add(lastRowData!);
      }
      dataListNew.addAll(dataList);
      emit(state.copyWith(listNotif: dataListNew));
    }

    if (dataList.length < 12) {
      _loadAgain = false;
      Logger.Yellow.log("Loader: No DATA");
      state.refreshController.loadNoData();
    } else {
      Logger.Yellow.log("Loader: Load Complete/Possible Next");
      state.refreshController.loadComplete();
      _timeOffset = dataList.last.date;
      _idOffset = dataList.last.id;
    }
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
