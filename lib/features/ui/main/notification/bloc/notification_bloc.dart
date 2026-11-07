// ignore_for_file: use_build_context_synchronously
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../../../main.dart';
import '../../../../model/notification_model_class.dart';
import '../../../../repository/database_repository.dart';
import '../../home/bloc/home_bloc.dart';

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
  DateTime? _cursorTime;
  int? _cursorId;
  bool _loading = false;
  bool _hasMore = true;
  int _generation = 0;
  static const int _pageSize = 12;
  BuildContext get mainContext => MainApp.navKeyGlobal.currentContext!;

  Future<void> _getNotificationList(
    GetNotificationList event,
    Emitter<NotificationState> emit,
  ) async {
    if (_loading) return;
    if (!_hasMore) {
      state.refreshController.loadNoData();
      return;
    }
    _loading = true;
    final revision = _dbRepo.revision;
    final generation = _generation;
    try {
      final page = await _dbRepo.getNotificationsPage(
        beforeDate: _cursorTime,
        beforeId: _cursorId,
      );
      if (isClosed ||
          revision != _dbRepo.revision ||
          generation != _generation) {
        return;
      }
      if (page.isNotEmpty) {
        _cursorTime = page.last.date;
        _cursorId = page.last.id;
        emit(state.copyWith(listNotif: [...state.listNotif, ...page]));
      }
      _hasMore = page.length == _pageSize;
      if (_hasMore) {
        state.refreshController.loadComplete();
      } else {
        state.refreshController.loadNoData();
      }
    } catch (_) {
      if (!isClosed) state.refreshController.loadFailed();
    } finally {
      _loading = false;
    }
  }

  Future<void> _markNotificationRead(
    MarkNotificationRead event,
    Emitter<NotificationState> emit,
  ) async {
    await _dbRepo.updateNotificationIsRead(event.notifData.id!);
    final List<NotificationModelClass> oldDataList =
        state.listNotif.toList(growable: true);
    final NotificationModelClass newModel =
        event.notifData.copyWith(isRead: true);
    final idx = oldDataList.indexWhere((item) => item.id == event.notifData.id);
    if (idx < 0) return;
    oldDataList[idx] = newModel;
    emit(state.copyWith(listNotif: oldDataList));
    mainContext.read<HomeBloc>().add(GetNotificationCount());
  }

  Future<void> _markNotificationReadAll(
    MarkNotificationReadAll event,
    Emitter<NotificationState> emit,
  ) async {
    await _dbRepo.updateNotificationIsReadAll();
    emit(
      state.copyWith(
        listNotif:
            state.listNotif.map((item) => item.copyWith(isRead: true)).toList(),
      ),
    );
    mainContext.read<HomeBloc>().add(GetNotificationCount());
    //add(GetNotificationList());
  }

  void _clearList(ClearList event, Emitter<NotificationState> emit) {
    ++_generation;
    _cursorTime = null;
    _cursorId = null;
    _hasMore = true;
    state.refreshController.resetNoData();
    emit(state.copyWith(listNotif: []));
  }

  @override
  Future<void> close() async {
    state.refreshController.dispose();
    await super.close();
  }
}
