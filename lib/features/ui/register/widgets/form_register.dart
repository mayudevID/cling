import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    SizedBox(height: 8.h),
    const TextFieldNameReg(),
    SizedBox(height: 16.h),
    TagNameReg(name: AppLocalizations.of(context)!.email),
    SizedBox(height: 8.h),
    const TextFieldEmailReg(),
    SizedBox(height: 16.h),
    TagNameReg(name: AppLocalizations.of(context)!.password),
    SizedBox(height: 8.h),
    const TextFieldPassReg(),
    SizedBox(height: 16.h),
    TagNameReg(name: AppLocalizations.of(context)!.confirmPassword),
    SizedBox(height: 8.h),
    const TextFieldConPassReg(),
    SizedBox(height: 16.h),
    TagNameReg(name: AppLocalizations.of(context)!.currency),
    SizedBox(height: 8.h),
    GestureDetector(
      onTap: () => currencyBottomSheet(context),
      child: Container(
        decoration: ShapeDecoration(
          color: const Color(0xFF313131),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
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
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.5.sp,
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
