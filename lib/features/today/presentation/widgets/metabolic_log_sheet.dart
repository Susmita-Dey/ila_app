import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/database_provider.dart';

class MetabolicLogSheet extends ConsumerStatefulWidget {
  const MetabolicLogSheet({super.key});

  @override
  ConsumerState<MetabolicLogSheet> createState() => _MetabolicLogSheetState();
}

class _MetabolicLogSheetState extends ConsumerState<MetabolicLogSheet> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _waistController = TextEditingController();
  final TextEditingController _hipController = TextEditingController();
  
  final List<String> _selectedSigns = [];
  final List<String> _commonSigns = [
    'Acanthosis Nigricans',
    'Severe Sugar Cravings',
    'Extreme Fatigue',
    'Skin Tags',
  ];

  @override
  void dispose() {
    _weightController.dispose();
    _waistController.dispose();
    _hipController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final weight = double.tryParse(_weightController.text);
    final waist = double.tryParse(_waistController.text);
    final hip = double.tryParse(_hipController.text);
    final signs = _selectedSigns.isNotEmpty ? _selectedSigns.join(', ') : null;

    final db = ref.read(appDatabaseProvider);
    await db.metabolicLogDao.addLog(
      weight: weight,
      waistCircumference: waist,
      hipCircumference: hip,
      signs: signs,
    );
    
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
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
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.lightBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Metabolic Metrics',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.deepInk),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Body Metrics
            const Text('Body Composition', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.deepInk)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Weight (kg)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _waistController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Waist (cm)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _hipController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Hip (cm)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Signs of Insulin Resistance
            const Text('Clinical Signs (Insulin Resistance)', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.deepInk)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _commonSigns.map((sign) {
                final isSelected = _selectedSigns.contains(sign);
                return FilterChip(
                  label: Text(sign),
                  selected: isSelected,
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        _selectedSigns.add(sign);
                      } else {
                        _selectedSigns.remove(sign);
                      }
                    });
                  },
                  selectedColor: AppColors.brandAction.withValues(alpha: 0.1),
                  checkmarkColor: AppColors.brandAction,
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.brandAction : AppColors.deepInk,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deepInk,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Save Log', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
