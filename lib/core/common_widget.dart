// ignore_for_file: must_be_immutable, use_build_context_synchronously
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../features/model/language.dart';
import '../features/ui/language_currency/lang_currency_bloc.dart';
import '../features/ui/language_currency/lang_export.dart';
import '../injection.dart';
import '../resources/gen/assets.gen.dart';
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
      width: 380,
      height: 57,
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            const Color(0xFFF599DA),
          ),
          overlayColor: WidgetStateProperty.all(
            const Color(0xFFF06AC9),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF101010),
            fontSize: 16,
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
      width: 390,
      height: 57,
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            const Color(0xFF101010),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFFF599DA),
            fontSize: 11.5,
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
            width: 48,
            height: 48,
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
          style: const TextStyle(
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w600,
            fontSize: 10,
          ),
        ),
      ),
    );
}

///* Success Snackbar
void successSnackbar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: Colors.red.shade400,
        content: Text(
          msg,
          style: const TextStyle(
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w600,
            fontSize: 10,
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
        margin: const EdgeInsets.only(bottom: 111),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: const Color(0xff313131),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Assets.lib.resources.images.dismiss.svg(),
            const SizedBox(width: 8),
            Text(
              msg,
              style: const TextStyle(
                fontFamily: FontFamily.cabinetGrotesk,
                fontSize: 9.5,
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
    required this.isWithName,
    this.textAlign,
  });
  final TextStyle textStyle;
  final num amount;
  final bool isWithName;
  TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final data = context.watch<LangCurrencyBloc>().state.selectedCurrency;
    String formattedAmount = NumberFormat.currency(
      locale: data.value.toLanguageTag(),
      decimalDigits: (amount % 1 == 0) ? 0 : 2,
      name: (isWithName) ? "${data.name} " : "",
    ).format(amount);
    if ((amount % 1 != 0) &&
        (formattedAmount[formattedAmount.length - 1] == "0")) {
      formattedAmount = formattedAmount.substring(
        0,
        formattedAmount.length - 1,
      );
    }
    return Text(formattedAmount, style: textStyle, textAlign: textAlign);
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
            style: const TextStyle(
              fontSize: 11,
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
                    width: 1.5,
                  )
                : BorderSide(color: Colors.grey[300]!),
          ),
          tileColor: Language.values[index] == state.selectedLanguage
              ? Colors.black.withValues(alpha: 0.05)
              : null,
        );
      },
      separatorBuilder: (_, idx) => const SizedBox(height: 18),
    );
  }

  showMaterialModalBottomSheet(
    duration: const Duration(milliseconds: 200),
    context: context,
    enableDrag: false,
    isDismissible: false,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.chooseLang,
                  style: const TextStyle(
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontSize: 10,
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
            const SizedBox(height: 16),
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
}

///* App Bar Profile
Widget appBarProfile({
  required BuildContext context,
  required String title,
  required String textButton,
  required Function() onTapButton,
}) {
  return Container(
    margin: const EdgeInsets.only(top: 16),
    child: Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Assets.lib.resources.images.fluentChevronLeft24Filled.svg(),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14.5,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        if (title != "Edit Profile") ...[
          GestureDetector(
            onTap: onTapButton,
            child: Container(
              width: 74,
              height: 36,
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
                style: const TextStyle(
                  color: Color(0xFF101010),
                  fontSize: 10,
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

///* Dialog Delete
Future<bool> dialogDelete(BuildContext context) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: Colors.white,
          ),
          padding: const EdgeInsets.only(
            top: 18,
            left: 18,
            right: 18,
            bottom: 18,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.deleteConfirmation,
                style: const TextStyle(
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontSize: 10,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context, true);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Align(
                        child: Text(
                          AppLocalizations.of(context)!.yes,
                          style: const TextStyle(
                            fontFamily: FontFamily.cabinetGrotesk,
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context, false);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Align(
                        child: Text(
                          AppLocalizations.of(context)!.no,
                          style: const TextStyle(
                            fontFamily: FontFamily.cabinetGrotesk,
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
