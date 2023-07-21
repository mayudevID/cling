import 'package:cling/core/route.dart';
import 'package:cling/core/utils.dart';
import 'package:cling/resources/gen/fonts.gen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return const MaterialApp(
          onGenerateRoute: RouteGen.generateRoute,
          debugShowCheckedModeBanner: false,
        );
        // return MaterialApp(
        //   home: MyHomePage(),
        // );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            customButton: const Icon(
              Icons.abc,
              size: 46,
              color: Colors.red,
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
              offset: const Offset(0, 8),
            ),
            menuItemStyleData: MenuItemStyleData(
              padding: EdgeInsets.symmetric(
                horizontal: Utils.w(16).w,
                vertical: Utils.h(16).h,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;
}

abstract class MenuItems {
  static const List<MenuItem> firstItems = [home, share, settings];
  static const List<MenuItem> secondItems = [logout];

  static const home = MenuItem(text: 'Home', icon: Icons.home);
  static const share = MenuItem(text: 'Share', icon: Icons.share);
  static const settings = MenuItem(text: 'Settings', icon: Icons.settings);
  static const logout = MenuItem(text: 'Log Out', icon: Icons.logout);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(
          item.icon,
          color: Colors.white,
          size: 22,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.5.sp,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.home:
        //Do something
        break;
      case MenuItems.settings:
        //Do something
        break;
      case MenuItems.share:
        //Do something
        break;
      case MenuItems.logout:
        //Do something
        break;
    }
  }
}
