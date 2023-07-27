import 'package:cling/core/utils.dart';
import 'package:cling/resources/gen/assets.gen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../main.dart';
import '../../../../../resources/gen/fonts.gen.dart';

class AddExpensePage extends StatelessWidget {
  const AddExpensePage({super.key});

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
            'Add Expenses',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 24.hmea,
          ),
          Text(
            'Purchase Date',
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
            height: 16.hmea,
          ),
          Text(
            'Categories',
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
                  vertical: 16.hmea,
                  horizontal: 16.wmea,
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
                width: 390.wmea,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF313131),
                ),
                offset: const Offset(0, 8),
              ),
              menuItemStyleData: MenuItemStyleData(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.wmea,
                  vertical: 16.hmea,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16.hmea,
          ),
          Text(
            'Items',
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
            height: 16.hmea,
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
                    keyboardType: TextInputType.number,
                    onChanged: (value) {},
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
            height: 40.hmea,
          ),
          SizedBox(
            width: 390.wmea,
            height: 57.hmea,
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
