import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';
import '../bloc/transaction_bloc.dart';
import '../widget/empty_transaction_widget.dart';
import '../widget/list_transaction.dart';
import '../widget/separator_date_transaction.dart';
import '../widget/switch_date_transaction.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

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
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.transaction,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 16.hmea),
              switchDateTransaction(context),
              SizedBox(height: 16.hmea),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragEnd: (details) {
                    if (details.velocity.pixelsPerSecond.dx > 0) {
                      context.read<TransactionBloc>().add(ClickLeft());
                    } else {
                      context.read<TransactionBloc>().add(ClickRight());
                    }
                  },
                  child: listViewTransaction(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listViewTransaction() {
    return BlocBuilder<TransactionBloc, TransactionState>(
      buildWhen: (p, c) {
        return p.listTransaction != c.listTransaction;
      },
      builder: (context, state) {
        if (state.listTransaction.isEmpty) {
          return emptyTransactionWidget(context);
        }

        return MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView.separated(
            itemCount: state.listTransaction.length,
            itemBuilder: (_, idx) {
              final itemDate = DateTime(
                state.listTransaction[idx].date.year,
                state.listTransaction[idx].date.month,
                state.listTransaction[idx].date.day,
              );

              final isDateDifferent = idx > 0
                  ? !itemDate.isAtSameMomentAs(
                      DateTime(
                        state.listTransaction[idx - 1].date.year,
                        state.listTransaction[idx - 1].date.month,
                        state.listTransaction[idx - 1].date.day,
                      ),
                    )
                  : true;

              return isDateDifferent
                  ? Column(
                      children: [
                        Divider(height: 0.1, color: Colors.grey[700]),
                        separatorDateTransaction(
                          context,
                          state.listTransaction[idx],
                        ),
                        listTransaction(context, state.listTransaction[idx]),
                      ],
                    )
                  : listTransaction(context, state.listTransaction[idx]);
            },
            separatorBuilder: (_, idx) => SizedBox(height: 8.hmea),
          ),
        );
      },
    );
  }
}

//data.substring(0, data.indexOf(" "))
//data.substring(data.indexOf(" ") + 1)
