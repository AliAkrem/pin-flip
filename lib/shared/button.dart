import 'package:flutter/material.dart';
import 'package:pin_flip/utils/colors.dart';

class Button extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final String? variant;
  static const String primary = 'primary';
  static const String danger = 'danger';
  static const String outlined = 'outlined';

  Color get _backgroundColor {
    switch (variant) {
      case primary:
        return PinFlipColors.buttonColor;
      case danger:
        return PinFlipColors.danger;
      case outlined:
      default:
        return Colors.transparent;
    }
  }

  Color get _foregroundColor {
    switch (variant) {
      case primary:
      case danger:
        return Colors.white;
      case outlined:
      default:
        return PinFlipColors.buttonColor;
    }
  }

  BorderSide get _border {
    return variant == outlined
        ? const BorderSide(color: PinFlipColors.buttonColor)
        : BorderSide.none;
  }


  const Button({
    required this.child,
    required this.onPressed,
    this.variant,
    super.key,
  });

  
  

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: _foregroundColor ,
        backgroundColor: _backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: _border,
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
