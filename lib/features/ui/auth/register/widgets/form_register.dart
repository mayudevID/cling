import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import '../../../language_currency/lang_export.dart';
import 'drop_down_currency.dart';
import 'tag_name_reg.dart';
import 'text_field_con_pass_reg.dart';
import 'text_field_email_reg.dart';
import 'text_field_name_reg.dart';
import 'text_field_pass_reg.dart';

List<Widget> formRegister(BuildContext context) {
  return [
    TagNameReg(name: AppLocalizations.of(context)!.name),
    SizedBox(
      height: 8.hmea,
    ),
    textFieldNameReg(context),
    SizedBox(
      height: 16.hmea,
    ),
    TagNameReg(name: AppLocalizations.of(context)!.email),
    SizedBox(
      height: 8.hmea,
    ),
    textFieldEmailReg(context),
    SizedBox(
      height: 16.hmea,
    ),
    TagNameReg(name: AppLocalizations.of(context)!.password),
    SizedBox(
      height: 8.hmea,
    ),
    textFieldPassReg(context),
    SizedBox(
      height: 16.hmea,
    ),
    TagNameReg(name: AppLocalizations.of(context)!.confirmPassword),
    SizedBox(
      height: 8.hmea,
    ),
    textFieldConPassReg(context),
    SizedBox(
      height: 16.hmea,
    ),
    TagNameReg(name: "Currency"),
    SizedBox(
      height: 8.hmea,
    ),
    dropDownCurrency(context),
  ];
}
