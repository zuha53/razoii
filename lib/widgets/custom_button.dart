import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/app_constants.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  double scale = 1.0;

  void _onTapDown(TapDownDetails details) => setState(() => scale = 0.96);
  void _onTapUp(TapUpDetails details) => setState(() => scale = 1.0);
  void _onTapCancel() => setState(() => scale = 1.0);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 100),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: widget.isOutlined
              ? OutlinedButton(
                  onPressed: widget.onPressed,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colors.gold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                    ),
                  ),
                  child: Text(widget.text, style: TextStyle(color: colors.gold, fontSize: 16)),
                )
              : ElevatedButton(
                  onPressed: widget.onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.gold,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                    ),
                  ),
                  child: Text(
                    widget.text,
                    style: TextStyle(color: colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
        ),
      ),
    );
  }
}