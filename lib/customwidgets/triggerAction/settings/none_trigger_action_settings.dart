import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_home/customwidgets/triggerAction/none_trigger_action.dart';
import 'package:smart_home/customwidgets/triggerAction/trigger_actions.dart';
import 'package:smart_home/customwidgets/widgets/view/settings/templates/device_selection.dart';
import 'package:smart_home/manager/manager.dart';

class NoneTriggerActionSettings extends TriggerActionSetting {
  final NoneTriggerAction noneTriggerAction;
  const NoneTriggerActionSettings({Key? key, required this.noneTriggerAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DeviceSelection(
          customWidgetManager: Manager.instance!.customWidgetManager,
          onDataPointSelected: (d) => {noneTriggerAction.dataPoint =d},
          onDeviceSelected: (d)=> {noneTriggerAction.dataPoint == null},
          selectedDataPoint: noneTriggerAction.dataPoint,
          selectedDevice: noneTriggerAction.dataPoint?.device,
        ),
        TextField(
          controller: TextEditingController.fromValue(TextEditingValue(text: noneTriggerAction.round.toString())),
          decoration: const InputDecoration(labelText: "Round to"),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly
          ],
          onChanged: (v) => noneTriggerAction.round = int.tryParse(v) ?? 2,
        ),
        _RulesSettings(noneTriggerAction: noneTriggerAction),
      ],
    );
  }

}

class _RulesSettings extends StatefulWidget {
  final NoneTriggerAction noneTriggerAction;
  const _RulesSettings({Key? key, required this.noneTriggerAction}) : super(key: key);

  @override
  State<_RulesSettings> createState() => _RulesSettingsState();
}

class _RulesSettingsState extends State<_RulesSettings> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      childrenPadding: const EdgeInsets.only(left: 10),

      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text("Text Rules: ", style: TextStyle(fontSize: 17),),
          TextButton(onPressed: ()  {
            showDialog(context: context, builder: (context) =>
                _RuleAddAlertDialog(onAdd: (key,value )  {
                  if(widget.noneTriggerAction.displayRules?.containsKey(key) ?? false) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Rule Already exists!")));
                  }
                  setState(() {
                    widget.noneTriggerAction.displayRules ??= {};
                    widget.noneTriggerAction.displayRules?[key] = value;
                  });
                },));
          }, child: const Text("Add"))
        ],
      ),
      children: [
        for(String keyRule in widget.noneTriggerAction.displayRules?.keys ?? [] )
          Dismissible(
            onDismissed: (d) {
              setState(() {
                widget.noneTriggerAction.displayRules?.remove(keyRule);
              });
            },
            key: ValueKey(keyRule),
            child: ListTile(
              title: Text(widget.noneTriggerAction.displayRules![keyRule] ?? "Not Found"),
              subtitle: Text(keyRule),


            ),
            direction: DismissDirection.endToStart,
          )
      ],

    );
  }
}

class _RuleAddAlertDialog extends StatelessWidget {
  final Function(String, String) onAdd;
  final TextEditingController keyController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  _RuleAddAlertDialog({Key? key, required this.onAdd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add New Rule"),
      actions: [
        TextButton(onPressed: () => {onAdd(keyController.text, valueController.text)}, child: const Text("Add")),
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel"))
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(labelText: "Old Value"),
            controller: keyController,
          ),
          TextField(
            decoration: const InputDecoration(labelText: "New Value"),
            controller: valueController,
          ),
          DropdownButtonFormField<int>(
            items: [],
            onChanged: (int? value) {  },

          )

        ],
      ),
    );
  }
}

