

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:pin_flip/utils/data.dart';
import 'package:pin_flip/finance.dart';
import 'package:pin_flip/shared/shared.dart';
import 'package:pin_flip/tabs/sidebar.dart';

/// A page that shows a summary of accounts.
class AccountsView extends StatelessWidget {
  const AccountsView({super.key});

  @override
  Widget build(BuildContext context) {
    final items = DummyDataService.getAccountDataList(context);
    final detailItems = DummyDataService.getAccountDetailList(context);
    final balanceTotal = sumAccountDataPrimaryAmount(items);

    return TabWithSidebar(
      restorationId: 'accounts_view',
      mainView: FinancialEntityView(
        heroLabel: GalleryLocalizations.of(context)!.pinFlipAccountTotal,
        heroAmount: balanceTotal,
        segments: buildSegmentsFromAccountItems(items),
        wholeAmount: balanceTotal,
        financialEntityCards: buildAccountDataListViews(items, context),
      ),
      sidebarItems: [
        for (UserDetailData item in detailItems)
          SidebarItem(title: item.title, value: item.value)
      ],
    );
  }
}
