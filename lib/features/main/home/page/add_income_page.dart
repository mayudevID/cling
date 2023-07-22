import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils.dart';
import '../../../../main.dart';
import '../../../../resources/gen/assets.gen.dart';
import '../../../../resources/gen/fonts.gen.dart';

class AddIncomePage extends StatelessWidget {
  const AddIncomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Utils.w(20).w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: Utils.h(16).h,
          ),
          Text(
            'Add Income',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: Utils.h(24).h,
          ),
          Text(
            'Date',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(
            height: Utils.h(8).h,
          ),
          Container(
            decoration: ShapeDecoration(
              color: const Color(0xFF313131),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            padding: EdgeInsets.symmetric(
              vertical: Utils.h(16).h,
              horizontal: Utils.w(16).w,
            ),
            child: Row(
              children: [
                Text(
                  'dd/mm/yyyy',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.5.sp,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Assets.lib.resources.images.calendar.svg(),
              ],
            ),
          ),
          SizedBox(
            height: Utils.h(16).h,
          ),
          Text(
            'Income Source',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(
            height: Utils.h(8).h,
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              customButton: Container(
                decoration: ShapeDecoration(
                  color: const Color(0xFF313131),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: Utils.h(16).h,
                  horizontal: Utils.w(16).w,
                ),
                child: Row(
                  children: [
                    Text(
                      "Select Categories",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.5.sp,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Assets.lib.resources.images.fluentChevronDown24Filled.svg(),
                  ],
                ),
              ),
              items: [
                ...MenuItems.firstItems.map(
                  (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
              ],
              onChanged: (value) {
                MenuItems.onChanged(context, value!);
              },
              dropdownStyleData: DropdownStyleData(
                width: Utils.w(390).w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF313131),
                ),
              ),
            ),
          ),
          SizedBox(
            height: Utils.h(16).h,
          ),
          Text(
            'Description (Optional)',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(
            height: Utils.h(8).h,
          ),
          Container(
            decoration: ShapeDecoration(
              color: const Color(0xFF313131),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            padding: EdgeInsets.symmetric(
              vertical: Utils.h(16).h,
              horizontal: Utils.w(16).w,
            ),
            child: TextFormField(
              onChanged: (value) {},
              cursorColor: Colors.white,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.5.sp,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration.collapsed(
                hintText: 'Items',
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
            height: Utils.h(16).h,
          ),
          Text(
            'Amount (IDR)',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(
            height: Utils.h(8).h,
          ),
          Container(
            decoration: ShapeDecoration(
              color: const Color(0xFF313131),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            padding: EdgeInsets.symmetric(
              vertical: Utils.h(16).h,
              horizontal: Utils.w(16).w,
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
                  width: Utils.w(10).w,
                ),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      // if (value.trim().isNotEmpty) {
                      //   try {
                      //     final result = double.parse(value);
                      //   } on FormatException catch (e) {
                      //     print(e);
                      //   }
                      // }
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
            height: Utils.h(40).h,
          ),
          SizedBox(
            width: Utils.w(390).w,
            height: Utils.h(57).h,
            child: ElevatedButton(
              onPressed: () {},
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
                "Submit",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF101010),
                  fontSize: 13.5.sp,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
