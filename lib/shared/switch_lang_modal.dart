import 'package:flutter/material.dart';
import 'package:pin_flip/utils/constants.dart';
import 'package:pin_flip/shared/shared.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showSwitchLangModal(BuildContext context,
    {required String title, required String description, Widget? child}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SwitchLangModal(
        title: title,
        description: description,
        child: child,
      );
    },
  );
}

class SwitchLangModal extends StatefulWidget {
  final String title;
  final String description;
  final Widget? child;

  const SwitchLangModal({
    super.key,
    required this.title,
    required this.description,
    this.child,
  });

  @override
  State<SwitchLangModal> createState() => _SwitchLangModalState();
}

class _SwitchLangModalState extends State<SwitchLangModal> {
  Locale _locale = const Locale('en');

  String newValue = 'en';

  void getLocal() async {
    final prefs = await SharedPreferences.getInstance();

    final locale = prefs.getString(localeKey);

    if (locale != null) {
      setState(() {
        _locale = Locale(locale);
        newValue = _locale.languageCode;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getLocal();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (widget.child != null) ...[
              const SizedBox(height: 16.0),
              widget.child!,
            ],
            const SizedBox(height: 16.0),
            DropdownButton<String>(
              focusColor: Theme.of(context).scaffoldBackgroundColor,
              dropdownColor: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              value: newValue,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(
                  value: 'ar',
                  child: Text(
                    'العربية',
                    style: TextStyle(fontFamily: "NotoKufiArabic"),
                  ),
                ),
              ],
              onChanged: (value) async {
                await switchLang(value);
              },
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: 300,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Button(
                    variant: Button.primary,
                    onPressed: newValue != _locale.languageCode
                        ? () {
                            confirm(newValue);
                            Navigator.of(context).pop();
                          }
                        : null,
                    child: const Text('Confirm'),
                  ),
                  const SizedBox(width: 8.0),
                  Button(
                    variant: Button.danger,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> confirm(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(localeKey, value).then((success) async {
      if (success) {
        await Restart.restartApp();
      }
    });
  }

  Future<void> switchLang(String? value) async {
    final prefs = await SharedPreferences.getInstance();
    final locale = prefs.getString(localeKey);

    if (value != null && locale != value) {
      setState(() {
        newValue = value;
      });
    }
  }
}
