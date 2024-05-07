import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/data/model_logic.dart' as model;

var config = model.config;

class TopBarII extends ConsumerWidget {
  const TopBarII({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: config.TOPBAR_II_BACKGROUND_UNSELECTED(),
      height: config.TOPBAR_II_HEIGHT(),
    );
  }
}

class SideBar extends ConsumerWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: config.SIDEBAR_COLOR(),
      width: config.SIDEBAR_WIDTH(),
      height: 100.0,
    );
  }
}
