// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class NotificationModelClass extends Equatable {
  int? id;
  final String title;
  final String desc;
  final DateTime date;
  final bool isRead;
  final int type;

  NotificationModelClass({
    this.id,
    required this.title,
    required this.desc,
    required this.date,
    required this.isRead,
    required this.type,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        desc,
        date,
        isRead,
        type,
      ];

  NotificationModelClass copyWith({
    int? id,
    String? title,
    String? desc,
    DateTime? date,
    bool? isRead,
    int? type,
  }) {
    return NotificationModelClass(
      title: title ?? this.title,
      desc: desc ?? this.desc,
      date: date ?? this.date,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
    );
  }
}
