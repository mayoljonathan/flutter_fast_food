import 'package:flutter/material.dart';

class AwesomeButton extends StatelessWidget {
  const AwesomeButton({
    Key key,
    @required this.text,
    @required this.onPressed,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 48.0,
      ),
      child: RawMaterialButton(
        elevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
        shape: StadiumBorder(),
        onPressed: onPressed,
        fillColor: Colors.black,
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 12.0,
        ),
        child: Text(
          text ?? '',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
