
import 'package:flutter/widgets.dart';

import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:pin_flip/shared/shared.dart';
import 'package:pin_flip/utils/data.dart';
import 'package:pin_flip/finance.dart';
import 'package:pin_flip/tabs/sidebar.dart';

class BudgetsView extends StatefulWidget {
  const BudgetsView({super.key});

  @override
  _BudgetsViewState createState() => _BudgetsViewState();
}

class _BudgetsViewState extends State<BudgetsView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final items = DummyDataService.getBudgetDataList(context);
    final capTotal = sumBudgetDataPrimaryAmount(items);
    final usedTotal = sumBudgetDataAmountUsed(items);
    final detailItems = DummyDataService.getBudgetDetailList(
      context,
      capTotal: capTotal,
      usedTotal: usedTotal,
    );

    return TabWithSidebar(
      restorationId: 'budgets_view',
      mainView: FinancialEntityView(
        heroLabel: GalleryLocalizations.of(context)!.pinFlipBudgetLeft,
        heroAmount: capTotal - usedTotal,
        segments: buildSegmentsFromBudgetItems(items),
        wholeAmount: capTotal,
        financialEntityCards: buildBudgetDataListViews(items, context),
      ),
      sidebarItems: [
        for (UserDetailData item in detailItems)
          SidebarItem(title: item.title, value: item.value)
      ],
    );
  }
}
