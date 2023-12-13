import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/language_currency/lang_export.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../resources/gen/assets.gen.dart';
import '../../../../../../resources/gen/fonts.gen.dart';
import '../../bloc/statistics_bloc.dart';
import 'convert_enum_to_detail_date.dart';

Widget changeRangeDate(BuildContext context) {
  String setName(RangeDate rangeDate) {
    var appContext = AppLocalizations.of(context)!;
    switch (rangeDate) {
      case RangeDate.daily:
        return appContext.daily;
      case RangeDate.period:
        return appContext.period;
      case RangeDate.monthy:
        return appContext.monthly;
      case RangeDate.yearly:
        return appContext.yearly;
    }
  }

  return DropdownButtonHideUnderline(
    child: DropdownButton2(
      customButton: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(14.wmea),
        decoration: BoxDecoration(
          color: const Color(0x3D787880),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocBuilder<StatisticsBloc, StatisticsState>(
              buildWhen: (p, c) {
                return (p.rangeDate.name != c.rangeDate.name) ||
                    (p.dateRangePickerView.name != c.dateRangePickerView.name);
              },
              builder: (context, state) {
                return Text(
                  '${setName(state.rangeDate)} - ${(state.rangeDate == RangeDate.period) ? convertEnumToDetailDate(context, state.dateRangePickerView) : ""}',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontSize: 11.sp,
                  ),
                );
              },
            ),
            Assets.lib.resources.images.fluentChevronDown24Filled.svg(),
          ],
        ),
      ),
      onChanged: (value) {
        context.read<StatisticsBloc>().add(ChangeRangeDate(value!));
      },
      items: RangeDate.values
          .map(
            (e) => DropdownMenuItem<RangeDate>(
              value: e,
              child: Text(
                setName(e),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: FontFamily.cabinetGrotesk,
                ),
              ),
            ),
          )
          .toList(),
      dropdownStyleData: DropdownStyleData(
        width: 387.wmea,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFF313131),
        ),
      ),
    ),
  );
}
