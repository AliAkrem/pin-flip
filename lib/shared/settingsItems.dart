import 'package:flutter/material.dart';
import 'package:pin_flip/utils/data.dart';

class Settingsitems extends StatefulWidget {
  const Settingsitems({super.key});

  @override
  State<Settingsitems> createState() => _SettingsitemsState();
}

class _SettingsitemsState extends State<Settingsitems> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: ListView(
        shrinkWrap: true,
        children: [
          for (SettingsItemModal si
              in DummyDataService.getSettingsTitles(context)) ...[
            SettingsItem(
              title: si.title,
              action: si.action,
            )
          ]
        ],
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  const SettingsItem({
    super.key,
    required this.action,
    required this.title,
  });

  final String title;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        padding: EdgeInsets.zero,
      ),
      onPressed: () {
        action();
      },
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 28),
        child: Text(title),
      ),
    );
  }
}
