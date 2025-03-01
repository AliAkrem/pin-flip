

import 'package:flutter/widgets.dart';

import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:pin_flip/shared/shared.dart';
import 'package:pin_flip/utils/data.dart';
import 'package:pin_flip/finance.dart';
import 'package:pin_flip/tabs/sidebar.dart';

/// A page that shows a summary of bills.
class BillsView extends StatefulWidget {
  const BillsView({super.key});

  @override
  _BillsViewState createState() => _BillsViewState();
}

class _BillsViewState extends State<BillsView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final items = DummyDataService.getBillDataList(context);
    final dueTotal = sumBillDataPrimaryAmount(items);
    final paidTotal = sumBillDataPaidAmount(items);
    final detailItems = DummyDataService.getBillDetailList(
      context,
      dueTotal: dueTotal,
      paidTotal: paidTotal,
    );

    return TabWithSidebar(
      restorationId: 'bills_view',
      mainView: FinancialEntityView(
        heroLabel: GalleryLocalizations.of(context)!.billsHeroLabelBillsDue,
        heroAmount: dueTotal,
        segments: buildSegmentsFromBillItems(items),
        wholeAmount: dueTotal,
        financialEntityCards: buildBillDataListViews(items, context),
      ),
      sidebarItems: [
        for (UserDetailData item in detailItems)
          SidebarItem(title: item.title, value: item.value)
      ],
    );
  }
}
