import 'package:flutter/cupertino.dart';
import 'package:smart_home/customwidgets/triggerAction/button_trigger_action.dart';
import 'package:smart_home/customwidgets/triggerAction/color_pallete_trigger_action.dart';
import 'package:smart_home/customwidgets/triggerAction/multiselection_trigger_action.dart';
import 'package:smart_home/customwidgets/triggerAction/none_trigger_action.dart';
import 'package:smart_home/customwidgets/triggerAction/slider_trigger_action.dart';
import 'package:smart_home/customwidgets/triggerAction/switch_trigger_action.dart';
import 'package:smart_home/customwidgets/triggerAction/template_widget_trigger_action.dart';

enum TriggerActionType {
  button,
  handleSwitch,
  slider,
  multiSelection,
  colorPallete,
  templateWidget,
  none //VALUE,
}

extension TriggerActionTypeExtension on TriggerActionType {
  String get name {
    switch (this) {
      case TriggerActionType.button:
        return "Button";
      case TriggerActionType.handleSwitch:
        return "Handle";
      case TriggerActionType.multiSelection:
        return "Multi Selection";
      case TriggerActionType.slider:
        return "Slider";
      case TriggerActionType.none:
        return "Value";
      case TriggerActionType.colorPallete:
        return "Color Pallete";
      case TriggerActionType.templateWidget:
        return "Template Widget";
    }
  }

  TriggerAction get triggerAction {
    switch (this) {
      case TriggerActionType.button:
        return ButtonTriggerAction(label: "", dataPoint: null);

      case TriggerActionType.handleSwitch:
        return SwitchTriggerAction(dataPoint: null);
      case TriggerActionType.multiSelection:
        return MultiSelectionTriggerAction(
            dataPoint: null, selections: Map.from({}));
      case TriggerActionType.slider:
        return SliderTriggerAction(dataPoint: null);
      case TriggerActionType.none:
        return NoneTriggerAction(dataPoint: null, displayRules: null);
      case TriggerActionType.colorPallete:
        return ColorPalleteTriggerAction(dataPoint: null);
      case TriggerActionType.templateWidget:
        return TemplateWidgetTriggerAction();
    }
  }
}

abstract class TriggerAction {
  TriggerAction();

  bool isTypeAllowed(dynamic value);
  bool validate();
  TriggerActionSetting? get settings;
  Widget getWidget({VoidCallback? onLongTab});
  TriggerActionType get type;
  Map<String, dynamic> toJson();
  void trigger();

  static TriggerAction fromJSON(Map<String, dynamic> map) {
    String? typeRaw = map["type"];
    if (typeRaw == null) {
      return NoneTriggerAction(dataPoint: null, displayRules: null);
    }
    TriggerActionType type = TriggerActionType.values.firstWhere(
        (element) => element.toString() == typeRaw,
        orElse: () => TriggerActionType.none);
    switch (type) {
      case TriggerActionType.none:
        return NoneTriggerAction.fromJSON(map);
      case TriggerActionType.multiSelection:
        return MultiSelectionTriggerAction.fromJSON(map);
      case TriggerActionType.slider:
        return SliderTriggerAction.fromJSON(map);
      case TriggerActionType.handleSwitch:
        return SwitchTriggerAction.fromJSON(map);
      case TriggerActionType.button:
        return ButtonTriggerAction.fromJSON(map);
      default:
        throw UnimplementedError("No Trigger Action found");
    }
  }
}

abstract class TriggerActionSetting extends StatelessWidget {
  const TriggerActionSetting({Key? key}) : super(key: key);
  List<GlobalKey> get showKeys;
}
