class IncomeMeta {
  static const nameTable = 'income_table';
  static const id = 'income_id';
  static const date = 'date';
  static const desc = 'desc';
  static const amount = 'amount';
  static const incomeSource = 'income_source';
}

class ExpenseMeta {
  static const nameTable = 'expense_table';
  static const id = 'expense_id';
  static const date = 'date';
  static const item = 'item';
  static const amount = 'amount';
  static const categories = 'categories';
}

class IncomeSourceMeta {
  static const nameTable = 'income_source_meta';
  static const id = 'income_source_id';
  static const incomeSource = 'income_source';
}

class ExpenseCategoriesMeta {
  static const nameTable = 'expense_source_meta';
  static const id = 'expense_source_id';
  static const expenseCategories = 'expense_categories';
}
