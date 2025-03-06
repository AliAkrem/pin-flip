import 'dart:math' as math;

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:pin_flip/data/pin_flip_options.dart';
import 'package:pin_flip/layout/adaptive.dart';
import 'package:pin_flip/layout/text_scale.dart';
import 'package:pin_flip/shared/charts/line_chart.dart';
import 'package:pin_flip/shared/shared.dart';
import 'package:pin_flip/utils/colors.dart';
import 'package:pin_flip/utils/data.dart';
import 'package:pin_flip/formatters.dart';

class FinancialEntityView extends StatelessWidget {
  const FinancialEntityView({
    super.key,
    required this.heroLabel,
    required this.heroAmount,
    required this.wholeAmount,
    required this.segments,
    required this.financialEntityCards,
  }) : assert(segments.length == financialEntityCards.length);

  /// The amounts to assign each item.
  final List<PinFlipPieChartSegment> segments;
  final String heroLabel;
  final double heroAmount;
  final double wholeAmount;
  final List<FinancialEntityCategoryView> financialEntityCards;

  @override
  Widget build(BuildContext context) {
    final maxWidth = pieChartMaxSize + (cappedTextScale(context) - 1.0) * 100.0;
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: math.min(
                constraints.biggest.shortestSide * 0.9,
                maxWidth,
              ),
            ),
            child: PinFlipPieChart(
              heroLabel: heroLabel,
              heroAmount: heroAmount,
              wholeAmount: wholeAmount,
              segments: segments,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            height: 1,
            constraints: BoxConstraints(maxWidth: maxWidth),
            color: PinFlipColors.inputBackground,
          ),
          Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            color: PinFlipColors.cardBackground,
            child: Column(
              children: financialEntityCards,
            ),
          ),
        ],
      );
    });
  }
}

/// A reusable widget to show balance information of a single entity as a card.
class FinancialEntityCategoryView extends StatelessWidget {
  const FinancialEntityCategoryView({
    super.key,
    required this.indicatorColor,
    required this.indicatorFraction,
    required this.title,
    required this.subtitle,
    required this.semanticsLabel,
    required this.amount,
    required this.suffix,
  });

  final Color indicatorColor;
  final double indicatorFraction;
  final String title;
  final String subtitle;
  final String semanticsLabel;
  final String amount;
  final Widget suffix;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Semantics.fromProperties(
      properties: SemanticsProperties(
        button: true,
        enabled: true,
        label: semanticsLabel,
      ),
      excludeSemantics: true,
      // TODO: State restoration of
      // FinancialEntityCategoryDetailsPage on mobile is blocked because
      // OpenContainer does not support restorablePush.
      // See https://github.com/flutter/flutter/issues/69924.
      child: OpenContainer(
        transitionDuration: const Duration(milliseconds: 350),
        transitionType: ContainerTransitionType.fade,
        openBuilder: (context, openContainer) =>
            FinancialEntityCategoryDetailsPage(),
        openColor: PinFlipColors.primaryBackground,
        closedColor: PinFlipColors.primaryBackground,
        closedElevation: 0,
        closedBuilder: (context, openContainer) {
          return TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.black),
            onPressed: openContainer,
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 32 + 60 * (cappedTextScale(context) - 1),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: VerticalFractionBar(
                          color: indicatorColor,
                          fraction: indicatorFraction,
                        ),
                      ),
                      Expanded(
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: textTheme.bodyMedium!
                                      .copyWith(fontSize: 16),
                                ),
                                Text(
                                  subtitle,
                                  style: textTheme.bodyMedium!
                                      .copyWith(color: PinFlipColors.gray60),
                                ),
                              ],
                            ),
                            Text(
                              amount,
                              style: textTheme.bodyLarge!.copyWith(
                                fontSize: 20,
                                color: PinFlipColors.gray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        constraints: const BoxConstraints(minWidth: 32),
                        padding: const EdgeInsetsDirectional.only(start: 12),
                        child: suffix,
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: PinFlipColors.dividerColor,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Data model for [FinancialEntityCategoryView].
class FinancialEntityCategoryModel {
  const FinancialEntityCategoryModel(
    this.indicatorColor,
    this.indicatorFraction,
    this.title,
    this.subtitle,
    this.usdAmount,
    this.suffix,
  );

  final Color indicatorColor;
  final double indicatorFraction;
  final String title;
  final String subtitle;
  final double usdAmount;
  final Widget suffix;
}

FinancialEntityCategoryView buildFinancialEntityFromAccountData(
  AccountData model,
  int accountDataIndex,
  BuildContext context,
) {
  final amount = usdWithSignFormat(context).format(model.primaryAmount);
  final shortAccountNumber = model.accountNumber.substring(6);
  return FinancialEntityCategoryView(
    suffix: const Icon(Icons.chevron_right, color: Colors.grey),
    title: model.name,
    subtitle: '• • • • • • $shortAccountNumber',
    semanticsLabel: GalleryLocalizations.of(context)!.pinFlipAccountAmount(
      model.name,
      shortAccountNumber,
      amount,
    ),
    indicatorColor: PinFlipColors.accountColor(accountDataIndex),
    indicatorFraction: 1,
    amount: amount,
  );
}

FinancialEntityCategoryView buildFinancialEntityFromBillData(
  BillData model,
  int billDataIndex,
  BuildContext context,
) {
  final amount = usdWithSignFormat(context).format(model.primaryAmount);
  return FinancialEntityCategoryView(
    suffix: const Icon(Icons.chevron_right, color: Colors.grey),
    title: model.name,
    subtitle: model.dueDate,
    semanticsLabel: GalleryLocalizations.of(context)!.pinFlipBillAmount(
      model.name,
      model.dueDate,
      amount,
    ),
    indicatorColor: PinFlipColors.billColor(billDataIndex),
    indicatorFraction: 1,
    amount: amount,
  );
}

FinancialEntityCategoryView buildFinancialEntityFromBudgetData(
  BudgetData model,
  int budgetDataIndex,
  BuildContext context,
) {
  final amountUsed = usdWithSignFormat(context).format(model.amountUsed);
  final primaryAmount = usdWithSignFormat(context).format(model.primaryAmount);
  final amount =
      usdWithSignFormat(context).format(model.primaryAmount - model.amountUsed);

  return FinancialEntityCategoryView(
    suffix: Text(
      GalleryLocalizations.of(context)!.pinFlipFinanceLeft,
      style: Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(color: PinFlipColors.gray60, fontSize: 10),
    ),
    title: model.name,
    subtitle: '$amountUsed / $primaryAmount',
    semanticsLabel: GalleryLocalizations.of(context)!.pinFlipBudgetAmount(
      model.name,
      model.amountUsed,
      model.primaryAmount,
      amount,
    ),
    indicatorColor: PinFlipColors.budgetColor(budgetDataIndex),
    indicatorFraction: model.amountUsed / model.primaryAmount,
    amount: amount,
  );
}

List<FinancialEntityCategoryView> buildAccountDataListViews(
  List<AccountData> items,
  BuildContext context,
) {
  return List<FinancialEntityCategoryView>.generate(
    items.length,
    (i) => buildFinancialEntityFromAccountData(items[i], i, context),
  );
}

List<FinancialEntityCategoryView> buildBillDataListViews(
  List<BillData> items,
  BuildContext context,
) {
  return List<FinancialEntityCategoryView>.generate(
    items.length,
    (i) => buildFinancialEntityFromBillData(items[i], i, context),
  );
}

List<FinancialEntityCategoryView> buildBudgetDataListViews(
  List<BudgetData> items,
  BuildContext context,
) {
  return <FinancialEntityCategoryView>[
    for (int i = 0; i < items.length; i++)
      buildFinancialEntityFromBudgetData(items[i], i, context)
  ];
}

class FinancialEntityCategoryDetailsPage extends StatelessWidget {
  FinancialEntityCategoryDetailsPage({super.key});

  final List<DetailedEventData> items =
      DummyDataService.getDetailedEventItems();

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);

    return ApplyTextOptions(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          // elevation: 0,
          centerTitle: true,
          title: Text(
            GalleryLocalizations.of(context)!.pinFlipAccountDataChecking,
            style:
                Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18),
          ),
        ),
        body: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: !isDesktop ? Axis.horizontal : Axis.vertical,
              child: SizedBox(
                height: 250,
                width: isDesktop ? double.infinity : 600,
                child: LineChartSample(),
              ),
            ),
            Expanded(
              child: Padding(
                padding: isDesktop ? const EdgeInsets.all(40) : EdgeInsets.zero,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (DetailedEventData detailedEventData in items)
                      _DetailedEventCard(
                        title: detailedEventData.title,
                        date: detailedEventData.date,
                        amount: detailedEventData.amount,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailedEventCard extends StatelessWidget {
  const _DetailedEventCard({
    required this.title,
    required this.date,
    required this.amount,
  });

  final String title;
  final DateTime date;
  final double amount;

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      onPressed: () {},
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            width: double.infinity,
            child: isDesktop
                ? Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: _EventTitle(title: title),
                      ),
                      _EventDate(date: date),
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: _EventAmount(amount: amount),
                        ),
                      ),
                    ],
                  )
                : Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _EventTitle(title: title),
                          _EventDate(date: date),
                        ],
                      ),
                      _EventAmount(amount: amount),
                    ],
                  ),
          ),
          SizedBox(
            height: 1,
            child: Container(
              color: PinFlipColors.dividerColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _EventAmount extends StatelessWidget {
  const _EventAmount({required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(
      usdWithSignFormat(context).format(amount),
      style: textTheme.bodyLarge!.copyWith(
        fontSize: 20,
        color: PinFlipColors.gray,
      ),
    );
  }
}

class _EventDate extends StatelessWidget {
  const _EventDate({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(
      shortDateFormat(context).format(date),
      semanticsLabel: longDateFormat(context).format(date),
      style: textTheme.bodyMedium!.copyWith(color: PinFlipColors.gray60),
    );
  }
}

class _EventTitle extends StatelessWidget {
  const _EventTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(
      title,
      style: textTheme.bodyMedium!.copyWith(fontSize: 16),
    );
  }
}
