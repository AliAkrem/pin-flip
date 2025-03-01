import 'package:flutter/material.dart';
import 'package:pin_flip/utils/colors.dart';
import 'package:pin_flip/layout/adaptive.dart';

class TabWithSidebar extends StatelessWidget {
  const TabWithSidebar({
    super.key,
    required this.restorationId,
    required this.mainView,
    required this.sidebarItems,
  });

  final Widget mainView;
  final List<Widget> sidebarItems;
  final String restorationId;

  @override
  Widget build(BuildContext context) {
    if (isDisplayDesktop(context)) {
      return Row(
        children: [
          Flexible(
            flex: 2,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: mainView,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: PinFlipColors.inputBackground,
              padding: const EdgeInsetsDirectional.only(start: 24),
              height: double.infinity,
              alignment: AlignmentDirectional.centerStart,
              child: ListView(
                shrinkWrap: true,
                children: sidebarItems,
              ),
            ),
          ),
        ],
      );
    } else {
      return SingleChildScrollView(
        restorationId: restorationId,
        child: mainView,
      );
    }
  }
}

class SidebarItem extends StatelessWidget {
  const SidebarItem({super.key, required this.value, required this.title});

  final String value;
  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          title,
          style: textTheme.bodyMedium!.copyWith(
            fontSize: 16,
            color: PinFlipColors.gray60,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: textTheme.bodyLarge!.copyWith(fontSize: 20),
        ),
        const SizedBox(height: 8),
        Container(
          color: PinFlipColors.primaryBackground,
          height: 1,
        ),
      ],
    );
  }
}
