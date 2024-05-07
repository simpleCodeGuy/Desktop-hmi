//flutter packages
import 'package:flutter/gestures.dart';
// import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:marquee/marquee.dart';
//project files
//  data
import '/data/app_data.dart';
import '../data/configuration.dart';
import '/data/logic_page_data.dart';
import '/data/modbus_data.dart';
import '/data/user_interface_data.dart';

//  methods

//  providers
import '/providers/providers_1.dart';
//------------------------------------import end--------------------------------

class AlarmsPage extends ConsumerWidget {
  const AlarmsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.brown,
      child: const Text('Alarms Page'),
    );
  }
}
