import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../cycle_controller.dart';

class QuickLogSheet extends ConsumerStatefulWidget {
  const QuickLogSheet({super.key});

  @override
  ConsumerState<QuickLogSheet> createState() => _QuickLogSheetState();
}

class _QuickLogSheetState extends ConsumerState<QuickLogSheet> {
  String? _selectedFlow;
  String? _selectedColor;
  String _selectedClots = 'None';
  bool _isFlooding = false;
  final List<String> _selectedSymptoms = [];

  final List<String> _flows = ['Spotting', 'Light', 'Medium', 'Heavy'];
  final List<String> _colors = ['🔴 Bright Red', '🟤 Dark Brown', '🌸 Pink'];
  final List<String> _clots = ['None', 'Small (< coin)', 'Large (> coin)'];
  final List<String> _symptoms = [
    'Pelvic Pain/Cramps',
    'Headache',
    'Backache',
    'Bloating',
    'Fatigue',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.warmIvory,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Log Period',
              style: TextStyle(
                color: AppColors.deepInk,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Flow
            const Text('Flow Intensity', style: TextStyle(color: AppColors.deepInk, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _flows.map((flow) => ChoiceChip(
                label: Text(flow),
                selected: _selectedFlow == flow,
                onSelected: (selected) => setState(() => _selectedFlow = selected ? flow : null),
                selectedColor: AppColors.deepInk,
                labelStyle: TextStyle(color: _selectedFlow == flow ? AppColors.warmIvory : AppColors.deepInk),
                backgroundColor: AppColors.cardBg,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              )).toList(),
            ),
            const SizedBox(height: 16),

            // Color
            const Text('Blood Color', style: TextStyle(color: AppColors.deepInk, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _colors.map((color) => ChoiceChip(
                label: Text(color),
                selected: _selectedColor == color,
                onSelected: (selected) => setState(() => _selectedColor = selected ? color : null),
                selectedColor: AppColors.deepInk,
                labelStyle: TextStyle(color: _selectedColor == color ? AppColors.warmIvory : AppColors.deepInk),
                backgroundColor: AppColors.cardBg,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              )).toList(),
            ),
            const SizedBox(height: 16),

            // Clots
            const Text('Clot Size', style: TextStyle(color: AppColors.deepInk, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _clots.map((clot) => ChoiceChip(
                label: Text(clot),
                selected: _selectedClots == clot,
                onSelected: (selected) => setState(() => _selectedClots = clot),
                selectedColor: AppColors.deepInk,
                labelStyle: TextStyle(color: _selectedClots == clot ? AppColors.warmIvory : AppColors.deepInk),
                backgroundColor: AppColors.cardBg,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              )).toList(),
            ),
            const SizedBox(height: 16),

            // Flooding
            const Text('Clinical Flags', style: TextStyle(color: AppColors.deepInk, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            FilterChip(
              label: const Text('⚡ Heavy Flooding (Soaking pad/tampon < 2 hrs)'),
              selected: _isFlooding,
              onSelected: (selected) => setState(() => _isFlooding = selected),
              selectedColor: Colors.red.shade100,
              checkmarkColor: Colors.red.shade900,
              labelStyle: TextStyle(color: _isFlooding ? Colors.red.shade900 : AppColors.deepInk),
              backgroundColor: AppColors.cardBg,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            const SizedBox(height: 16),

            // Symptoms
            const Text('Symptoms', style: TextStyle(color: AppColors.deepInk, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _symptoms.map((symptom) {
                final isSelected = _selectedSymptoms.contains(symptom);
                return FilterChip(
                  label: Text(symptom),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedSymptoms.add(symptom);
                      } else {
                        _selectedSymptoms.remove(symptom);
                      }
                    });
                  },
                  selectedColor: AppColors.mutedSage.withValues(alpha: 0.2),
                  checkmarkColor: AppColors.deepInk,
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.deepInk : AppColors.mutedSage,
                  ),
                  backgroundColor: AppColors.cardBg,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            // Save Button
            ElevatedButton(
              onPressed: _selectedFlow == null ? null : () async {
                String? parsedColor;
                if (_selectedColor != null) {
                  if (_selectedColor!.contains('Red')) parsedColor = 'BrightRed';
                  else if (_selectedColor!.contains('Brown')) parsedColor = 'DarkBrown';
                  else parsedColor = 'Pink';
                }

                String parsedClot = 'None';
                if (_selectedClots.contains('Small')) parsedClot = 'Small';
                else if (_selectedClots.contains('Large')) parsedClot = 'Large';

                await ref.read(cycleControllerProvider.notifier).logCycleEvent(
                  date: DateTime.now(),
                  flowType: _selectedFlow!,
                  bloodColor: parsedColor,
                  clotSize: parsedClot,
                  isFlooding: _isFlooding,
                  symptoms: _selectedSymptoms,
                );
                if (context.mounted) Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deepInk,
                foregroundColor: AppColors.warmIvory,
                disabledBackgroundColor: AppColors.lightBorder,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
              ),
              child: const Text('Save Entry', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}
