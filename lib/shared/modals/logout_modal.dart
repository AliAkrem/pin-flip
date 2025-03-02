import 'package:flutter/material.dart';
import 'package:pin_flip/app.dart';
import 'package:pin_flip/shared/shared.dart';

void showLogoutModal(BuildContext context,
    {required String title, required String description, Widget? child}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return LogoutModal(
        title: title,
        description: description,
        child: child,
      );
    },
  );
}

class LogoutModal extends StatefulWidget {
  final String title;
  final String description;
  final Widget? child;

  const LogoutModal({
    super.key,
    required this.title,
    required this.description,
    this.child,
  });

  @override
  State<LogoutModal> createState() => _LogoutModalState();
}

class _LogoutModalState extends State<LogoutModal> {
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
              style: Theme.of(context).textTheme.bodyLarge,
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
            SizedBox(
              width: 300,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Button(
                    variant: Button.danger,
                    onPressed: () {
                      Navigator.popAndPushNamed(context, PinFlipApp.loginRoute);
                    },
                    child: const Text('Logout'),
                  ),
                  const SizedBox(width: 8.0),
                  Button(
                    variant: Button.outlined,
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

  Future<void> confirm() async {}
}
