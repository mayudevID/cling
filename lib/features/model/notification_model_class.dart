class NotificationModelClass {
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
}
