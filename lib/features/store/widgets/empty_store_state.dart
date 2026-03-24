import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class EmptyStoreState extends StatelessWidget {
  const EmptyStoreState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.picture_as_pdf, size: 80, color: AppColors.textTertiary),
          const SizedBox(height: 24),
          Text(
            'No PDFs stored',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 8),
          Text(
            'Add PDFs to get started! 📄',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
