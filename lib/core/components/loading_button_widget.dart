import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  final String text;
  const LoadingButton({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: null,
      child: Text(text),
    );
  }
}
