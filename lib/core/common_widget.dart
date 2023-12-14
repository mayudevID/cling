// ignore_for_file: must_be_immutable

import 'package:cling/core/utils.dart';
import 'package:cling/resources/gen/assets.gen.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';
import '../features/model/language.dart';
import '../features/ui/language_currency/lang_currency_bloc.dart';
import '../features/ui/language_currency/lang_export.dart';
import '../injection.dart';
import '../resources/gen/fonts.gen.dart';
import 'dart:math' as math;

///* Pink Button
class PinkButton extends StatelessWidget {
  const PinkButton({
    super.key,
    required this.onTap,
    required this.name,
  });
  final Function() onTap;
  final String name;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 380.wmea,
      height: 57.hmea,
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            const Color(0xFFF599DA),
          ),
          overlayColor: MaterialStateProperty.all(
            const Color(0xFFF06AC9),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF101010),
            fontSize: 11.5.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

///* Black Button
class BlackButton extends StatelessWidget {
  const BlackButton({
    super.key,
    required this.name,
    required this.onTap,
  });
  final String name;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 390.wmea,
      height: 57.wmea,
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            const Color(0xFF101010),
          ),
          overlayColor: null,
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFFF599DA),
            fontSize: 11.5.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

///* Loading Auth
void loadingAuth(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => PopScope(
      canPop: false,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(32),
          child: Lottie.asset(
            "lib/resources/anim/loading_carga.json",
            animate: true,
            repeat: true,
            width: 48.wmea,
            height: 48.wmea,
            frameRate: FrameRate.max,
          ),
        ),
      ),
    ),
  );
}

///* Error Snackbar
void errorSnackbar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: Colors.red.shade400,
        content: Text(
          msg,
          style: TextStyle(
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w600,
            fontSize: 11.5.sp,
          ),
        ),
      ),
    );
}

///* Error Toast
void errorToast(String msg) {
  getIt<FToast>()
    ..removeCustomToast()
    ..showToast(
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(milliseconds: 3500),
      child: Container(
        margin: EdgeInsets.only(bottom: 111.hmea),
        padding: EdgeInsets.all(10.wmea),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: const Color(0xff313131),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Assets.lib.resources.images.dismiss.svg(),
            SizedBox(
              width: 8.wmea,
            ),
            Text(
              msg,
              style: TextStyle(
                fontFamily: FontFamily.cabinetGrotesk,
                fontSize: 9.5.sp,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        ),
      ),
    );
}

///* NominalMoneyFormatter
class NominalMoneyFormatter extends StatelessWidget {
  NominalMoneyFormatter({
    super.key,
    required this.textStyle,
    required this.amount,
    required this.decimalDigits,
    required this.isWithName,
    this.textAlign,
  });
  final TextStyle textStyle;
  final num amount;
  final int decimalDigits;
  final bool isWithName;
  TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    var data = context.watch<LangCurrencyBloc>().state.selectedCurrency;
    return Text(
      NumberFormat.currency(
        locale: data.value.toLanguageTag(),
        decimalDigits: decimalDigits,
        customPattern: '\u00a4###,###.00',
        name: (isWithName) ? "${data.name} " : "",
      ).format(amount / 100.0),
      style: textStyle,
      textAlign: textAlign,
    );
  }
}

///* Choose Language Bottomsheet
Future<void> showBottomSheetChooseLang(BuildContext context) async {
  ListView listLanguage(LangCurrencyState state) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: Language.values.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () async {
            context.read<LangCurrencyBloc>().add(
                  ChangeLanguage(
                    selectedLanguage: Language.values[index],
                  ),
                );
            await Future.delayed(
              const Duration(milliseconds: 300),
            ).then((value) {
              Navigator.pop(context);
            });
          },
          leading: Text(
            Language.values[index].text.substring(
              0,
              Language.values[index].text.indexOf(" "),
            ),
            style: TextStyle(
              fontSize: 11.sp,
              fontFamily: FontFamily.cabinetGrotesk,
            ),
          ),
          title: Text(
            Language.values[index].text.substring(
              Language.values[index].text.indexOf(" ") + 1,
            ),
            style: const TextStyle(
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: Language.values[index] == state.selectedLanguage
              ? const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.black,
                )
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: Language.values[index] == state.selectedLanguage
                ? const BorderSide(
                    color: Colors.black,
                    width: 1.5,
                  )
                : BorderSide(color: Colors.grey[300]!),
          ),
          tileColor: Language.values[index] == state.selectedLanguage
              ? Colors.black.withOpacity(0.05)
              : null,
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 18.hmea,
        );
      },
    );
  }

  showMaterialModalBottomSheet(
    duration: const Duration(milliseconds: 200),
    context: context,
    enableDrag: false,
    isDismissible: false,
    builder: (context) {
      return BlocBuilder<LangCurrencyBloc, LangCurrencyState>(
        builder: (context, state) {
          return Container(
            padding: EdgeInsets.all(24.wmea),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.chooseLang,
                      style: TextStyle(
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontSize: 10.sp,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Transform.rotate(
                        angle: math.pi / 4,
                        child: Assets.lib.resources.images.plus.svg(),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.hmea,
                ),
                MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: BlocBuilder<LangCurrencyBloc, LangCurrencyState>(
                    builder: (context, state) {
                      return listLanguage(state);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

///* App Bar Profile
Widget appBarProfile({
  required BuildContext context,
  required String title,
  required String textButton,
  required Function() onTapButton,
}) {
  return Container(
    margin: EdgeInsets.only(top: 16.hmea),
    child: Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Assets.lib.resources.images.fluentChevronLeft24Filled.svg(),
        ),
        SizedBox(width: 8.wmea),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.5.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        if (title != "Edit Profile") ...[
          GestureDetector(
            onTap: onTapButton,
            child: Container(
              width: 74.wmea,
              height: 36.hmea,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: ShapeDecoration(
                color: const Color(0xFFF599DA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                textButton,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF101010),
                  fontSize: 10.sp,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          )
        ]
      ],
    ),
  );
}
