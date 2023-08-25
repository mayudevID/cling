import 'package:cling/core/common_widget.dart';
import 'package:cling/core/utils.dart';
import 'package:cling/resources/gen/assets.gen.dart';
import 'package:cling/resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';

List<Widget> listAccountSettings() {
  return [
    Row(
      children: [
        SizedBox(
          width: 8.wmea,
        ),
        Assets.lib.resources.images.money.svg(),
        SizedBox(
          width: 10.wmea,
        ),
        Text(
          'Monthly Budget',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        NominalMoneyFormatter(
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w400,
          ),
          amount: 5000000,
          decimalDigits: 0,
          isWithName: true,
        ),
        SizedBox(
          width: 10.wmea,
        ),
        Assets.lib.resources.images.chevronRight16.svg(),
        SizedBox(
          width: 8.wmea,
        ),
      ],
    ),
    Row(
      children: [
        SizedBox(
          width: 8.wmea,
        ),
        Assets.lib.resources.images.moneyHand.svg(),
        SizedBox(
          width: 10.wmea,
        ),
        Text(
          'Monthly Income',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        NominalMoneyFormatter(
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w400,
          ),
          amount: 5000000,
          decimalDigits: 0,
          isWithName: true,
        ),
        SizedBox(
          width: 10.wmea,
        ),
        Assets.lib.resources.images.globe.svg(),
        SizedBox(
          width: 8.wmea,
        ),
      ],
    ),
    Row(
      children: [
        SizedBox(
          width: 8.wmea,
        ),
        Assets.lib.resources.images.money.svg(),
        SizedBox(
          width: 10.wmea,
        ),
        Text(
          'Change Language',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Assets.lib.resources.images.chevronRight16.svg(),
        SizedBox(
          width: 8.wmea,
        ),
      ],
    ),
  ];
}
