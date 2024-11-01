import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_home/customwidgets/custom_theme_for_widget/common_impl/label/widget_label_theme.dart';

import 'package:smart_home/customwidgets/custom_theme_for_widget/custom_theme_for_widget.dart';

part 'custom_input_widget_theme.freezed.dart';
part 'custom_input_widget_theme.g.dart';

@unfreezed
class CustomInputWidgetTheme with _$CustomInputWidgetTheme {
  CustomInputWidgetTheme._();
  @Implements<CustomThemeForWidget>()
  factory CustomInputWidgetTheme(
    String id,
    LabelTheme labelTheme,
  ) = _CustomInputWidgetTheme;

  Widget get settingWidget {
    return labelTheme.settingWidget;
  }

  @override
  factory CustomInputWidgetTheme.fromJson(Map<String, dynamic> json) =>
      _$CustomInputWidgetThemeFromJson(json);
}
