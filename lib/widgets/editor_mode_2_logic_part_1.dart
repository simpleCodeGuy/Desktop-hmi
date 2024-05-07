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
import '/data/model_logic.dart' as model;
import '/widgets/editor_mode_2_logic_part_2.dart';
//  methods

//  providers
import '/providers/providers_1.dart';
//------------------------------------import end--------------------------------

var config = model.config;

class LogicPage extends ConsumerWidget {
  const LogicPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SizedBox(
      child: Column(
        children: [
          TopBarII(),
          Row(
            children: [
              SideBar(),
            ],
          ),
        ],
      ),
    );
  }
}
