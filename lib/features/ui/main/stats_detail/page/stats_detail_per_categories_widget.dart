import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';
import '../bloc/stats_detail_bloc.dart';

class StatsDetailPerCategoriesPage extends StatelessWidget {
  const StatsDetailPerCategoriesPage(
      {super.key, required String categoryOrSource})
      : _categoryOrSource = categoryOrSource;
  final String _categoryOrSource;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StatsDetailBloc(),
      child: const StatsDetailPerCategoriesPageContent(),
    );
  }
}

class StatsDetailPerCategoriesPageContent extends StatelessWidget {
  const StatsDetailPerCategoriesPageContent({super.key});

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
                    AppLocalizations.of(context)!.detail,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.hmea),
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}
