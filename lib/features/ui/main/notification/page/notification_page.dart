import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/language_currency/lang_export.dart';
import 'package:cling/features/ui/main/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../bloc/notification_bloc.dart';
import '../widgets/notification_widget.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    BlocProvider.of<NotificationBloc>(MainPage.navKeyMain.currentContext!)
        .add(GetNotificationList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        BlocProvider.of<NotificationBloc>(MainPage.navKeyMain.currentContext!)
            .add(GetNotificationList());
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.wmea),
            child: Column(
              children: [
                SizedBox(height: 16.hmea),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Assets
                          .lib.resources.images.fluentChevronLeft24Filled
                          .svg(),
                    ),
                    SizedBox(width: 16.wmea),
                    Text(
                      AppLocalizations.of(context)!.notification,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.hmea),
                Expanded(
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: BlocBuilder<NotificationBloc, NotificationState>(
                      buildWhen: (p, c) {
                        return p.listNotif != c.listNotif;
                      },
                      builder: (context, state) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: 0,
                          itemBuilder: (context, _) {
                            return notificationWidget();
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
