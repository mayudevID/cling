import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../resources/gen/assets.gen.dart';
import '../../../../../../resources/gen/fonts.gen.dart';
import '../../../main_widget/convert_enum_to_detail_date.dart';
import '../../../main_widget/enum_range_date.dart';
import '../../../main_widget/set_name.dart';
import '../../bloc/stats_detail_bloc.dart';

Widget changeRangeDateByCategory(BuildContext context) {
  String periodCheck(StatsDetailState state) {
    return (state.rangeDate == RangeDate.period)
        ? "(${convertEnumToDetailDate(context, state.dateRangePickerView)})"
        : "";
  }

  return DropdownButtonHideUnderline(
    child: DropdownButton2(
      customButton: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0x3D787880),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocBuilder<StatsDetailBloc, StatsDetailState>(
              buildWhen: (p, c) {
                return (p.rangeDate.name != c.rangeDate.name) ||
                    (p.dateRangePickerView.name != c.dateRangePickerView.name);
              },
              builder: (context, state) {
                return Text(
                  '${setName(context, state.rangeDate)} ${periodCheck(state)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontSize: 11,
                  ),
                );
              },
            ),
            Assets.lib.resources.images.fluentChevronDown24Filled.svg(),
          ],
        ),
      ),
      onChanged: (value) {
        context.read<StatsDetailBloc>().add(ChangeRangeDate(value!));
      },
      items: RangeDate.values
          .map(
            (e) => DropdownItem<RangeDate>(
              value: e,
              child: Text(
                setName(context, e),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: FontFamily.cabinetGrotesk,
                ),
              ),
            ),
          )
          .toList(),
      dropdownStyleData: DropdownStyleData(
        width: 387,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFF313131),
        ),
      ),
    ),
  );
}
