class IncomeMeta {
  static const nameTable = 'income_table';
  static const id = 'income_id';
  static const date = 'date';
  static const desc = 'desc';
  static const amount = 'amount';
  static const amountMinor = 'amount_minor';
  static const idIncomeSource = 'income_source_id';
  static const walletId = 'wallet_id';
}

class ExpenseMeta {
  static const nameTable = 'expense_table';
  static const id = 'expense_id';
  static const date = 'date';
  static const item = 'item';
  static const amount = 'amount';
  static const amountMinor = 'amount_minor';
  static const idCategories = 'expense_source_id';
  static const walletId = 'wallet_id';
}

class WalletMeta {
  static const table = 'wallets';
  static const id = 'wallet_id';
  static const name = 'name';
  static const type = 'type';
  static const openingBalance = 'opening_balance_minor';
  static const currency = 'currency';
  static const archived = 'is_archived';
  static const isDefault = 'is_default';
  static const createdAt = 'created_at';
  static const updatedAt = 'updated_at';
}

class TransferMeta {
  static const table = 'wallet_transfers';
  static const id = 'transfer_id';
  static const sourceWalletId = 'source_wallet_id';
  static const destinationWalletId = 'destination_wallet_id';
  static const amount = 'amount_minor';
  static const date = 'date';
  static const note = 'note';
}

class QuickTemplateMeta {
  static const table = 'quick_transaction_templates';
  static const id = 'template_id';
  static const name = 'name';
  static const type = 'type';
  static const amount = 'amount_minor';
  static const categoryId = 'category_id';
  static const walletId = 'wallet_id';
  static const createdAt = 'created_at';
  static const updatedAt = 'updated_at';
}

class RecurringExpenseMeta {
  static const table = 'recurring_expense_rules';
  static const id = 'rule_id';
  static const name = 'name';
  static const description = 'description';
  static const amount = 'amount_minor';
  static const categoryId = 'category_id';
  static const walletId = 'wallet_id';
  static const frequency = 'frequency';
  static const scheduledDay = 'scheduled_day';
  static const startDate = 'start_date';
  static const endDate = 'end_date';
  static const nextDate = 'next_date';
  static const enabled = 'is_enabled';
  static const postingMode = 'posting_mode';
  static const createdAt = 'created_at';
  static const updatedAt = 'updated_at';
}

class RecurringExpenseOccurrenceMeta {
  static const table = 'recurring_expense_occurrences';
  static const id = 'occurrence_id';
  static const ruleId = 'rule_id';
  static const scheduledDate = 'scheduled_date';
  static const amount = 'amount_minor';
  static const categoryId = 'category_id';
  static const walletId = 'wallet_id';
  static const status = 'status';
  static const expenseId = 'expense_id';
  static const createdAt = 'created_at';
  static const updatedAt = 'updated_at';
}

class BillMeta {
  static const table = 'bills';
  static const id = 'bill_id';
  static const title = 'title';
  static const amount = 'amount_minor';
  static const categoryId = 'category_id';
  static const walletId = 'wallet_id';
  static const dueDate = 'due_date';
  static const reminderMask = 'reminder_mask';
  static const note = 'note';
  static const recurringRuleId = 'recurring_rule_id';
  static const expenseId = 'expense_id';
  static const isCancelled = 'is_cancelled';
  static const createdAt = 'created_at';
  static const updatedAt = 'updated_at';
}

class PlanningMeta {
  static const table = 'planning_settings';
  static const key = 'setting_key';
  static const value = 'setting_value';
}

class PlanningReminderMeta {
  static const table = 'planning_reminder_deliveries';
  static const id = 'delivery_id';
  static const billId = 'bill_id';
  static const occurrenceId = 'occurrence_id';
  static const reminderDays = 'reminder_days';
  static const scheduledDate = 'scheduled_date';
  static const deliveredAt = 'delivered_at';
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
  static const targetMinor = 'goal_target_minor';
  static const collected = 'goal_collected';
  static const collectedMinor = 'goal_collected_minor';
}

class GoalSavingMeta {
  static const nameTable = 'goal_saving_meta';
  static const id = 'goal_saving_id';
  static const idGoal = 'goal_id';
  static const date = 'date_input';
  static const amount = 'amount_input';
  static const amountMinor = 'amount_input_minor';
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

//* TYPE 0: monthly income, must only one
//* TYPE 1: ?
//* TYPE 2: ?

class RecurringMeta {
  static const nameTable = 'recurring_table';
  static const id = 'recurring_id';
  static const idModel = 'recurring_model';
  static const recurringDay = 'recurring_day';
  static const recurringLast = 'last_time';
  static const type = 'recurring_type';
  static const amount = 'rec_amount';
  static const amountMinor = 'rec_amount_minor';
}
