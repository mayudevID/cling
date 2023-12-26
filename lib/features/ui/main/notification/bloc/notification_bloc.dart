// ignore_for_file: use_build_context_synchronously
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../../../core/logger.dart';
import '../../../../model/notification_model_class.dart';
import '../../../../repository/database_repository.dart';
import '../../home/bloc/home_bloc.dart';
import '../../main_page.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc({required DatabaseRepository dbRepo})
      : _dbRepo = dbRepo,
        super(NotificationState()) {
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
  var mainContext = MainPage.navKeyMain.currentContext!;

  void _getNotificationList(event, emit) async {
    if (_loadAgain == false) {
      Logger.Yellow.log("Loader: No DATA");
      state.refreshController.loadNoData();
      return;
    }

    NotificationModelClass? lastRowData;
    if (_firstAttempt) {
      Logger.Green.log("FIRST ATTEMPT");
      lastRowData = await _dbRepo.checkLastRowNotification();
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
    mainContext.read<HomeBloc>().add(GetNotificationCount());
  }

  void _markNotificationReadAll(event, emit) async {
    await _dbRepo.updateNotificationIsReadAll();
    mainContext.read<HomeBloc>().add(GetNotificationCount());
    //add(GetNotificationList());
  }

  void _clearList(event, emit) async {
    emit(state.copyWith(listNotif: List.empty()));
    _timeOffset = null;
    _idOffset = null;
    _firstAttempt = true;
    _loadAgain = true;
  }
}
