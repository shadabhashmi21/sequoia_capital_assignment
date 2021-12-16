import 'package:flutter/material.dart';

class EditIcon extends StatelessWidget {
  final VoidCallback? onTap;
  const EditIcon({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: const Padding(
        padding: EdgeInsets.all(8),
        child: Icon(
          Icons.edit,
          size: 20,
          color: Colors.indigo,
        ),
      ),
      onTap: () => onTap?.call(),
    );
  }
}

class DeleteIcon extends StatelessWidget {
  final VoidCallback? onTap;
  const DeleteIcon({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: const Padding(
        padding: EdgeInsets.all(8),
        child: Icon(
          Icons.delete,
          size: 20,
          color: Colors.red,
        ),
      ),
      onTap: () => onTap?.call()
    );
  }
}
