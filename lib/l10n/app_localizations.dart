import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id')
  ];

  /// No description provided for @onboarding.
  ///
  /// In en, this message translates to:
  /// **'Manage Your Money, Reach Your Goals, and Thrive.'**
  String get onboarding;

  /// No description provided for @newUser.
  ///
  /// In en, this message translates to:
  /// **'I’m new here'**
  String get newUser;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account'**
  String get haveAccount;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back! ✨'**
  String get welcomeBack;

  /// No description provided for @descWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Enter your registed account to manage your money and reach your goals'**
  String get descWelcomeBack;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @dontHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account?'**
  String get dontHaveAnAccount;

  /// No description provided for @createNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get createNewAccount;

  /// No description provided for @emailPassIsIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Email or Password is incorrect'**
  String get emailPassIsIncorrect;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @helloThere.
  ///
  /// In en, this message translates to:
  /// **'Hello THERE! ✨'**
  String get helloThere;

  /// No description provided for @descHelloThere.
  ///
  /// In en, this message translates to:
  /// **'Nice to meet you! enter your identity to reach your goals'**
  String get descHelloThere;

  /// No description provided for @haveAccountTwo.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get haveAccountTwo;

  /// No description provided for @almostThere.
  ///
  /// In en, this message translates to:
  /// **'Almost there'**
  String get almostThere;

  /// No description provided for @lastStep.
  ///
  /// In en, this message translates to:
  /// **'The last step is verify your account. Go to email to verify your account now'**
  String get lastStep;

  /// No description provided for @goToMail.
  ///
  /// In en, this message translates to:
  /// **'Go to email'**
  String get goToMail;

  /// No description provided for @forgotPasswordPage.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordPage;

  /// No description provided for @descForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Don’t worry! enter your mail so we can share you link to change password'**
  String get descForgotPassword;

  /// No description provided for @sendMeLink.
  ///
  /// In en, this message translates to:
  /// **'Send me link'**
  String get sendMeLink;

  /// No description provided for @checkYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get checkYourEmail;

  /// No description provided for @descCheckYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Great! Now you can change your password through the link we send to your mail'**
  String get descCheckYourEmail;

  /// No description provided for @goodDay.
  ///
  /// In en, this message translates to:
  /// **'Good day'**
  String get goodDay;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @goals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get goals;

  /// No description provided for @todayExpenses.
  ///
  /// In en, this message translates to:
  /// **'Today Expenses'**
  String get todayExpenses;

  /// No description provided for @addExpenses.
  ///
  /// In en, this message translates to:
  /// **'Add Expenses'**
  String get addExpenses;

  /// No description provided for @addIncome.
  ///
  /// In en, this message translates to:
  /// **'Add Income'**
  String get addIncome;

  /// No description provided for @editExpenses.
  ///
  /// In en, this message translates to:
  /// **'Edit Expenses'**
  String get editExpenses;

  /// No description provided for @editIncome.
  ///
  /// In en, this message translates to:
  /// **'Edit Income'**
  String get editIncome;

  /// No description provided for @purchaseDate.
  ///
  /// In en, this message translates to:
  /// **'Purchase Date'**
  String get purchaseDate;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @incomeSource.
  ///
  /// In en, this message translates to:
  /// **'Income Source'**
  String get incomeSource;

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (Optional)'**
  String get descriptionOptional;

  /// No description provided for @expenseAdded.
  ///
  /// In en, this message translates to:
  /// **'Expense Added'**
  String get expenseAdded;

  /// No description provided for @incomeAdded.
  ///
  /// In en, this message translates to:
  /// **'Income Added'**
  String get incomeAdded;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @savings.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get savings;

  /// No description provided for @yearlyBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Yearly Breakdown'**
  String get yearlyBreakdown;

  /// No description provided for @mostExpense.
  ///
  /// In en, this message translates to:
  /// **'Most Expense'**
  String get mostExpense;

  /// No description provided for @mostIncome.
  ///
  /// In en, this message translates to:
  /// **'Most Income'**
  String get mostIncome;

  /// No description provided for @expenseBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Expense Breakdown'**
  String get expenseBreakdown;

  /// No description provided for @incomeBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Income Breakdown'**
  String get incomeBreakdown;

  /// No description provided for @cashflow.
  ///
  /// In en, this message translates to:
  /// **'Cashflow'**
  String get cashflow;

  /// No description provided for @noExpenseToday.
  ///
  /// In en, this message translates to:
  /// **'No expense today :D'**
  String get noExpenseToday;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @selectCategories.
  ///
  /// In en, this message translates to:
  /// **'Select Categories'**
  String get selectCategories;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @invalidEmailFailure.
  ///
  /// In en, this message translates to:
  /// **'Email is not valid or badly formatted.'**
  String get invalidEmailFailure;

  /// No description provided for @userDisabledFailure.
  ///
  /// In en, this message translates to:
  /// **'This user has been disabled. Please contact support for help.'**
  String get userDisabledFailure;

  /// No description provided for @userNotFoundFailure.
  ///
  /// In en, this message translates to:
  /// **'Email is not found, please create an account.'**
  String get userNotFoundFailure;

  /// No description provided for @wrongPasswordFailure.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password, please try again.'**
  String get wrongPasswordFailure;

  /// No description provided for @emailAlreadyFailure.
  ///
  /// In en, this message translates to:
  /// **'An account already exists.'**
  String get emailAlreadyFailure;

  /// No description provided for @operationNotAllowedFailure.
  ///
  /// In en, this message translates to:
  /// **'Operation is not allowed. Please contact support.'**
  String get operationNotAllowedFailure;

  /// No description provided for @weakPasswordFailure.
  ///
  /// In en, this message translates to:
  /// **'Please enter a stronger password.'**
  String get weakPasswordFailure;

  /// No description provided for @monthlyBudget.
  ///
  /// In en, this message translates to:
  /// **'Monthly Budget'**
  String get monthlyBudget;

  /// No description provided for @spent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get spent;

  /// No description provided for @formEmpty.
  ///
  /// In en, this message translates to:
  /// **'Blank data'**
  String get formEmpty;

  /// No description provided for @passwordLengthFailure.
  ///
  /// In en, this message translates to:
  /// **'Password must be 8 character or more'**
  String get passwordLengthFailure;

  /// No description provided for @passConfPassFailure.
  ///
  /// In en, this message translates to:
  /// **'Password and Confirm Password do not match'**
  String get passConfPassFailure;

  /// No description provided for @chooseLang.
  ///
  /// In en, this message translates to:
  /// **'Choose language:'**
  String get chooseLang;

  /// No description provided for @verifSuccess.
  ///
  /// In en, this message translates to:
  /// **'Get ready to dive headfirst into the app, where you can effortlessly glide through its awesome features and unlock a goal!'**
  String get verifSuccess;

  /// No description provided for @invalidLoginCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid login credentials'**
  String get invalidLoginCredentials;

  /// No description provided for @emailNotConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Email not confirmed'**
  String get emailNotConfirmed;

  /// No description provided for @setMonthlyBudget.
  ///
  /// In en, this message translates to:
  /// **'Set Monthly Budget'**
  String get setMonthlyBudget;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'No, skip'**
  String get skip;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @monBudgetIncomeQuest.
  ///
  /// In en, this message translates to:
  /// **'First thing first!\nwhat\'s your monthly income?'**
  String get monBudgetIncomeQuest;

  /// No description provided for @monBudgetSpentQuest.
  ///
  /// In en, this message translates to:
  /// **'How much do you want to spend monthly?'**
  String get monBudgetSpentQuest;

  /// No description provided for @goalEmpty.
  ///
  /// In en, this message translates to:
  /// **'You don’t have a goal'**
  String get goalEmpty;

  /// No description provided for @addGoals.
  ///
  /// In en, this message translates to:
  /// **'Add Goal'**
  String get addGoals;

  /// No description provided for @monthlyIncome.
  ///
  /// In en, this message translates to:
  /// **'Monthly Income'**
  String get monthlyIncome;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @rateCling.
  ///
  /// In en, this message translates to:
  /// **'Rate Cling! App'**
  String get rateCling;

  /// No description provided for @currentBalance.
  ///
  /// In en, this message translates to:
  /// **'Current balance'**
  String get currentBalance;

  /// No description provided for @loginWithAnon.
  ///
  /// In en, this message translates to:
  /// **'Login with Anonymous'**
  String get loginWithAnon;

  /// No description provided for @goalName.
  ///
  /// In en, this message translates to:
  /// **'Goal Name'**
  String get goalName;

  /// No description provided for @target.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get target;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @noConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noConnection;

  /// No description provided for @budgetMustAbove0.
  ///
  /// In en, this message translates to:
  /// **'Monthly budget must above 0'**
  String get budgetMustAbove0;

  /// No description provided for @invalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Invalid amount'**
  String get invalidAmount;

  /// No description provided for @incomeMustAbove0.
  ///
  /// In en, this message translates to:
  /// **'Monthly income must above 0'**
  String get incomeMustAbove0;

  /// No description provided for @pleaseSelectCategories.
  ///
  /// In en, this message translates to:
  /// **'Please select categories'**
  String get pleaseSelectCategories;

  /// No description provided for @pleaseFillAmount.
  ///
  /// In en, this message translates to:
  /// **'Please fill amount, above 0'**
  String get pleaseFillAmount;

  /// No description provided for @pleaseFillName.
  ///
  /// In en, this message translates to:
  /// **'Please fill name'**
  String get pleaseFillName;

  /// No description provided for @pleaseSelectLogo.
  ///
  /// In en, this message translates to:
  /// **'Please select Logo'**
  String get pleaseSelectLogo;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// No description provided for @wantLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure want to logout? Make sure backup your data before logout.'**
  String get wantLogout;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @jan.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get jan;

  /// No description provided for @feb.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get feb;

  /// No description provided for @mar.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get mar;

  /// No description provided for @apr.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get apr;

  /// No description provided for @jun.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get jun;

  /// No description provided for @jul.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get jul;

  /// No description provided for @aug.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get aug;

  /// No description provided for @sept.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get sept;

  /// No description provided for @oct.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get oct;

  /// No description provided for @nov.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get nov;

  /// No description provided for @dec.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get dec;

  /// No description provided for @emailEmpty.
  ///
  /// In en, this message translates to:
  /// **'Email empty'**
  String get emailEmpty;

  /// No description provided for @nameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Name empty, must above 4 characters'**
  String get nameEmpty;

  /// No description provided for @goVerify.
  ///
  /// In en, this message translates to:
  /// **'Please verify email for backup feature'**
  String get goVerify;

  /// No description provided for @changeEmailVerifyDialog.
  ///
  /// In en, this message translates to:
  /// **'You will change your email. After changing your email, please verify your email again.'**
  String get changeEmailVerifyDialog;

  /// No description provided for @changingEmail.
  ///
  /// In en, this message translates to:
  /// **'Email Changing'**
  String get changingEmail;

  /// No description provided for @changingPass.
  ///
  /// In en, this message translates to:
  /// **'Password Changing'**
  String get changingPass;

  /// No description provided for @enterGoal.
  ///
  /// In en, this message translates to:
  /// **'Enter Goal'**
  String get enterGoal;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get or;

  /// No description provided for @changePassVerifyDialog.
  ///
  /// In en, this message translates to:
  /// **'You will change your password. Please check an email'**
  String get changePassVerifyDialog;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @period.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get period;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @byDay.
  ///
  /// In en, this message translates to:
  /// **'By Day'**
  String get byDay;

  /// No description provided for @byMonth.
  ///
  /// In en, this message translates to:
  /// **'By Month'**
  String get byMonth;

  /// No description provided for @byYear.
  ///
  /// In en, this message translates to:
  /// **'By Year'**
  String get byYear;

  /// No description provided for @selectDateRange.
  ///
  /// In en, this message translates to:
  /// **'Select a date range'**
  String get selectDateRange;

  /// No description provided for @selectYear.
  ///
  /// In en, this message translates to:
  /// **'Select year'**
  String get selectYear;

  /// No description provided for @detail.
  ///
  /// In en, this message translates to:
  /// **'Detail'**
  String get detail;

  /// No description provided for @thisYear.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get thisYear;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month '**
  String get thisMonth;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @warningTotalBalance.
  ///
  /// In en, this message translates to:
  /// **'Your total expenses have exceeded total income'**
  String get warningTotalBalance;

  /// No description provided for @alertTotalBalance.
  ///
  /// In en, this message translates to:
  /// **'Warning - Total Balance'**
  String get alertTotalBalance;

  /// No description provided for @warningMonthlyBudget.
  ///
  /// In en, this message translates to:
  /// **'Your expenses have exceeded your set monthly budget'**
  String get warningMonthlyBudget;

  /// No description provided for @alertMonthlyBudget.
  ///
  /// In en, this message translates to:
  /// **'Warning - Monthly Budget'**
  String get alertMonthlyBudget;

  /// No description provided for @warningCurrentBalance.
  ///
  /// In en, this message translates to:
  /// **'This month, your expenses have exceeded your income'**
  String get warningCurrentBalance;

  /// No description provided for @alertCurrentBalance.
  ///
  /// In en, this message translates to:
  /// **'Warning - Balance this month'**
  String get alertCurrentBalance;

  /// No description provided for @alert.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get alert;

  /// No description provided for @markReadAll.
  ///
  /// In en, this message translates to:
  /// **'Mark read all'**
  String get markReadAll;

  /// No description provided for @lastBackup.
  ///
  /// In en, this message translates to:
  /// **'Last backup:'**
  String get lastBackup;

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get confirmLogout;

  /// No description provided for @continueLogout.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLogout;

  /// No description provided for @backupFound.
  ///
  /// In en, this message translates to:
  /// **'Backup Found'**
  String get backupFound;

  /// No description provided for @useThisBackup.
  ///
  /// In en, this message translates to:
  /// **'Restore this backup?'**
  String get useThisBackup;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @backupForDialog.
  ///
  /// In en, this message translates to:
  /// **'Data backup'**
  String get backupForDialog;

  /// No description provided for @backupForDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Do you want to backup data? Previous data backup will be overwritten.'**
  String get backupForDialogContent;

  /// No description provided for @totalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total balance'**
  String get totalBalance;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data :('**
  String get noData;

  /// No description provided for @savingDate.
  ///
  /// In en, this message translates to:
  /// **'Saving date'**
  String get savingDate;

  /// No description provided for @chooseLogo.
  ///
  /// In en, this message translates to:
  /// **'Choose logo'**
  String get chooseLogo;

  /// No description provided for @collectedHigher.
  ///
  /// In en, this message translates to:
  /// **'The savings target is not less than what has been accumulated'**
  String get collectedHigher;

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this?'**
  String get deleteConfirmation;

  /// No description provided for @amountExceedsRemainingSaving.
  ///
  /// In en, this message translates to:
  /// **'The amount exceeds the remaining savings'**
  String get amountExceedsRemainingSaving;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @collected.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get collected;

  /// No description provided for @addSaving.
  ///
  /// In en, this message translates to:
  /// **'Add saving'**
  String get addSaving;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @transaction.
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get transaction;

  /// No description provided for @emptyTransaction.
  ///
  /// In en, this message translates to:
  /// **'Empty Transaction'**
  String get emptyTransaction;

  /// No description provided for @noMore.
  ///
  /// In en, this message translates to:
  /// **'No more ~~'**
  String get noMore;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @recurringEveryDate.
  ///
  /// In en, this message translates to:
  /// **'Recurring every date:'**
  String get recurringEveryDate;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
