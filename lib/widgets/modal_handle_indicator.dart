import 'package:flutter/material.dart';

class ModalHandleIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.0),
        color: Colors.grey.shade200,
      ),
      height: 6.0,
      width: 60.0,
    );
  }
}
