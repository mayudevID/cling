import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';

import '../../../../resources/gen/assets.gen.dart';
import '../../../../resources/gen/fonts.gen.dart';
import '../../../model/currency.dart';
import '../../language_currency/lang_currency_bloc.dart';
import '../../language_currency/lang_export.dart';
import "dart:math" as math;

void currencyBottomSheet(BuildContext context) {
  ListView currencyList(LangCurrencyState state) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: Currency.values.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            context.read<LangCurrencyBloc>().add(
                  ChangeCurrency(
                    selectedCurrency: Currency.values[index],
                  ),
                );
            await Future.delayed(
              const Duration(milliseconds: 300),
            ).then((value) {
              Navigator.pop(context);
            });
          },
          child: Container(
            padding: EdgeInsets.all(16.hmea),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Currency.values[index] == state.selectedCurrency
                    ? Colors.black
                    : Colors.grey[300]!,
                width:
                    Currency.values[index] == state.selectedCurrency ? 1.5 : 1,
              ),
            ),
            child: Text(
              Currency.values[index].longName,
              style: const TextStyle(
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
      separatorBuilder: (_, idx) => SizedBox(height: 8.hmea),
    );
  }

  ;

  showMaterialModalBottomSheet(
    context: context,
    enableDrag: false,
    isDismissible: false,
    duration: const Duration(milliseconds: 200),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    builder: (_) {
      return Container(
        height: 650.hmea,
        padding: EdgeInsets.only(top: 24.hmea, left: 24.wmea, right: 24.wmea),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.currency,
                  style: TextStyle(
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontSize: 10.sp,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Transform.rotate(
                    angle: math.pi / 4,
                    child: Assets.lib.resources.images.plus.svg(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.hmea),
            Expanded(
              child: MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: BlocBuilder<LangCurrencyBloc, LangCurrencyState>(
                  builder: (context, state) => currencyList(state),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
