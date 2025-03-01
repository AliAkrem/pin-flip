import 'package:flutter/material.dart';
import 'package:pin_flip/utils/colors.dart';

class Button extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final String? variant;
  static const String primary = 'primary';
  static const String danger = 'danger';
  static const String outlined = 'outlined';

  const Button({
    required this.child,
    required this.onPressed,
    this.variant,
    // this.enabled,
    super.key,
  });

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  Color get _backgroundColor {
    switch (widget.variant) {
      case Button.primary:
        return PinFlipColors.buttonColor;
      case Button.danger:
        return PinFlipColors.danger;
      case Button.outlined:
      default:
        return Colors.transparent;
    }
  }

  Color get _foregroundColor {
    switch (widget.variant) {
      case Button.primary:
      case Button.danger:
        return Colors.white;
      case Button.outlined:
      default:
        return PinFlipColors.buttonColor;
    }
  }

  BorderSide get _border {
    return widget.variant == Button.outlined
        ? const BorderSide(color: PinFlipColors.buttonColor)
        : BorderSide.none;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        disabledBackgroundColor: Colors.grey,
        disabledForegroundColor: Colors.white70,
        foregroundColor: _foregroundColor,
        backgroundColor: _backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: _border,
        ),
      ),
      onPressed: widget.onPressed,
      child: widget.child,
    );
  }
}
