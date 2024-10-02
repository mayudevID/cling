import 'package:cling/features/model/currency.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../bloc/register_bloc.dart';

Widget dropDownCurrency(BuildContext context) {
  return BlocBuilder<RegisterBloc, RegisterState>(
    builder: (context, state) {
      return DropdownButtonHideUnderline(
        child: DropdownButton2(
          customButton: Container(
            decoration: ShapeDecoration(
              color: const Color(0xFF313131),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 16.h,
              horizontal: 16.w,
            ),
            child: Row(
              children: [
                Text(
                  state.selectedCurrency.longName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.5.sp,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Assets.lib.resources.images.fluentChevronDown24Filled.svg(),
              ],
            ),
          ),
          items: Currency.values
              .map(
                (item) => DropdownMenuItem<Currency>(
                  value: item,
                  child: Text(
                    item.longName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.5.sp,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            context.read<RegisterBloc>().add(ChangeCurrency(value!));
          },
          dropdownStyleData: DropdownStyleData(
            width: 390.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFF313131),
            ),
          ),
        ),
      );
    },
  );
}
