import 'dart:ui';

class ActionDescription {
  String action;
  VoidCallback onTap;

  ActionDescription({
    required this.action,
    required this.onTap,
  });
}
