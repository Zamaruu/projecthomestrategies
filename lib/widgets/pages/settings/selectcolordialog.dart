import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/cancelbutton.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/primarybutton.dart';

class SelectColorDialog extends StatefulWidget {
  final Color currentColor;

  const SelectColorDialog({Key? key, required this.currentColor})
      : super(key: key);

  @override
  _SelectColorDialogState createState() => _SelectColorDialogState();
}

class _SelectColorDialogState extends State<SelectColorDialog> {
  late Color color;

  @override
  void initState() {
    color = widget.currentColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Farbe auswählen"),
      content: MaterialColorPicker(
        circleSize: 55,
        onColorChange: (Color newColor) {
          color = newColor;
        },
        // onMainColorChange: (swatch) {
        //   var temp = Color(swatch!.value);
        //   setState(() {
        //     color = temp;
        //   });
        // },
        selectedColor: color,
      ),
      actions: [
        CancelButton(onCancel: () => Navigator.of(context).pop()),
        PrimaryButton(
          onPressed: () => Navigator.of(context).pop(color),
          text: "Auswählen",
          icon: Icons.done,
        )
      ],
    );
  }
}
