import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_home/customwidgets/custom_widget.dart';
import 'package:smart_home/customwidgets/cutsomwidgets_rework/button/settings/custom_button_widget_settings_view.dart';
import 'package:smart_home/customwidgets/cutsomwidgets_rework/cutsom_widget.dart';
import 'package:smart_home/device/datapoint/converter/datapoint_converter.dart';
import 'package:smart_home/device/state/state.dart';

part 'custom_button_widget.freezed.dart';
part 'custom_button_widget.g.dart';

@unfreezed
class CustomButtonWidget with _$CustomButtonWidget implements CustomWidget {
  const CustomButtonWidget._();
  @Implements<CustomWidget>()
  factory CustomButtonWidget({
    @Default(CustomWidgetTypeDeprecated.button) CustomWidgetTypeDeprecated type,
    required String id,
    required String name,
    String? label,
    @DataPointIdConverter() required DataPoint? dataPoint,
    String? buttonLabel,
  }) = _CustomButtonWidget;

  @override
  List<DataPoint> get dependentDataPoints {
    return dataPoint == null ? [] : [dataPoint!];
  }

  @override
  CustomWidgetSettingWidget get settingWidget =>
      CustomButtonWidgetSettingsView(customButtonWidget: this);

  @override
  CustomWidgetTypeDeprecated get type => throw UnimplementedError();

  @override
  Widget get widget => throw UnimplementedError();

  factory CustomButtonWidget.fromJson(Map<String, dynamic> json) =>
      _$CustomButtonWidgetFromJson(json);
}
