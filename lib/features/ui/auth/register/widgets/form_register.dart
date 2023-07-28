import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';

import 'tag_name_reg.dart';
import 'text_field_con_pass_reg.dart';
import 'text_field_email_reg.dart';
import 'text_field_name_reg.dart';
import 'text_field_pass_reg.dart';

List<Widget> formRegister(BuildContext context) {
  return [
    const TagNameReg(name: "Name"),
    SizedBox(
      height: 8.hmea,
    ),
    textFieldNameReg(context),
    SizedBox(
      height: 16.hmea,
    ),
    const TagNameReg(name: "Email"),
    SizedBox(
      height: 8.hmea,
    ),
    textFieldEmailReg(context),
    SizedBox(
      height: 16.hmea,
    ),
    const TagNameReg(name: "Password"),
    SizedBox(
      height: 8.hmea,
    ),
    textFieldPassReg(context),
    SizedBox(
      height: 16.hmea,
    ),
    const TagNameReg(name: 'Confirm Password'),
    SizedBox(
      height: 8.hmea,
    ),
    textFieldConPassReg(context),
  ];
}
