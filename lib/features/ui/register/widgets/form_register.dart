import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../resources/gen/assets.gen.dart';
import '../../../../resources/gen/fonts.gen.dart';
import '../../language_currency/lang_currency_bloc.dart';
import '../../language_currency/lang_export.dart';
import 'currency_bottom_sheet.dart';
import 'tag_name_reg.dart';
import 'text_field_con_pass_reg.dart';
import 'text_field_email_reg.dart';
import 'text_field_name_reg.dart';
import 'text_field_pass_reg.dart';

List<Widget> formRegister(BuildContext context) {
  return [
    TagNameReg(name: AppLocalizations.of(context)!.name),
    const SizedBox(height: 8),
    const TextFieldNameReg(),
    const SizedBox(height: 16),
    TagNameReg(name: AppLocalizations.of(context)!.email),
    const SizedBox(height: 8),
    const TextFieldEmailReg(),
    const SizedBox(height: 16),
    TagNameReg(name: AppLocalizations.of(context)!.password),
    const SizedBox(height: 8),
    const TextFieldPassReg(),
    const SizedBox(height: 16),
    TagNameReg(name: AppLocalizations.of(context)!.confirmPassword),
    const SizedBox(height: 8),
    const TextFieldConPassReg(),
    const SizedBox(height: 16),
    TagNameReg(name: AppLocalizations.of(context)!.currency),
    const SizedBox(height: 8),
    GestureDetector(
      onTap: () => currencyBottomSheet(context),
      child: Container(
        decoration: ShapeDecoration(
          color: const Color(0xFF313131),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            BlocBuilder<LangCurrencyBloc, LangCurrencyState>(
              buildWhen: (p, c) {
                return p.selectedCurrency.longName !=
                    c.selectedCurrency.longName;
              },
              builder: (context, state) {
                return Text(
                  state.selectedCurrency.longName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
            const Spacer(),
            Assets.lib.resources.images.fluentChevronDown24Filled.svg(),
          ],
        ),
      ),
    ),
  ];
}
