import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';
import '../bloc/statistics_bloc.dart';

class TagChooser extends StatelessWidget {
  const TagChooser({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticsBloc, StatisticsState>(
      buildWhen: (previous, current) {
        return previous.typeCategories != current.typeCategories;
      },
      builder: (context, state) {
        final tagFlow = {
          0: AppLocalizations.of(context)!.all,
          1: AppLocalizations.of(context)!.income,
          2: AppLocalizations.of(context)!.expense,
        };
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: tagFlow.entries.map(
              (e) {
                return GestureDetector(
                  onTap: () {
                    context.read<StatisticsBloc>().add(
                          TypeCategoriesEvent(type: e.key),
                        );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    margin: const EdgeInsets.only(right: 12),
                    decoration: ShapeDecoration(
                      color: (e.key == state.typeCategories)
                          ? const Color(0xFFF599DA)
                          : const Color(0xFF343437),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      e.value,
                      style: TextStyle(
                        color: (e.key == state.typeCategories)
                            ? const Color(0xFF101010)
                            : Colors.white,
                        fontSize: 11.5,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }
}
