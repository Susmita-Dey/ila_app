import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/database_provider.dart';

class PhenotypeSetupSheet extends ConsumerStatefulWidget {
  const PhenotypeSetupSheet({super.key});

  @override
  ConsumerState<PhenotypeSetupSheet> createState() => _PhenotypeSetupSheetState();
}

class _PhenotypeSetupSheetState extends ConsumerState<PhenotypeSetupSheet> {
  String? _selectedPhenotype;
  bool _hasPCOM = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final db = ref.read(appDatabaseProvider);
    final profile = await db.clinicalProfileDao.getProfile();
    if (mounted) {
      setState(() {
        _selectedPhenotype = profile?.phenotype;
        _hasPCOM = profile?.hasPCOM ?? false;
        _isLoading = false;
      });
    }
  }

  Future<void> _save() async {
    final db = ref.read(appDatabaseProvider);
    await db.clinicalProfileDao.saveProfile(_selectedPhenotype, _hasPCOM);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: MediaQuery.of(context).padding.top + 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom + 24,
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
              'Clinical Profile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.deepInk,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Update your PCOS/PMOS phenotype for more accurate reports.',
              style: TextStyle(color: AppColors.mutedSage, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            const Text('Diagnosed Phenotype', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.deepInk)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['A', 'B', 'C', 'D'].map((p) {
                final isSelected = _selectedPhenotype == p;
                return FilterChip(
                  label: Text('Phenotype $p'),
                  selected: isSelected,
                  onSelected: (val) {
                    setState(() {
                      _selectedPhenotype = val ? p : null;
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
            const SizedBox(height: 24),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Polycystic Ovaries (PCOM)', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.deepInk)),
              subtitle: const Text('Confirmed via ultrasound', style: TextStyle(fontSize: 13, color: AppColors.mutedSage)),
              value: _hasPCOM,
              onChanged: (val) => setState(() => _hasPCOM = val),
              activeThumbColor: AppColors.brandAction,
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
              child: const Text('Save Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
