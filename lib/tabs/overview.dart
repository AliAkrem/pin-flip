import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:pin_flip/shared/charts/scatter.dart';
import 'package:pin_flip/utils/colors.dart';
import 'package:pin_flip/data/pin_flip_options.dart';

import 'package:pin_flip/layout/adaptive.dart';
import 'package:pin_flip/layout/text_scale.dart';
import 'package:pin_flip/utils/data.dart';
import 'package:pin_flip/finance.dart';
import 'package:pin_flip/formatters.dart';

/// A page that shows a status overview.
class OverviewView extends StatefulWidget {
  const OverviewView({super.key});

  @override
  _OverviewViewState createState() => _OverviewViewState();
}

class _OverviewViewState extends State<OverviewView> {
  @override
  Widget build(BuildContext context) {
    final alerts = DummyDataService.getAlerts(context);

    if (isDisplayDesktop(context)) {
      const sortKeyName = 'Overview';
      return SingleChildScrollView(
        restorationId: 'overview_scroll_view',
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 7,
                child: Semantics(
                  sortKey: const OrdinalSortKey(1, name: sortKeyName),
                  child: const _OverviewGrid(spacing: 24),
                ),
              ),
              const SizedBox(width: 24),
              Flexible(
                flex: 3,
                child: SizedBox(
                  width: 400,
                  child: Semantics(
                    sortKey: const OrdinalSortKey(2, name: sortKeyName),
                    child: FocusTraversalGroup(
                      child: _AlertsView(alerts: alerts),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return SingleChildScrollView(
        restorationId: 'overview_scroll_view',
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              _AlertsView(alerts: alerts.sublist(0, 1)),
              const SizedBox(height: 12),
              const _OverviewGrid(spacing: 12),
            ],
          ),
        ),
      );
    }
  }
}

class _OverviewGrid extends StatelessWidget {
  const _OverviewGrid({required this.spacing});

  final double spacing;

  @override
  Widget build(BuildContext context) {
    final accountDataList = DummyDataService.getAccountDataList(context);
    final billDataList = DummyDataService.getBillDataList(context);
    final budgetDataList = DummyDataService.getBudgetDataList(context);

    return LayoutBuilder(builder: (context, constraints) {
      final textScaleFactor =
          PinFlipOptions.of(context).textScaleFactor(context);

      // Only display multiple columns when the constraints allow it and we
      // have a regular text scale factor.
      const minWidthForTwoColumns = 600;
      final hasMultipleColumns = isDisplayDesktop(context) &&
          constraints.maxWidth > minWidthForTwoColumns &&
          textScaleFactor <= 2;
      final boxWidth = hasMultipleColumns
          ? constraints.maxWidth / 2 - spacing / 2
          : double.infinity;

      return Wrap(
        runSpacing: spacing,
        children: [
          SizedBox(
            width: boxWidth,
            child: _FinancialView(
              title: GalleryLocalizations.of(context)!.pinFlipAccounts,
              total: sumAccountDataPrimaryAmount(accountDataList),
              financialItemViews:
                  buildAccountDataListViews(accountDataList, context),
              buttonSemanticsLabel:
                  GalleryLocalizations.of(context)!.pinFlipSeeAllAccounts,
              order: 1,
            ),
          ),
          if (hasMultipleColumns) SizedBox(width: spacing),
          SizedBox(
            width: boxWidth,
            child: _FinancialView(
              title: GalleryLocalizations.of(context)!.pinFlipBills,
              total: sumBillDataPrimaryAmount(billDataList),
              financialItemViews: buildBillDataListViews(billDataList, context),
              buttonSemanticsLabel:
                  GalleryLocalizations.of(context)!.pinFlipSeeAllBills,
              order: 2,
            ),
          ),
          SizedBox(width: boxWidth, child: FlutterScatterChart()),

          // _FinancialView(
          //   title: GalleryLocalizations.of(context)!.pinFlipBudgets,
          //   total: sumBudgetDataPrimaryAmount(budgetDataList),
          //   financialItemViews:
          //       buildBudgetDataListViews(budgetDataList, context),
          //   buttonSemanticsLabel:
          //       GalleryLocalizations.of(context)!.pinFlipSeeAllBudgets,
          //   order: 3,
          // ),
        ],
      );
    });
  }
}

class _AlertsView extends StatelessWidget {
  const _AlertsView({required this.alerts});

  final List<AlertData> alerts;

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);

    return Container(
      padding: const EdgeInsetsDirectional.only(start: 16, top: 4, bottom: 4),
      color: PinFlipColors.cardBackground,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding:
                isDesktop ? const EdgeInsets.symmetric(vertical: 16) : null,
            child: MergeSemantics(
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(GalleryLocalizations.of(context)!.pinFlipAlerts),
                  if (!isDesktop)
                    TextButton(
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.white),
                      onPressed: () {},
                      child:
                          Text(GalleryLocalizations.of(context)!.pinFlipSeeAll),
                    ),
                ],
              ),
            ),
          ),
          for (AlertData alert in alerts) ...[
            Container(color: PinFlipColors.primaryBackground, height: 1),
            _Alert(alert: alert),
          ]
        ],
      ),
    );
  }
}

class _Alert extends StatelessWidget {
  const _Alert({
    required this.alert,
  });

  final AlertData alert;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Container(
        padding: isDisplayDesktop(context)
            ? const EdgeInsets.symmetric(vertical: 8)
            : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(alert.message),
            ),
            SizedBox(
              width: 100,
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(alert.iconData, color: PinFlipColors.white60),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FinancialView extends StatelessWidget {
  const _FinancialView({
    required this.title,
    required this.total,
    required this.financialItemViews,
    required this.buttonSemanticsLabel,
    required this.order,
  });

  final String title;
  final String buttonSemanticsLabel;
  final double total;
  final List<FinancialEntityCategoryView> financialItemViews;
  final double order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FocusTraversalOrder(
      order: NumericFocusOrder(order),
      child: Container(
        color: PinFlipColors.cardBackground,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MergeSemantics(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 16,
                      left: 16,
                      right: 16,
                    ),
                    child: Text(title),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Text(
                      usdWithSignFormat(context).format(total),
                      style: theme.textTheme.bodyLarge!.copyWith(
                        fontSize: 44 / reducedTextScale(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ...financialItemViews.sublist(
                0, math.min(financialItemViews.length, 3)),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              onPressed: () {},
              child: Text(
                GalleryLocalizations.of(context)!.pinFlipSeeAll,
                semanticsLabel: buttonSemanticsLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
