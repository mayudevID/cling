import '../../../model/currency.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
            child: Row(
              children: [
                Text(
                  state.selectedCurrency.longName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.5,
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
                (item) => DropdownItem<Currency>(
                  value: item,
                  child: Text(
                    item.longName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.5,
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
            width: 390,
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
