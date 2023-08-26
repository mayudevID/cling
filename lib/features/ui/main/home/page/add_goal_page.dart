// ignore_for_file: prefer_const_constructors

import 'package:cling/core/common_widget.dart';
import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/language_currency/lang_export.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import '../../bloc/main_bloc.dart';
import '../bloc/home_bloc.dart';

class AddGoalPage extends StatelessWidget {
  const AddGoalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.wmea),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 16.hmea,
          ),
          Text(
            "Add Goal",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 32.hmea,
          ),
          Center(
            child: Stack(
              children: const [],
            ),
          ),
          SizedBox(
            height: 24.hmea,
          ),
          Text(
            "Goals name",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(
            height: 8.hmea,
          ),
          Container(
            decoration: ShapeDecoration(
              color: const Color(0xFF313131),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 16.hmea,
              horizontal: 16.wmea,
            ),
            child: TextFormField(
              onChanged: (value) {
                //context.read<HomeBloc>().add(SetDescOrItem(value));
              },
              cursorColor: Colors.white,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.5.sp,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration.collapsed(
                hintText: "Enter Goal",
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.5.sp,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16.hmea,
          ),
          Text(
            "Goals name",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(
            height: 8.hmea,
          ),
          Container(
            decoration: ShapeDecoration(
              color: const Color(0xFF313131),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 16.hmea,
              horizontal: 16.wmea,
            ),
            child: Row(
              children: [
                Text(
                  'IDR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(
                  width: 10.wmea,
                ),
                Expanded(
                  child: TextFormField(
                    inputFormatters: [
                      CurrencyTextInputFormatter(
                        locale: "id",
                        symbol: "",
                        decimalDigits: 0,
                      ),
                    ],
                    enableInteractiveSelection: false,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      //context.read<HomeBloc>().add(SetAmountInput(value));
                    },
                    cursorColor: Colors.white,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.5.sp,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration.collapsed(
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.5.sp,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 32.hmea,
          ),
          PinkButton(
            onTap: () {},
            name: AppLocalizations.of(context)!.submit,
          ),
          SizedBox(
            height: 16.hmea,
          ),
          BlackButton(
            onTap: () {
              context.read<MainBloc>().add(
                    const TabChange(
                      tabIndex: 0,
                    ),
                  );
              context.read<HomeBloc>().add(ClearDataForm());
            },
            name: AppLocalizations.of(context)!.cancel,
          ),
        ],
      ),
    );
  }
}
