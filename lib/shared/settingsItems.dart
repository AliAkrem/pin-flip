import 'package:flutter/material.dart';
import 'package:pin_flip/utils/colors.dart';
import 'package:pin_flip/utils/data.dart';

class Settingsitems extends StatefulWidget {
  const Settingsitems({super.key});

  @override
  State<Settingsitems> createState() => _SettingsitemsState();
}

class _SettingsitemsState extends State<Settingsitems> {
  @override
  Widget build(BuildContext context) {
    final settings = DummyDataService.getSettingsTitles(context)
        .map((si) => SettingsItem(
              icon: si.icon,
              title: si.title,
              action: si.action,
            ))
        .toList();

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: settings,
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  const SettingsItem({
    super.key,
    required this.action,
    required this.title,
    required this.icon,
  });
  final IconData icon;
  final String title;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      textColor: PinFlipColors.white,
      iconColor: PinFlipColors.white,
      onTap: () {
        action();
      },
    );
  }
}
