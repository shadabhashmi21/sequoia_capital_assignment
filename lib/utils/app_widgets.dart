import 'package:flutter/material.dart';

class CustomRadioButton extends StatelessWidget {
  final String text;
  final int value;
  int groupValue;
  final Function callback;

  CustomRadioButton(
      {Key? key,
        required this.text,
        required this.value,
        required this.groupValue,
        required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        callback(groupValue = value);
      },
      child: Row(
        children: [
          SizedBox(
            width: 25,
            height: 30,
            child: Radio(
                value: value,
                groupValue: groupValue,
                onChanged: (data) => callback(data)),
          ),
          Flexible(child: Text(text))
        ],
      ),
    );
  }
}