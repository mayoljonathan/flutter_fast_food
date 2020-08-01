import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class QuantityPicker extends StatefulWidget {
  const QuantityPicker({
    Key key,
    this.value = 1,
    this.step = 1,
    this.minValue = 0,
    this.maxValue,
    this.onChanged,
  }) : super(key: key);

  final int value;
  final int step;
  final int minValue;
  final int maxValue;
  final void Function(int) onChanged;

  @override
  _QuantityPickerState createState() => _QuantityPickerState();
}

class _QuantityPickerState extends State<QuantityPicker> with SingleTickerProviderStateMixin {
  int _value;

  bool get canDecrement => widget.minValue == null || _value - widget.step >= widget.minValue;
  bool get canIncrement => widget.maxValue == null || _value + widget.step <= widget.maxValue;

  @override
  Widget build(BuildContext context) {
    _value = widget.value;

    return FittedBox(
      child: Material(
        shape: StadiumBorder(
          side: BorderSide(
            color: Colors.grey.shade100,
            width: 1.5,
          ),
        ),
        child: AnimatedSize(
          vsync: this,
          duration: const Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
          child: Row(
            children: [
              if (canDecrement)
                GestureDetector(
                  onTap: _onDecrement,
                  behavior: HitTestBehavior.translucent,
                  child: _buildIcon(EvaIcons.minusOutline),
                ),
              if (_value != 0)
                Padding(
                  padding: EdgeInsets.only(
                    left: !canDecrement ? 12.0 : 0,
                    right: !canIncrement ? 12.0 : 0,
                  ),
                  child: Text(_value.toString()),
                ),
              if (canIncrement)
                GestureDetector(
                  onTap: _onIncrement,
                  behavior: HitTestBehavior.translucent,
                  child: _buildIcon(EvaIcons.plusOutline),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(IconData iconData) {
    return Padding(
      padding: const EdgeInsets.all(9.0),
      child: Icon(
        iconData,
        size: 18.0,
        color: Colors.grey.shade600,
      ),
    );
  }

  void _onIncrement() {
    setState(() => _value = _value + widget.step);

    if (widget.onChanged != null) widget.onChanged(_value);
  }

  void _onDecrement() {
    if ((_value - widget.step) < widget.minValue) return null;
    setState(() => _value = _value - widget.step);

    if (widget.onChanged != null) widget.onChanged(_value);
  }
}
