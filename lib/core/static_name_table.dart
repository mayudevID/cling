class IncomeMeta {
  static const nameTable = 'income_table';
  static const id = 'income_id';
  static const date = 'date';
  static const desc = 'desc';
  static const amount = 'amount';
  static const idIncomeSource = 'income_source_id';
}

class ExpenseMeta {
  static const nameTable = 'expense_table';
  static const id = 'expense_id';
  static const date = 'date';
  static const item = 'item';
  static const amount = 'amount';
  static const idCategories = 'expense_source_id';
}

class IncomeSourceMeta {
  static const nameTable = 'income_source_table';
  static const id = 'income_source_id';
  static const incomeSource = 'income_source';
}

class ExpenseCategoriesMeta {
  static const nameTable = 'expense_categories_table';
  static const id = 'expense_categories_id';
  static const expenseCategories = 'expense_categories';
}

class GoalMeta {
  static const nameTable = 'goal_meta';
  static const id = 'goal_id';
  static const image = 'goal_image';
  static const name = 'goal_name';
  static const target = 'goal_target';
  static const collected = 'goal_collected';
}

class GoalSavingMeta {
  static const nameTable = 'goal_saving_meta';
  static const id = 'goal_saving_id';
  static const idGoal = 'goal_id';
  static const date = 'date_input';
  static const amount = 'amount_input';
}

class NotificationMeta {
  static const nameTable = 'notification_table';
  static const id = 'notification_id';
  static const title = 'title';
  static const desc = 'desc';
  static const date = 'date';
  static const type = 'type';
  static const isRead = 'is_read';
}
