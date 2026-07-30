import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class EmptyWidget extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyWidget({
    super.key,
    this.message = 'Nothing here yet',
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: colors.textSecondary),
          const SizedBox(height: 12),
          Text(message, style: TextStyle(color: colors.textSecondary, fontSize: 16)),
        ],
      ),
    );
  }
}