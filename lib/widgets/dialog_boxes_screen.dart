import 'package:simple_hmi/data/dialog_box_classes.dart';
import 'package:simple_hmi/methods/input_methods.dart';
import 'package:simple_hmi/methods/user_interface_methods.dart';

import '/main.dart';
import 'package:flutter/gestures.dart';
// import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:flutter/material.dart';
import 'package:simple_hmi/providers/core_provider.dart';
import 'package:simple_hmi/widgets/editor_mode_1_screen_canvas_methods.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:marquee/marquee.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:toggle_switch/toggle_switch.dart';
//project files
//  data and classes
import '/data/app_data.dart';
import '/data/configuration.dart';
import '/data/logic_page_data.dart';
import '/classes/logic_part.dart';
import '/data/modbus_data.dart';
import '/classes/class_extensions.dart';
import '/data/user_interface_data.dart';
import '/classes/input_elements.dart';
//providers
import '/providers/provider_dialog_boxes.dart';
import '/classes/enumerations.dart';

class MultiTextButtonCreateDialogWidget extends ConsumerWidget {
  // final ItemBeingCreated itemBeingCreated;
  final MultiTextButton multiTextButton;
  final ColorPickerData colorPickerData;
  final DialogBoxConfiguration CONFIG;

  const MultiTextButtonCreateDialogWidget({
    super.key,
    required this.multiTextButton,
    required this.colorPickerData,
    required this.CONFIG,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final elementCreateDialogNotifier = ref.watch(elementCreateDialogProvider);

    return SizedBox(
      width: CONFIG.width,
      // child: ListView(
      //     // scrollDirection: Axis.vertical,
      //     children: [
      //       ...MultiTextButton.widget(
      //         // itemBeingCreated: itemBeingCreated,
      //         multiTextBoolean: multiTextBoolean,
      //         colorPickerData: colorPickerData,
      //         CONFIG: CONFIG,
      //         THIS_IS_CREATE_DIALOG: true,
      //       ),
      //       ...[
      //         MultiTextMethods.updateCancelDialogForCreate_(
      //           DIALOG_BOX_CONFIG: CONFIG,
      //           // itemBeingCreated: itemBeingCreated,
      //           multiTextBoolean: multiTextBoolean,
      //         ),
      //       ]
      //     ]),
    );
  }
}

class CreateEditDialogContent extends ConsumerWidget {
  final DialogBoxForScreen data;
  final DialogBoxConfiguration CONFIG;

  const CreateEditDialogContent({
    super.key,
    required this.data,
    required this.CONFIG,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DialogBoxForScreenOperations.updateRef(data, ref);
    final contentRebuildNotifier = ref.watch(data.contentRebuildProvider);

    switch (data.elementType) {
      case ElementType.multiTextButton:
        return MultiTextButtonDialog(data: data, CONFIG: CONFIG);
      default:
        return Container();
    }
  }
}

class MultiTextButtonDialog extends ConsumerWidget {
  final DialogBoxForScreen data;
  final DialogBoxConfiguration CONFIG;

  const MultiTextButtonDialog({
    super.key,
    required this.data,
    required this.CONFIG,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> widgetList = [];
    bool alternatingColor1 = true;
    bool keyIsOfStringDataType = false;

    int countInputRecords = 0;
    for (dynamic key in data.tempModifiedElement.inputRecords.keys) {
      if (key.runtimeType != String) {
        countInputRecords += 1;
      }
    }

    widgetList.add(DialogBoxForScreenOperations.HORIZONTAL_BANNER(
      TEXT: 'Input',
      FONT_SIZE: CONFIG.fontSizeBannerText,
      BANNER_HEIGHT: CONFIG.heightHorizontalBanner,
      FONT_COLOR: CONFIG.colorBannerText,
    ));

    for (dynamic key in data.tempModifiedElement.inputRecords.keys) {
      keyIsOfStringDataType = key.runtimeType == String;
      if (not(keyIsOfStringDataType) && countInputRecords > 1) {
        widgetList.add(DeleteWidgetDialog(
          data: data,
          input: true,
          RECORD_KEY: key,
          alternatingColor1: alternatingColor1,
          CONFIG: CONFIG,
        ));
      }
      widgetList.add(RecordMultiTextWidget(
        data: data,
        RECORD_KEY: key,
        alternatingColor1: alternatingColor1,
        CONFIG: CONFIG,
        hideBooleanValue: keyIsOfStringDataType,
      ));
      alternatingColor1 = !alternatingColor1;
    }
    widgetList.add(
      AddWidgetDialog(
        data: data,
        input: true,
        alternatingColor1: alternatingColor1,
        CONFIG: CONFIG,
      ),
    );
    alternatingColor1 = !alternatingColor1;
    widgetList.add(DialogBoxForScreenOperations.HORIZONTAL_BANNER(
      TEXT: 'Output',
      FONT_SIZE: CONFIG.fontSizeBannerText,
      BANNER_HEIGHT: CONFIG.heightHorizontalBanner,
      FONT_COLOR: CONFIG.colorBannerText,
    ));
    for (dynamic key in data.tempModifiedElement.output.keys) {
      if (data.tempModifiedElement.output.keys.length > 1) {
        widgetList.add(DeleteWidgetDialog(
          data: data,
          output: true,
          RECORD_KEY: key,
          alternatingColor1: alternatingColor1,
          CONFIG: CONFIG,
        ));
      }
      widgetList.add(
        Container(
          height: CONFIG.cancelButtonSize,
          color: alternatingColor1
              ? CONFIG.alternatingColorBackground1
              : CONFIG.alternatingColorBackground2,
          child: Center(
            child: Text(
              'current boolean value is ${data.tempModifiedElement.output[key]['value']}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CONFIG.colorBannerText,
              ),
            ),
          ),
        ),
      );
      widgetList.add(TextEditingDialogWidget(
        data: data,
        SELECT_ALTERNATING_COLOR_ONE: alternatingColor1,
        CONFIG: CONFIG,
        INPUT_KEY: const [],
        OUTPUT_KEY: [key, 'label'],
      ));
      widgetList.add(TextEditingDialogWidget(
        data: data,
        SELECT_ALTERNATING_COLOR_ONE: alternatingColor1,
        CONFIG: CONFIG,
        INPUT_KEY: const [],
        OUTPUT_KEY: [key, 'buttonText'],
      ));

      alternatingColor1 = !alternatingColor1;
    }
    widgetList.add(
      AddWidgetDialog(
        data: data,
        output: true,
        alternatingColor1: alternatingColor1,
        CONFIG: CONFIG,
      ),
    );

    return SizedBox(
      width: CONFIG.width,
      height: CONFIG.height,
      child: ListView(children: widgetList),
    );
  }
}

class DeleteWidgetDialog extends ConsumerWidget {
  final DialogBoxForScreen data;
  late final bool input;
  late final bool output;
  final dynamic RECORD_KEY;
  final bool alternatingColor1;
  final DialogBoxConfiguration CONFIG;

  DeleteWidgetDialog({
    super.key,
    required this.data,
    bool? input,
    bool? output,
    required this.RECORD_KEY,
    required this.alternatingColor1,
    required this.CONFIG,
  }) {
    this.input = input ?? false;
    this.output = output ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: alternatingColor1
          ? CONFIG.alternatingColorBackground1
          : CONFIG.alternatingColorBackground2,
      height: CONFIG.cancelButtonSize,
      alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(height: CONFIG.verticalSpacer),
          Tooltip(
            message: 'Delete',
            child: TextButton(
              onPressed: () {
                if (input) {
                  DialogBoxForScreenOperations.deleteInputRecord(
                      data, RECORD_KEY);
                  // data.contentRebuildProvider.rebuild();
                  ref.read(data.contentRebuildProvider).rebuild();
                } else if (output) {
                  DialogBoxForScreenOperations.deleteOutputRecord(
                      data, RECORD_KEY);
                  // data.contentRebuildProvider.rebuild();
                  ref.read(data.contentRebuildProvider).rebuild();
                }
                data.SCREEN_REBUILD_CALLBACK();
              },
              child: const Icon(Icons.delete),
            ),
          ),
          SizedBox(height: CONFIG.verticalSpacer)
        ],
      ),
    );
  }
}

class AddWidgetDialog extends ConsumerWidget {
  final DialogBoxForScreen data;
  late final bool input;
  late final bool output;

  final bool alternatingColor1;
  final DialogBoxConfiguration CONFIG;

  AddWidgetDialog({
    super.key,
    required this.data,
    bool? input,
    bool? output,
    required this.alternatingColor1,
    required this.CONFIG,
  }) {
    this.input = input ?? false;
    this.output = output ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: alternatingColor1
          ? CONFIG.alternatingColorBackground1
          : CONFIG.alternatingColorBackground2,
      height: CONFIG.cancelButtonSize,
      alignment: Alignment.center,
      // child: Text(
      //   'Add Widget Button',
      //   style: TextStyle(color: Colors.white),
      // ),

      child: TextButton(
        onPressed: () {
          if (input) {
            DialogBoxForScreenOperations.addInput(data);
            // data.contentRebuildProvider.rebuild();
            ref.read(data.contentRebuildProvider).rebuild();
          } else if (output) {
            DialogBoxForScreenOperations.addOutput(data);
            // data.contentRebuildProvider.rebuild();
            ref.read(data.contentRebuildProvider).rebuild();
          }
          data.SCREEN_REBUILD_CALLBACK();
        },
        child: Icon(
          Icons.add,
          color: CONFIG.fontColorContent,
        ),
      ),
    );
  }
}

class RecordMultiTextWidget extends ConsumerWidget {
  final DialogBoxForScreen data;
  final dynamic RECORD_KEY;
  final bool alternatingColor1;
  final DialogBoxConfiguration CONFIG;
  final bool hideBooleanValue;
  final bool hideText;
  final bool hideFontSize;
  final bool hideColorForeGround;
  final bool hideColorBackGround;
  const RecordMultiTextWidget({
    super.key,
    required this.data,
    required this.RECORD_KEY,
    required this.alternatingColor1,
    required this.CONFIG,
    this.hideBooleanValue = false,
    this.hideText = false,
    this.hideFontSize = false,
    this.hideColorForeGround = false,
    this.hideColorBackGround = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> widget = [];
    if (data.elementType == ElementType.multiTextButton) {
      if (!hideText) {
        widget.add(TextEditingDialogWidget(
          data: data,
          SELECT_ALTERNATING_COLOR_ONE: alternatingColor1,
          CONFIG: CONFIG,
          INPUT_KEY: [RECORD_KEY],
          OUTPUT_KEY: const [],
        ));
      }
      if (!hideBooleanValue) {
        widget.add(BooleanEditingDialogWidget(
          data: data,
          SELECT_ALTERNATING_COLOR_ONE: alternatingColor1,
          CONFIG: CONFIG,
          INPUT_KEY: [RECORD_KEY],
          OUTPUT_KEY: const [],
        ));
      }
      if (!hideFontSize) {
        widget.add(FontSizeEditingDialogWidget(
          data: data,
          SELECT_ALTERNATING_COLOR_ONE: alternatingColor1,
          CONFIG: CONFIG,
          INPUT_KEY: [RECORD_KEY],
          OUTPUT_KEY: const [],
        ));
      }
      if (!hideColorForeGround) {
        widget.add(ColorEditingDialogWidget(
          data: data,
          SELECT_ALTERNATING_COLOR_ONE: alternatingColor1,
          CONFIG: CONFIG,
          INPUT_KEY: [
            RECORD_KEY,
            'colorForeGround',
          ],
          OUTPUT_KEY: const [],
        ));
      }
      if (!hideColorBackGround) {
        widget.add(ColorEditingDialogWidget(
          data: data,
          SELECT_ALTERNATING_COLOR_ONE: alternatingColor1,
          CONFIG: CONFIG,
          INPUT_KEY: [
            RECORD_KEY,
            'colorBackGround',
          ],
          OUTPUT_KEY: const [],
        ));
      }

      return Column(children: widget);
    }
    return Container();
  }
}

class TextEditingDialogWidget extends ConsumerWidget {
  final DialogBoxForScreen data;

  final bool SELECT_ALTERNATING_COLOR_ONE;
  final DialogBoxConfiguration CONFIG;

  final List INPUT_KEY;
  final List OUTPUT_KEY;
  late final dynamic PROVIDER_TO_REBUILD;

  TextEditingDialogWidget({
    required this.data,
    required this.SELECT_ALTERNATING_COLOR_ONE,
    required this.CONFIG,
    required this.INPUT_KEY,
    required this.OUTPUT_KEY,
    super.key,
  }) {
    PROVIDER_TO_REBUILD =
        DialogBoxForScreenOperations.GET_REBUILDING_PROVIDER_AFTER_TEXT_CHANGE(
      DATA: data,
      INPUT_KEY: INPUT_KEY,
      OUTPUT_KEY: OUTPUT_KEY,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rebuildNotifier = ref.watch(PROVIDER_TO_REBUILD);

    String initialValue;
    initialValue = DialogBoxForScreenOperations.GET_TEXT_INITIAL_VALUE(
      INPUT_KEY: INPUT_KEY,
      OUTPUT_KEY: OUTPUT_KEY,
      DATA: data,
    );

    print('String value in data:  $initialValue');

    return Container(
      color: SELECT_ALTERNATING_COLOR_ONE
          ? CONFIG.alternatingColorBackground1
          : CONFIG.alternatingColorBackground2,
      child: Column(
        children: [
          SizedBox(height: CONFIG.verticalSpacer),
          Row(
            children: [
              SizedBox(
                width: CONFIG.textLabelWidth,
                child: Text(
                  DialogBoxForScreenOperations.GET_NAME_OF_TEXT(
                    DATA: data,
                    INPUT_KEY: INPUT_KEY,
                    OUTPUT_KEY: OUTPUT_KEY,
                  ),
                  style: TextStyle(color: CONFIG.fontColorContent),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: CONFIG.textFieldWidth,
                child: TextFormField(
                  // controller: _controller,
                  initialValue: initialValue,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'RobotoMono',
                    fontSize: 15,
                  ),
                  onChanged: (typedText) {
                    DialogBoxForScreenOperations.updateText(
                      data: data,
                      NEW_TEXT: typedText,
                      INPUT_KEY: INPUT_KEY,
                      OUTPUT_KEY: OUTPUT_KEY,
                    );
                    ref
                        .read(DialogBoxForScreenOperations
                            .GET_REBUILDING_PROVIDER_AFTER_TEXT_CHANGE(
                          DATA: data,
                          INPUT_KEY: INPUT_KEY,
                          OUTPUT_KEY: OUTPUT_KEY,
                        ))
                        .rebuild();
                    data.SCREEN_REBUILD_CALLBACK();
                  },
                  decoration: InputDecoration(
                    hintText: 'enter text here',
                    hintStyle: TextStyle(color: Colors.white54),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: Colors.white60,
                        width: 2,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: Colors.white60,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: Colors.white60,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: CONFIG.verticalSpacer),
        ],
      ),
    );
  }
}

class BooleanEditingDialogWidget extends ConsumerWidget {
  final DialogBoxForScreen data;

  final bool SELECT_ALTERNATING_COLOR_ONE;
  final DialogBoxConfiguration CONFIG;

  final List INPUT_KEY;
  final List OUTPUT_KEY;
  late final dynamic PROVIDER_TO_REBUILD;

  BooleanEditingDialogWidget({
    required this.data,
    required this.SELECT_ALTERNATING_COLOR_ONE,
    required this.CONFIG,
    required this.INPUT_KEY,
    required this.OUTPUT_KEY,
    super.key,
  }) {
    PROVIDER_TO_REBUILD = DialogBoxForScreenOperations
        .GET_REBUILDING_PROVIDER_AFTER_BOOLEAN_CHANGE(
      DATA: data,
      INPUT_KEY: INPUT_KEY,
      OUTPUT_KEY: OUTPUT_KEY,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rebuildNotifier = ref.watch(PROVIDER_TO_REBUILD);

    bool initialValue = DialogBoxForScreenOperations.GET_BOOLEAN_VALUE(
      INPUT_KEY: INPUT_KEY,
      OUTPUT_KEY: OUTPUT_KEY,
      DATA: data,
    );

    print('boolean value in data:  $initialValue');

    return Container(
      color: SELECT_ALTERNATING_COLOR_ONE
          ? CONFIG.alternatingColorBackground1
          : CONFIG.alternatingColorBackground2,
      child: Column(
        children: [
          SizedBox(height: CONFIG.verticalSpacer),
          Row(
            children: [
              SizedBox(
                width: CONFIG.textLabelWidth,
                child: Text(
                  'true or false',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(color: CONFIG.fontColorContent),
                ),
              ),
              SizedBox(
                width: CONFIG.textLabelWidth,
                child: Center(
                  child: ToggleSwitch(
                    labels: const ['False', 'True'],
                    // initialLabelIndex: elementBeingEdited.val == false ? 0 : 1,
                    initialLabelIndex:
                        DialogBoxForScreenOperations.GET_BOOLEAN_VALUE(
                                  DATA: data,
                                  INPUT_KEY: INPUT_KEY,
                                  // INPUT_KEY_2: INPUT_KEY_2,
                                  OUTPUT_KEY: OUTPUT_KEY,
                                  // OUTPUT_KEY_2: OUTPUT_KEY_2,
                                ) ==
                                false
                            ? 0
                            : 1,

                    inactiveBgColor: CONFIG.toggleInactiveBackground,
                    inactiveFgColor: CONFIG.toggleInactiveForeground,
                    activeBgColor: [
                      CONFIG.toggleActiveBackground,
                      CONFIG.toggleActiveBackground
                    ],
                    activeFgColor: CONFIG.toggleActiveForeground,
                    onToggle: (index) {
                      // MultiTextMethods.updateBooleanValue_(
                      //   multiTextBoolean: multiTextBoolean,
                      //   BOOLEAN_VALUE: index == 1,
                      //   RECORD_KEY: KEY_OF_RECORD,
                      // );
                      DialogBoxForScreenOperations.updateBooleanValue(
                        data: data,
                        NEW_BOOL_VALUE: index == 1,
                        INPUT_KEY: INPUT_KEY,
                        // INPUT_KEY_2: INPUT_KEY_2,
                        OUTPUT_KEY: OUTPUT_KEY,
                        // OUTPUT_KEY_2: OUTPUT_KEY_2,
                      );
                      ref
                          .read(DialogBoxForScreenOperations
                              .GET_REBUILDING_PROVIDER_AFTER_BOOLEAN_CHANGE(
                            DATA: data,
                            INPUT_KEY: INPUT_KEY,
                            // INPUT_KEY_2: INPUT_KEY_2,
                            OUTPUT_KEY: OUTPUT_KEY,
                            // OUTPUT_KEY_2: OUTPUT_KEY_2,
                          ))
                          .rebuild();
                      data.SCREEN_REBUILD_CALLBACK();
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: CONFIG.verticalSpacer),
        ],
      ),
    );
  }
}

class FontSizeEditingDialogWidget extends ConsumerWidget {
  final DialogBoxForScreen data;

  final bool SELECT_ALTERNATING_COLOR_ONE;
  final DialogBoxConfiguration CONFIG;

  final List INPUT_KEY;
  final List OUTPUT_KEY;
  late final dynamic PROVIDER_TO_REBUILD;

  FontSizeEditingDialogWidget({
    required this.data,
    required this.SELECT_ALTERNATING_COLOR_ONE,
    required this.CONFIG,
    required this.INPUT_KEY,
    required this.OUTPUT_KEY,
    super.key,
  }) {
    PROVIDER_TO_REBUILD = DialogBoxForScreenOperations
        .GET_REBUILDING_PROVIDER_AFTER_FONT_SIZE_CHANGE(
      DATA: data,
      INPUT_KEY: INPUT_KEY,
      // INPUT_KEY_2: INPUT_KEY_2,
      OUTPUT_KEY: OUTPUT_KEY,
      // OUTPUT_KEY_2: OUTPUT_KEY_2,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rebuildNotifier = ref.watch(PROVIDER_TO_REBUILD);

    double initialValue = DialogBoxForScreenOperations.GET_FONT_SIZE(
      INPUT_KEY: INPUT_KEY,
      OUTPUT_KEY: OUTPUT_KEY,
      DATA: data,
    );

    print('font size value in data:  $initialValue');

    return Container(
      color: SELECT_ALTERNATING_COLOR_ONE
          ? CONFIG.alternatingColorBackground1
          : CONFIG.alternatingColorBackground2,
      child: Column(
        children: [
          SizedBox(height: CONFIG.verticalSpacer),
          Row(
            children: [
              SizedBox(
                width: CONFIG.textLabelWidth,
                child: Text(
                  'font size',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(color: CONFIG.fontColorContent),
                ),
              ),
              SizedBox(
                width: CONFIG.textLabelWidth,
                child: Row(
                  children: [
                    const Spacer(),
                    SizedBox(
                      width: CONFIG.minusButtonWidth,
                      height: CONFIG.minuxButtonHeight,
                      child: TextButton(
                        onPressed: () {
                          DialogBoxForScreenOperations.decreaseFontSize(
                            data: data,
                            INPUT_KEY: INPUT_KEY,
                            // INPUT_KEY_2: INPUT_KEY_2,
                            OUTPUT_KEY: OUTPUT_KEY,
                            // OUTPUT_KEY_2: OUTPUT_KEY_2,
                          );
                          ref
                              .read(DialogBoxForScreenOperations
                                  .GET_REBUILDING_PROVIDER_AFTER_BOOLEAN_CHANGE(
                                DATA: data,
                                INPUT_KEY: INPUT_KEY,
                                // INPUT_KEY_2: INPUT_KEY_2,
                                OUTPUT_KEY: OUTPUT_KEY,
                                // OUTPUT_KEY_2: OUTPUT_KEY_2,
                              ))
                              .rebuild();
                          data.SCREEN_REBUILD_CALLBACK();
                        },
                        child: Image.asset(
                          'assets/icons/minus.png',
                          color: CONFIG.fontColorContent,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: CONFIG.numberWidth,
                      height: CONFIG.numberHeight,
                      child: Center(
                        child: Text(
                          initialValue.toString(),
                          style: TextStyle(
                            color: CONFIG.fontColorContent,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: CONFIG.minusButtonWidth,
                      height: CONFIG.minuxButtonHeight,
                      child: TextButton(
                        onPressed: () {
                          DialogBoxForScreenOperations.increaseFontSize(
                            data: data,
                            INPUT_KEY: INPUT_KEY,
                            // INPUT_KEY_2: INPUT_KEY_2,
                            OUTPUT_KEY: OUTPUT_KEY,
                            // OUTPUT_KEY_2: OUTPUT_KEY_2,
                          );
                          ref
                              .read(DialogBoxForScreenOperations
                                  .GET_REBUILDING_PROVIDER_AFTER_BOOLEAN_CHANGE(
                                DATA: data,
                                INPUT_KEY: INPUT_KEY,
                                // INPUT_KEY_2: INPUT_KEY_2,
                                OUTPUT_KEY: OUTPUT_KEY,
                                // OUTPUT_KEY_2: OUTPUT_KEY_2,
                              ))
                              .rebuild();
                          data.SCREEN_REBUILD_CALLBACK();
                        },
                        child: Image.asset(
                          'assets/icons/plus.png',
                          color: CONFIG.fontColorContent,
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: CONFIG.verticalSpacer),
        ],
      ),
    );
  }
}

class ColorEditingDialogWidget extends ConsumerWidget {
  final DialogBoxForScreen data;

  final bool SELECT_ALTERNATING_COLOR_ONE;
  final DialogBoxConfiguration CONFIG;

  final List INPUT_KEY;
  final List OUTPUT_KEY;
  late final dynamic PROVIDER_TO_REBUILD;

  ColorEditingDialogWidget({
    required this.data,
    required this.SELECT_ALTERNATING_COLOR_ONE,
    required this.CONFIG,
    required this.INPUT_KEY,
    required this.OUTPUT_KEY,
    super.key,
  }) {
    PROVIDER_TO_REBUILD =
        DialogBoxForScreenOperations.GET_REBUILDING_PROVIDER_AFTER_COLOR_CHANGE(
            DATA: data, INPUT_KEY: INPUT_KEY, OUTPUT_KEY: OUTPUT_KEY);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rebuildNotifier = ref.watch(PROVIDER_TO_REBUILD);

    Color initialValue = DialogBoxForScreenOperations.GET_COLOR(
        INPUT_KEY: INPUT_KEY, OUTPUT_KEY: OUTPUT_KEY, DATA: data);

    print('color value in data:  $initialValue');

    return Container(
      color: SELECT_ALTERNATING_COLOR_ONE
          ? CONFIG.alternatingColorBackground1
          : CONFIG.alternatingColorBackground2,
      child: Column(
        children: [
          SizedBox(height: CONFIG.verticalSpacer),
          Row(
            children: [
              SizedBox(
                width: CONFIG.textLabelWidth,
                child: Text(
                  DialogBoxForScreenOperations.GET_NAME_OF_COLOR(
                      DATA: data, INPUT_KEY: INPUT_KEY, OUTPUT_KEY: OUTPUT_KEY),
                  textDirection: TextDirection.rtl,
                  style: TextStyle(color: CONFIG.fontColorContent),
                ),
              ),
              SizedBox(
                width: CONFIG.textLabelWidth,
                child: Row(
                  children: [
                    const Spacer(),
                    SizedBox(
                      width: CONFIG.numberWidth / 4,
                    ),
                    Container(
                      width: CONFIG.colorSquareWidth / 2,
                      height: CONFIG.colorSquareWidth / 2,
                      decoration: BoxDecoration(
                        color: DialogBoxForScreenOperations.GET_COLOR(
                            DATA: data,
                            INPUT_KEY: INPUT_KEY,
                            OUTPUT_KEY: OUTPUT_KEY),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            CONFIG.colorSquareWidth / 4,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: CONFIG.numberWidth / 4,
                    ),
                    SizedBox(
                      width: CONFIG.minusButtonWidth,
                      height: CONFIG.minuxButtonHeight,
                      child: TextButton(
                        onPressed: () {
                          DialogBoxForScreenOperations.colorPickerDialog(
                              data: data,
                              INPUT_KEY: INPUT_KEY,
                              OUTPUT_KEY: OUTPUT_KEY,
                              CONFIG: CONFIG);
                        },
                        child: Icon(
                          Icons.edit,
                          semanticLabel: 'Edit Color',
                          color: CONFIG.fontColorContent,
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: CONFIG.verticalSpacer),
        ],
      ),
    );
  }
}
