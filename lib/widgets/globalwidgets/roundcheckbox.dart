import 'package:flutter/material.dart';
import 'package:projecthomestrategies/utils/colortheme.dart';
import 'package:provider/provider.dart';

class RoundCheckbox extends StatefulWidget {
  final double radius;
  final double iconSize;
  final bool initialValue;
  final Function onChanged;
  final IconData checkedIcon;

  const RoundCheckbox({ Key? key, this.radius = 25, required this.onChanged, this.iconSize = 18, this.checkedIcon = Icons.check, required this.initialValue}) : super(key: key);

  @override
  _RoundCheckboxState createState() => _RoundCheckboxState();
}

class _RoundCheckboxState extends State<RoundCheckbox> {
  late bool checked;

  @override
  void initState() {
    super.initState();
    checked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        setState(() {
          checked = !checked;
          widget.onChanged(checked);
        });
      },
      child: Container(
        width: widget.radius,
        height: widget.radius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: checked? context.read<AppTheme>().customTheme.primaryColor : Colors.grey,
          ),
          color: checked? context.read<AppTheme>().customTheme.primaryColor : Colors.white,
        ),
        child: checked? 
          Center(
            child: Icon(
              widget.checkedIcon, 
              size: widget.iconSize, 
              color: Colors.white,
            ),
          ):
          const Center(),
      ),
    );
  }
}