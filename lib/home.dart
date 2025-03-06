import 'package:flutter/material.dart';
import 'package:pin_flip/data/pin_flip_options.dart';
import 'package:pin_flip/layout/adaptive.dart';
import 'package:pin_flip/layout/text_scale.dart';
import 'package:pin_flip/shared/shared.dart';
import 'package:pin_flip/tabs/accounts.dart';
import 'package:pin_flip/tabs/bills.dart';
import 'package:pin_flip/tabs/budgets.dart';
import 'package:pin_flip/tabs/overview.dart';
import 'package:pin_flip/tabs/profile.dart';
import "package:flutter_gen/gen_l10n/gallery_localizations.dart";
import 'package:pin_flip/tabs/time_line.dart';

const int tabCount = 6;
const int turnsToRotateRight = 1;
const int turnsToRotateLeft = 3;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, RestorationMixin {
  late TabController _tabController;
  RestorableInt tabIndex = RestorableInt(0);

  @override
  String get restorationId => 'home_page';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, 'tab_index');
    _tabController.index = tabIndex.value;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabCount, vsync: this)
      ..addListener(() {
        // Set state to make sure that the [_PinFlipTab] widgets get updated when changing tabs.
        setState(() {
          tabIndex.value = _tabController.index;
        });
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    tabIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = isDisplayDesktop(context);
    Widget tabBarView;

    if (isDesktop) {
      final isTextDirectionRtl =
          PinFlipOptions.of(context).resolvedTextDirection() ==
              TextDirection.rtl;
      final verticalRotation =
          isTextDirectionRtl ? turnsToRotateLeft : turnsToRotateRight;
      final revertVerticalRotation =
          isTextDirectionRtl ? turnsToRotateRight : turnsToRotateLeft;

      tabBarView = Row(
        children: [
          Container(
            width: 150 + 50 * (cappedTextScale(context) - 1),
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                  child: Image(image: AssetImage('assets/images/logo.png')),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        RotatedBox(
                          quarterTurns: verticalRotation,
                          child: _PinFlipTabBar(
                            tabs: _buildTabs(
                                    context: context,
                                    theme: theme,
                                    isVertical: true)
                                .map(
                              (widget) {
                                return RotatedBox(
                                  quarterTurns: revertVerticalRotation,
                                  child: widget,
                                );
                              },
                            ).toList(),
                            tabController: _tabController,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RotatedBox(
              quarterTurns: verticalRotation,
              child: TabBarView(
                controller: _tabController,
                children: _buildTabViews().map(
                  (widget) {
                    return RotatedBox(
                      quarterTurns: revertVerticalRotation,
                      child: widget,
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ],
      );
    } else {
      tabBarView = Column(
        children: [
          _PinFlipTabBar(
            tabs: _buildTabs(context: context, theme: theme),
            tabController: _tabController,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _buildTabViews(),
            ),
          ),
        ],
      );
    }
    return ApplyTextOptions(
      child: Scaffold(
          body: SafeArea(
            top: !isDesktop,
            bottom: !isDesktop,
            child: Theme(
              data: theme.copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: FocusTraversalGroup(
                policy: OrderedTraversalPolicy(),
                child: tabBarView,
              ),
            ),
          ),
          endDrawerEnableOpenDragGesture: false,
          endDrawer: !isDesktop
              ? Drawer(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  width: 300,
                  child: const Settingsitems(),
                )
              : null),
    );
  }

  List<Widget> _buildTabs(
      {required BuildContext context,
      required ThemeData theme,
      bool isVertical = false}) {
    return [
      _PinFlipTab(
        theme: theme,
        iconData: Icons.pie_chart,
        title: GalleryLocalizations.of(context)!.tabTitleOverview,
        tabIndex: 0,
        tabController: _tabController,
        isVertical: isVertical,
      ),
      _PinFlipTab(
        theme: theme,
        iconData: Icons.attach_money,
        title: GalleryLocalizations.of(context)!.tabTitleAccounts,
        tabIndex: 1,
        tabController: _tabController,
        isVertical: isVertical,
      ),
      _PinFlipTab(
        theme: theme,
        iconData: Icons.money_off,
        title: GalleryLocalizations.of(context)!.tabTitleBills,
        tabIndex: 2,
        tabController: _tabController,
        isVertical: isVertical,
      ),
      _PinFlipTab(
        theme: theme,
        iconData: Icons.table_chart,
        title: GalleryLocalizations.of(context)!.tabTitleBudgets,
        tabIndex: 3,
        tabController: _tabController,
        isVertical: isVertical,
      ),
      _PinFlipTab(
        theme: theme,
        iconData: Icons.calendar_view_week,
        title: "time line",
        tabIndex: 4,
        tabController: _tabController,
        isVertical: isVertical,
      ),
      _PinFlipTab(
        theme: theme,
        iconData: Icons.person,
        title: GalleryLocalizations.of(context)!.tabTitleProfile,
        tabIndex: 5,
        tabController: _tabController,
        isVertical: isVertical,
      ),
    ];
  }

  List<Widget> _buildTabViews() {
    return const [
      OverviewView(),
      AccountsView(),
      BillsView(),
      BudgetsView(),
      TimeLine(),
      PrifileView(),
    ];
  }
}

class _PinFlipTabBar extends StatelessWidget {
  const _PinFlipTabBar({required this.tabs, required this.tabController});

  final List<Widget> tabs;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return FocusTraversalOrder(
      order: const NumericFocusOrder(0),
      child: TabBar(
        isScrollable: true,
        labelPadding: EdgeInsets.zero,
        tabs: tabs,
        controller: tabController,
        indicatorColor: Colors.transparent,
      ),
    );
  }
}

class _PinFlipTab extends StatefulWidget {
  _PinFlipTab({
    required ThemeData theme,
    required IconData iconData,
    required String title,
    required int tabIndex,
    required TabController tabController,
    required this.isVertical,
  })  : titleText = Text(title, style: theme.textTheme.labelLarge),
        isExpanded = tabController.index == tabIndex,
        icon = Icon(iconData, semanticLabel: title);

  final Text titleText;
  final Icon icon;
  final bool isExpanded;
  final bool isVertical;

  @override
  _PinFlipTabState createState() => _PinFlipTabState();
}

class _PinFlipTabState extends State<_PinFlipTab>
    with SingleTickerProviderStateMixin {
  late Animation<double> _titleSizeAnimation;
  late Animation<double> _titleFadeAnimation;
  late Animation<double> _iconFadeAnimation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _titleSizeAnimation = _controller.view;
    _titleFadeAnimation = _controller.drive(CurveTween(curve: Curves.easeOut));
    _iconFadeAnimation = _controller.drive(Tween<double>(begin: 0.6, end: 1));
    if (widget.isExpanded) {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(_PinFlipTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isVertical) {
      return Column(
        children: [
          const SizedBox(height: 18),
          FadeTransition(
            opacity: _iconFadeAnimation,
            child: widget.icon,
          ),
          const SizedBox(height: 12),
          FadeTransition(
            opacity: _titleFadeAnimation,
            child: SizeTransition(
              axis: Axis.vertical,
              axisAlignment: -1,
              sizeFactor: _titleSizeAnimation,
              child: Center(child: ExcludeSemantics(child: widget.titleText)),
            ),
          ),
          const SizedBox(height: 18),
        ],
      );
    }

    // Calculate the width of each unexpanded tab by counting the number of
    // units and dividing it into the screen width. Each unexpanded tab is 1
    // unit, and there is always 1 expanded tab which is 1 unit + any extra
    // space determined by the multiplier.
    final width = MediaQuery.of(context).size.width;
    const expandedTitleWidthMultiplier = 2;
    final unitWidth = width / (tabCount + expandedTitleWidthMultiplier);

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: Row(
        children: [
          FadeTransition(
            opacity: _iconFadeAnimation,
            child: SizedBox(
              width: unitWidth,
              child: widget.icon,
            ),
          ),
          FadeTransition(
            opacity: _titleFadeAnimation,
            child: SizeTransition(
              axis: Axis.horizontal,
              axisAlignment: -1,
              sizeFactor: _titleSizeAnimation,
              child: SizedBox(
                width: unitWidth * expandedTitleWidthMultiplier,
                child: Center(
                  child: ExcludeSemantics(child: widget.titleText),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
