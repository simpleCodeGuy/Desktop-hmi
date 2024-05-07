import 'package:flutter/material.dart';

class AppConfiguration {
  bool darkTheme = true;

  var statusBar = StatusBarConfiguration();
  var xyBox = XYBoxConfiguration();
  var topBar = TopBarConfiguration();
  var topBarII = TopBarIIConfiguration();
  var screen = ScreenConfiguration();
  var propertiesUpdate = DialogBoxConfiguration();
  var userAlertBox = UserAlertBoxConfiguration();

  void toggleTheme() {
    darkTheme = !darkTheme;
    statusBar.toggle(darkTheme);
    xyBox.toggle(darkTheme);
    topBar.toggle(darkTheme);
    topBarII.toggle(darkTheme);
    screen.toggle(darkTheme);
    propertiesUpdate.toggle(darkTheme);
  }
}

class StatusBarConfiguration {
  double height = 20;
  Color foreground = const Color.fromARGB(255, 255, 255, 255);
  Color background = const Color.fromARGB(255, 100, 100, 100);
  double fontSize = 14;

  void toggle(bool darkTheme) {}
}

class XYBoxConfiguration {
  double width = double.infinity;
  double xyMessageWidth = 100;
  double height = 20;
  Color background = const Color.fromARGB(255, 100, 100, 100);
  Color foreground = const Color.fromARGB(255, 255, 255, 255);
  double fontSize = 14;
  double leftPadding = 8;
  double topPadding = 1;
  double rightPadding = 8;
  double bottomPadding = 0;

  void toggle(bool darkTheme) {}
}

class TopBarConfiguration {
  var backgroundUnselected = const Color.fromARGB(255, 100, 100, 100);
  var backgroundSelected = const Color.fromARGB(255, 70, 70, 70);
  var unselected = const Color.fromARGB(255, 230, 230, 230);
  var selected = const Color.fromARGB(255, 255, 255, 0);
  var disabled = const Color.fromARGB(100, 255, 255, 255);
  bool boldFont = false;
  double height = 50;
  double heightIcon = 50;
  double widthIcon = 50;
  double widthTextButton = 100;
  double heightTextButton = 50;
  double fontSizeTextButton = 16;

  Duration toolTipWaitDuration = const Duration(seconds: 1);

  void toggle(bool darkTheme) {}
}

class TopBarIIConfiguration {
  var backgroundUnselected = const Color.fromARGB(255, 70, 70, 70);
  var backgroundSelected = const Color.fromARGB(255, 40, 40, 40);
  var unselected = const Color.fromARGB(255, 230, 230, 230);
  var selected = const Color.fromARGB(255, 255, 255, 0);
  var disabled = const Color.fromARGB(100, 255, 255, 255);
  var separator = const Color.fromARGB(70, 255, 255, 255);
  var scrollBarColor = const Color.fromARGB(150, 115, 115, 130);
  double scrollBarThickness = 4;
  double height = 50;
  double heightIcon = 50;
  double widthIcon = 50;
  Duration toolTipWaitDuration = const Duration(seconds: 1);
  void toggle(bool darkTheme) {}
}

class ScreenConfiguration {
  var dropDown = DropDownConfiguration();
  var content = ScreenContentConfiguration();

  void toggle(bool darkTheme) {
    dropDown.toggle(darkTheme);
    content.toggle(darkTheme);
  }
}

class DropDownConfiguration {
  var background = const Color.fromARGB(255, 40, 40, 40);
  var foreground = const Color.fromARGB(255, 230, 230, 230);
  double height = 80;
  double widthItem = 160;
  double heightIcon = 40;
  double widthIcon = 40;
  double heightTextContainer = 40;

  void toggle(bool darkTheme) {}
}

class ScreenContentConfiguration {
  var background = const Color.fromARGB(255, 0, 0, 0);
  var gridDot = const Color.fromARGB(125, 255, 255, 255);
  double gridDotWidth = 1.0;
  var snapDot = const Color.fromARGB(255, 255, 255, 0);
  double snapDotWidth = 8.0;

  var lineBeingDrawn = const Color.fromARGB(255, 255, 255, 0);
  double lineBeingDrawnWidth = 5.0;
  var lineBeingMoved = const Color.fromARGB(255, 255, 100, 200);
  double lineBeingMovedWidth = 5.0;
  var lineBeingMovedParentWidth = 5.0;
  var selectionBoxBoundary = const Color.fromARGB(200, 0, 255, 255);
  var selectionBoxFill = const Color.fromARGB(40, 0, 255, 255);
  var selectedItem = const Color.fromARGB(255, 255, 100, 200);
  double selectedItemWidth = 5.0;
  int alphaWhenParentItemMovedOrRotated = 125;

  void toggle(bool darkTheme) {}
}

class DialogBoxConfiguration {
  // var backGroundColor = const Color.fromARGB(150, 25, 13, 50);
  var backGround = const Color.fromARGB(100, 0, 0, 0);
  // var backGroundColor = const Color.fromARGB(100, 115, 115, 130);
  var backGroundCancelButton = const Color.fromARGB(255, 180, 0, 0);
  var backGroundPreviewButton = const Color.fromARGB(255, 80, 20, 150);
  var backGroundUpdateButton = const Color.fromARGB(255, 0, 120, 50);
  var fontColorButton = const Color.fromARGB(255, 255, 255, 255);
  var fontColorContent = const Color.fromARGB(255, 255, 255, 255);

  var backGroundColorPicker = const Color.fromARGB(255, 25, 25, 25);

  double width = 600 + 2 * 10; //10 for boxPadding
  double height = 400;

  double buttonWidth = 100;
  double buttonHeightForCreate = 40;
  double boxPadding = 10;
  double noteFont = 16;

  double textLabelWidth = 300;
  double minusButtonWidth = 50;
  double minuxButtonHeight = 50;
  double numberWidth = 80;
  double numberHeight = 50;

  double verticalSpacer = 5;
  double heightHorizontalBanner = 40;
  double buttonTextWidth = 250;
  double fontSizeBannerText = 30;
  Color colorBannerText = const Color.fromARGB(255, 175, 175, 175);

  double colorSquareWidth = 50;

  double lineThicknessMin = 0.50;
  double lineThicknessMax = 20.0;
  double lineThicknessStepSize = 0.50;

  double borderThicknessMin = 0.50;
  double borderThicknessMax = 2.50;
  double borderThicknessStepSize = 0.25;

  Color toggleInactiveBackground = const Color.fromARGB(255, 75, 75, 75);
  Color toggleActiveBackground = const Color.fromARGB(255, 50, 50, 50);

  Color toggleInactiveForeground = const Color.fromARGB(255, 175, 175, 175);
  Color toggleActiveForeground = const Color.fromARGB(255, 255, 255, 0);

  //text create data
  double textCreateFontSize = 16;
  double textFieldWidth = 300;

  //alternating colors background
  Color alternatingColorBackground1 = const Color.fromARGB(75, 30, 30, 30);
  Color alternatingColorBackground2 = const Color.fromARGB(75, 60, 60, 50);

  var cancelButtonSize = 40.0;
  var cancelButtonToolTipWaitDuration = const Duration(seconds: 1);
  void toggle(bool darkTheme) {}
}

class UserAlertBoxConfiguration {
  var colorAlertBox = const Color.fromARGB(255, 45, 45, 45);
  var colorConfirmationBox = const Color.fromARGB(255, 45, 45, 45);
  var colorButton = const Color.fromARGB(255, 75, 75, 75);
  var colorFont = const Color.fromARGB(255, 200, 200, 200);
  var colorCancelButton = const Color.fromARGB(255, 180, 0, 0);
  var cancelButtonSize = 40.0;
  var widthDialogBox = 500.0;
  var widthButton = 400.0;
  var widthConfirmationBox = 300.0;
  var widthConfirmButton = 150.0;
  var heightConfirmButton = 100.0;
  var heightVerticalSpace = 40.0;
  var heightDialogBox = 400.0;
  var heightUserInputButton = 40.0;
  var widthUserInputButton = 400.0;
  var fontSizeUserInputButton = 15.0;

  void toggle(bool darkTheme) {}
}
