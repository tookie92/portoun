import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;

  ResponsiveLayout({this.desktop, this.tablet, this.mobile});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 768) {
          return mobile!;
        } else if (constraints.maxWidth < 1024) {
          return tablet!;
        } else {
          return desktop!;
        }
      },
    );
  }
}
