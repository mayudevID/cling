// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:cling/core/utils.dart';
import 'package:cling/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../../repository/database_repository.dart';
import '../../../language_currency/lang_currency_bloc.dart';
import '../../../language_currency/lang_export.dart';
import '../bloc/notification_bloc.dart';
import '../widgets/notification_widget.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationBloc(
        dbRepo: getIt<DatabaseRepository>(),
      )..add(GetNotificationList()),
      child: const NotificationPageContent(),
    );
  }
}

class NotificationPageContent extends StatelessWidget {
  const NotificationPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                    child: Assets.lib.resources.images.fluentChevronLeft24Filled
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
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      context
                          .read<NotificationBloc>()
                          .add(MarkNotificationReadAll());
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      AppLocalizations.of(context)!.markReadAll,
                      style: TextStyle(
                        color: Colors.blue[100],
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 16.hmea),
              Expanded(
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: _listViewBuilder(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listViewBuilder(BuildContext context) {
    final dateLocale = context.select(
      (LangCurrencyBloc bloc) =>
          bloc.state.selectedLanguage.value.toLanguageTag(),
    );
    final dateFormat = DateFormat.yMMMMEEEEd(dateLocale);
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    return BlocBuilder<NotificationBloc, NotificationState>(
      buildWhen: (p, c) {
        return p.listNotif.length != c.listNotif.length ||
            p.refreshController != c.refreshController;
      },
      builder: (context, state) {
        return SmartRefresher(
          controller: state.refreshController,
          enablePullDown: false,
          enablePullUp: true,
          onLoading: () {
            context.read<NotificationBloc>().add(GetNotificationList());
          },
          onRefresh: () {},
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus? mode) {
              Widget body;
              const styleText = TextStyle(
                color: Colors.white,
                fontFamily: FontFamily.cabinetGrotesk,
              );
              switch (mode) {
                case null:
                  body = const Text("EMPTY", style: styleText);
                  break;
                case LoadStatus.idle:
                  body = const Text("~~~", style: styleText);
                  break;
                case LoadStatus.canLoading:
                  body = const Text("Can load...", style: styleText);
                  break;
                case LoadStatus.loading:
                  body = const CircularProgressIndicator(color: Colors.white);
                  break;
                case LoadStatus.noMore:
                  body = const Text("Itu saja.", style: styleText);
                  break;
                case LoadStatus.failed:
                  body = const Text("Error.", style: styleText);
                  break;
              }

              return SizedBox(
                height: 55.hmea,
                child: Center(child: body),
              );
            },
          ),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: state.listNotif.length,
            itemBuilder: (context, idx) {
              final itemDate = DateTime(
                state.listNotif[idx].date.year,
                state.listNotif[idx].date.month,
                state.listNotif[idx].date.day,
              );

              final isDateDifferent = idx > 0
                  ? !itemDate.isAtSameMomentAs(
                      DateTime(
                        state.listNotif[idx - 1].date.year,
                        state.listNotif[idx - 1].date.month,
                        state.listNotif[idx - 1].date.day,
                      ),
                    )
                  : true;

              return (isDateDifferent)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1.hmea,
                                color: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                (itemDate.isAtSameMomentAs(today))
                                    ? AppLocalizations.of(context)!.today
                                    : dateFormat.format(itemDate),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: FontFamily.cabinetGrotesk,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 9.2.sp,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1.hmea,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.hmea),
                        notificationWidget(
                          context,
                          idx,
                          state.listNotif[idx],
                        ),
                      ],
                    )
                  : notificationWidget(
                      context,
                      idx,
                      state.listNotif[idx],
                    );
            },
            separatorBuilder: (_, idx) => SizedBox(height: 8.hmea),
          ),
        );
      },
    );
  }
}
