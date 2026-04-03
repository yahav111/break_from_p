import 'package:flutter/material.dart';

import '../tokens/tokens.dart';

/// Global layout wrapper providing consistent structure.
/// Handles safe areas, padding, and optional bottom navigation.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.resizeToAvoidBottomInset = true,
    this.padding,
    this.useSafeArea = true,
  });

  /// The primary content of the scaffold.
  final Widget body;

  /// Optional app bar at the top.
  final PreferredSizeWidget? appBar;

  /// Optional bottom navigation bar.
  final Widget? bottomNavigationBar;

  /// Optional floating action button.
  final Widget? floatingActionButton;

  /// Position of the floating action button.
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Optional left drawer.
  final Widget? drawer;

  /// Optional right drawer.
  final Widget? endDrawer;

  /// Background color (defaults to theme scaffold background).
  final Color? backgroundColor;

  /// Whether body extends behind bottom navigation.
  final bool extendBody;

  /// Whether body extends behind app bar.
  final bool extendBodyBehindAppBar;

  /// Whether to resize body when keyboard appears.
  final bool resizeToAvoidBottomInset;

  /// Custom padding for the body.
  final EdgeInsets? padding;

  /// Whether to wrap body with SafeArea.
  final bool useSafeArea;

  @override
  Widget build(BuildContext context) {
    Widget content = body;

    // Apply custom padding if provided
    if (padding != null) {
      content = Padding(
        padding: padding!,
        child: content,
      );
    }

    // Wrap with SafeArea if enabled
    if (useSafeArea) {
      content = SafeArea(
        bottom: bottomNavigationBar == null && !extendBody,
        child: content,
      );
    }

    return Scaffold(
      appBar: appBar,
      body: content,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      drawer: drawer,
      endDrawer: endDrawer,
      backgroundColor: backgroundColor,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }
}

/// Pre-configured scaffold with standard screen padding.
class AppScreenScaffold extends StatelessWidget {
  const AppScreenScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.backgroundColor,
    this.horizontalPadding = AppSpacing.lg,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      backgroundColor: backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      body: body,
    );
  }
}

