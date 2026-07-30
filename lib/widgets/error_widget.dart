import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'custom_button.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppErrorWidget({
    super.key,
    this.message = 'Something went wrong',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: colors.error),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: TextStyle(color: colors.textSecondary, fontSize: 16)),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              CustomButton(text: 'Retry', onPressed: onRetry!),
            ],
          ],
        ),
      ),
    );
  }
}