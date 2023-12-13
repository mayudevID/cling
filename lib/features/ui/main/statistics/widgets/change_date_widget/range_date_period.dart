import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/language_currency/lang_export.dart';

import 'package:cling/features/ui/main/statistics/bloc/statistics_bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../../../resources/gen/assets.gen.dart';
import '../../../../../../resources/gen/fonts.gen.dart';
import '../../../../language_currency/lang_currency_bloc.dart';
import 'convert_enum_to_detail_date.dart';

Widget rangeDatePeriod(BuildContext mainContext) {
  final formatCurr = mainContext.select(
    (LangCurrencyBloc bloc) {
      return bloc.state.selectedLanguage.value.toLanguageTag();
    },
  );

  String dateFormatPeriod(StatisticsState state) {
    DateFormat dateFormat;

    switch (state.dateRangePickerView) {
      case DateRangePickerView.month:
        //* Day
        dateFormat = DateFormat.yMMMMd(formatCurr);
        break;
      case DateRangePickerView.year:
        //* Month
        dateFormat = DateFormat.yMMMM(formatCurr);
        break;
      case DateRangePickerView.decade:
        //* Year
        dateFormat = DateFormat.y(formatCurr);
        break;
      case DateRangePickerView.century:
        //* -
        dateFormat = DateFormat.y(formatCurr);
        break;
    }

    return "${dateFormat.format(state.startDate)} - ${dateFormat.format(state.endDate)}";
  }

  return GestureDetector(
    onTap: () {
      pickDateRangeBottomSheet(mainContext);
    },
    child: Container(
      width: double.infinity,
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
              return (p.startDate != c.startDate) ||
                  (p.endDate != c.endDate) ||
                  (p.dateRangePickerView != c.dateRangePickerView);
            },
            builder: (context, state) {
              return Text(
                dateFormatPeriod(state),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: FontFamily.cabinetGrotesk,
                ),
              );
            },
          ),
          Assets.lib.resources.images.calendar.svg(),
        ],
      ),
    ),
  );
}

void pickDateRangeBottomSheet(BuildContext mainContext) {
  var listDRPV = DateRangePickerView.values.toList(growable: true);
  listDRPV.remove(DateRangePickerView.century);

  showMaterialModalBottomSheet(
    context: mainContext,
    isDismissible: false,
    enableDrag: false,
    duration: const Duration(milliseconds: 200),
    shape: const BeveledRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
    ),
    builder: (context) {
      return BlocProvider.value(
        value: BlocProvider.of<StatisticsBloc>(mainContext),
        child: BlocBuilder<StatisticsBloc, StatisticsState>(
          buildWhen: (p, c) {
            return p.dateRangePickerView != c.dateRangePickerView;
          },
          builder: (context, state) {
            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                color: Colors.white,
              ),
              height: 550.hmea,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.sp),
                    child: Text(
                      AppLocalizations.of(context)!.selectDateRange,
                      style: TextStyle(
                        fontFamily: FontFamily.cabinetGrotesk,
                        color: Colors.black,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      customButton: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFF313131),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 16.hmea,
                          horizontal: 16.wmea,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              convertEnumToDetailDate(
                                context,
                                state.dateRangePickerView,
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: FontFamily.cabinetGrotesk,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Assets
                                .lib.resources.images.fluentChevronDown24Filled
                                .svg(),
                          ],
                        ),
                      ),
                      items: listDRPV.map((item) {
                        return DropdownMenuItem<DateRangePickerView>(
                          value: item,
                          child: Text(
                            convertEnumToDetailDate(context, item),
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: FontFamily.cabinetGrotesk,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                        //}
                      }).toList(),
                      onChanged: (value) async {
                        mainContext
                            .read<StatisticsBloc>()
                            .add(ChangeDateRangePickerView(value!));
                        Navigator.pop(context);
                        await Future.delayed(const Duration(milliseconds: 150));
                        // ignore: use_build_context_synchronously
                        pickDateRangeBottomSheet(mainContext);
                      },
                      dropdownStyleData: const DropdownStyleData(
                        decoration: BoxDecoration(
                          color: Color(0xFF313131),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SfDateRangePicker(
                      onSelectionChanged: (val) {},
                      view: state.dateRangePickerView,
                      allowViewNavigation: false,
                      selectionMode: DateRangePickerSelectionMode.range,
                      initialSelectedRange: PickerDateRange(
                        state.startDate,
                        state.endDate,
                      ),
                      showActionButtons: true,
                      onSubmit: (value) {
                        final val = value as PickerDateRange;
                        mainContext.read<StatisticsBloc>().add(
                              ChangeDateForPeriod(val.startDate, val.endDate),
                            );
                        Navigator.pop(context);
                      },
                      onCancel: () {
                        Navigator.pop(context);
                      },
                      minDate:
                          DateTime.now().subtract(const Duration(days: 3000)),
                      maxDate: DateTime.now(),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
