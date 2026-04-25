import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.isRectangle = false,
    this.color,
  });

  final String buttonText;
  final Function()? onPressed;
  final Color? color;
  final bool isRectangle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(isRectangle ? 8 : 25),
          ),
        ),
        fixedSize: Size(MediaQuery.sizeOf(context).width, 45),
      ),
      child: Text(
        buttonText,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
    );
  }
}
