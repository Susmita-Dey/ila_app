import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/diagnostics/diagnostics_service.dart';

class FeedbackDialog extends StatefulWidget {
  const FeedbackDialog({super.key});

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  final TextEditingController _textController = TextEditingController();
  String _selectedCategory = 'Bug / Error';
  bool _includeDiagnostics = true;

  final List<String> _categories = [
    'Bug / Error',
    'Confusing UX / Text',
    'Feature Suggestion',
  ];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final feedback = _textController.text.trim();
    if (feedback.isEmpty) return;

    Navigator.of(context).pop();

    await DiagnosticsService.exportDiagnosticsPackage(
      userFeedback: feedback,
      category: _selectedCategory,
      includeDiagnostics: _includeDiagnostics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.warmIvory,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text(
        'Test Feedback',
        style: TextStyle(
          color: AppColors.deepInk,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedCategory = cat);
                  },
                  selectedColor: AppColors.deepInk,
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.warmIvory : AppColors.deepInk,
                  ),
                  backgroundColor: AppColors.cardBg,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _textController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'What happened, or what felt confusing?',
                hintStyle: const TextStyle(color: AppColors.mutedSage),
                filled: true,
                fillColor: AppColors.cardBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.lightBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.lightBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.deepInk),
                ),
              ),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Include anonymous system diagnostics log',
                style: TextStyle(fontSize: 14, color: AppColors.deepInk),
              ),
              value: _includeDiagnostics,
              activeColor: AppColors.deepInk,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (val) {
                setState(() {
                  _includeDiagnostics = val ?? true;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: AppColors.mutedSage)),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.brandAction,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Share Feedback'),
        ),
      ],
    );
  }
}
