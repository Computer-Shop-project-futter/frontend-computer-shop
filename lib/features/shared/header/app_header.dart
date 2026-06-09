// lib/features/shared/header/app_header.dart
import 'package:flutter/material.dart';

class AppHeaderBar extends StatelessWidget {
  final Widget child;
  final bool dark;
  final EdgeInsetsGeometry padding;

  const AppHeaderBar({
    super.key,
    required this.child,
    this.dark = false,
    this.padding = const EdgeInsets.fromLTRB(14, 10, 14, 14),
  });

  @override
  Widget build(BuildContext context) {
    final decoration = dark
        ? const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF12306A), Color(0xFF0D1C3E)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x20000000),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          )
        : BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          );

    return Container(
      padding: padding,
      decoration: decoration,
      child: SafeArea(bottom: false, child: child),
    );
  }
}

class AppHeaderIconButton extends StatelessWidget {
  final IconData? icon;
  final Widget? child;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color iconColor;
  final Color? borderColor;
  final double size;

  const AppHeaderIconButton({
    super.key,
    this.icon,
    this.child,
    required this.onTap,
    required this.backgroundColor,
    required this.iconColor,
    this.borderColor,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: borderColor == null
                ? null
                : Border.all(color: borderColor!),
          ),
          alignment: Alignment.center,
          child: child ?? Icon(icon, color: iconColor, size: 20),
        ),
      ),
    );
  }
}