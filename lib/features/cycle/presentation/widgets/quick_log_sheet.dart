import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../cycle_controller.dart';

class QuickLogSheet extends ConsumerStatefulWidget {
  const QuickLogSheet({super.key});

  @override
  ConsumerState<QuickLogSheet> createState() => _QuickLogSheetState();
}

class _QuickLogSheetState extends ConsumerState<QuickLogSheet> {
  // ── Flow ────────────────────────────────────────────────────────────────────
  String? _selectedFlow;
  String? _selectedColor;
  String _selectedClots = 'None';
  bool _isFlooding = false;

  // ── Cycle start disambiguation ──────────────────────────────────────────────
  // Auto-set: Heavy/Medium → true; Spotting → false. User can override.
  bool _isTrueCycleStart = true;
  bool _cycleStartManuallyOverridden = false;

  // ── Pain (NRS) ──────────────────────────────────────────────────────────────
  int _painIntensity = 0;    // 0 = no pain; slider goes 0–10
  bool _painReliefTaken = false;

  // ── Symptoms ────────────────────────────────────────────────────────────────
  final List<String> _selectedSymptoms = [];
  final TextEditingController _customSymptomController = TextEditingController();

  @override
  void dispose() {
    _customSymptomController.dispose();
    super.dispose();
  }

  // ── Constants ───────────────────────────────────────────────────────────────
  static const _flows = ['Spotting', 'Light', 'Medium', 'Heavy'];
  static const _colors = ['🔴 Bright Red', '🟤 Dark Brown', '🌸 Pink'];
  static const _clots = ['None', 'Small (< coin)', 'Large (> coin)'];

  /// Three clinically organized symptom categories.
  static const Map<String, List<String>> _symptomCategories = {
    'Pelvic & Cycle': [
      'Pelvic Pain',
      'Cramps',
      'Ovulation Pain (Mittelschmerz)',
      'Lower Backache',
    ],
    'PCOS & Androgenic': [
      'Cystic Acne',
      'Hair Thinning',
      'Hirsutism (Facial/Body Hair)',
      'Severe Bloating',
      'Brain Fog',
    ],
    'Systemic & Mood': [
      'Extreme Fatigue',
      'Mood Lability / Irritability',
      'Anxiety',
      'Insomnia / Sleep Disruption',
    ],
  };

  // ── Pain helpers ─────────────────────────────────────────────────────────────
  String _painLabel(int v) {
    if (v == 0) return 'No pain';
    if (v <= 3) return '$v / 10 — Mild (manageable)';
    if (v <= 6) return '$v / 10 — Moderate (interferes with daily tasks)';
    if (v <= 9) return '$v / 10 — Severe (disabling)';
    return '10 / 10 — Unbearable';
  }

  Color _painColor(int v) {
    if (v == 0) return AppColors.mutedSage;
    if (v <= 3) return const Color(0xFF22C55E); // green-500
    if (v <= 6) return const Color(0xFFF59E0B); // amber-500
    if (v <= 9) return const Color(0xFFEF4444); // red-500
    return const Color(0xFF7F1D1D);             // red-900
  }

  // ── Anovulatory logging ──────────────────────────────────────────────────────
  Future<void> _logAnovulatoryMonth() async {
    await ref.read(cycleControllerProvider.notifier).logAnovulatoryMonth();
    if (mounted) Navigator.of(context).pop();
  }

  // ── Save bleeding event ──────────────────────────────────────────────────────
  Future<void> _save() async {
    if (_selectedFlow == null) return;

    String? parsedColor;
    if (_selectedColor != null) {
      if (_selectedColor!.contains('Red')) {
        parsedColor = 'BrightRed';
      } else if (_selectedColor!.contains('Brown')) {
        parsedColor = 'DarkBrown';
      } else {
        parsedColor = 'Pink';
      }
    }

    String parsedClot = 'None';
    if (_selectedClots.contains('Small')) parsedClot = 'Small';
    if (_selectedClots.contains('Large')) parsedClot = 'Large';

    await ref.read(cycleControllerProvider.notifier).logCycleEvent(
      date: DateTime.now(),
      flowType: _selectedFlow!,
      bloodColor: parsedColor,
      clotSize: parsedClot,
      isFlooding: _isFlooding,
      isTrueCycleStart: _isTrueCycleStart,
      // Store null if pain wasn't touched (0 from default) — ambiguous for analytics.
      // A slider movement changes _painIntensity; we track this via the onChanged callback.
      painIntensity: _painIntensity,
      painReliefTaken: _painReliefTaken,
      symptoms: _selectedSymptoms,
    );

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 24,
        left: 24,
        right: 24,
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
            // ── Sheet title ────────────────────────────────────────────────
            const Text(
              'Log Period',
              style: TextStyle(
                color: AppColors.deepInk,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // ── Anovulatory escape hatch ───────────────────────────────────
            _buildAnovulatoryBanner(),
            const SizedBox(height: 20),

            // ── Flow Intensity ─────────────────────────────────────────────
            _buildSectionLabel('Flow Intensity'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _flows.map((flow) => ChoiceChip(
                label: Text(flow),
                selected: _selectedFlow == flow,
                onSelected: (selected) {
                  setState(() {
                    _selectedFlow = selected ? flow : null;
                    // Auto-suggest isTrueCycleStart unless the user already
                    // made a deliberate manual override.
                    if (selected && !_cycleStartManuallyOverridden) {
                      _isTrueCycleStart =
                          (flow == 'Heavy' || flow == 'Medium');
                    }
                  });
                },
                selectedColor: AppColors.deepInk,
                checkmarkColor: AppColors.warmIvory,
                labelStyle: TextStyle(
                  color: _selectedFlow == flow
                      ? AppColors.warmIvory
                      : AppColors.deepInk,
                ),
                backgroundColor: AppColors.cardBg,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              )).toList(),
            ),
            const SizedBox(height: 16),

            // ── Cycle Start Disambiguation toggle ──────────────────────────
            _buildCycleStartToggle(),
            const SizedBox(height: 16),

            // ── Blood Color ────────────────────────────────────────────────
            _buildSectionLabel('Blood Color'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _colors.map((color) {
                Color chipColor() {
                  if (color.contains('Pink')) return AppColors.dustyBlush;
                  if (color.contains('Brown')) return AppColors.clayTerracotta;
                  return AppColors.charcoalInk;
                }
                return ChoiceChip(
                  label: Text(color),
                  selected: _selectedColor == color,
                  onSelected: (s) =>
                      setState(() => _selectedColor = s ? color : null),
                  selectedColor: chipColor(),
                  checkmarkColor: AppColors.warmIvory,
                  labelStyle: TextStyle(
                    color: _selectedColor == color
                        ? AppColors.warmIvory
                        : AppColors.deepInk,
                  ),
                  backgroundColor: AppColors.cardBg,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: _selectedColor == color
                          ? AppColors.charcoalInk
                          : Colors.transparent,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // ── Clot Size ──────────────────────────────────────────────────
            _buildSectionLabel('Clot Size'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _clots.map((clot) => ChoiceChip(
                label: Text(clot),
                selected: _selectedClots == clot,
                onSelected: (_) => setState(() => _selectedClots = clot),
                selectedColor: AppColors.deepInk,
                checkmarkColor: AppColors.warmIvory,
                labelStyle: TextStyle(
                  color: _selectedClots == clot
                      ? AppColors.warmIvory
                      : AppColors.deepInk,
                ),
                backgroundColor: AppColors.cardBg,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              )).toList(),
            ),
            const SizedBox(height: 16),

            // ── Clinical Flags ─────────────────────────────────────────────
            _buildSectionLabel('Clinical Flags'),
            const SizedBox(height: 10),
            FilterChip(
              label: const Text('⚡ Heavy Flooding (soaking pad/tampon < 2 hrs)'),
              selected: _isFlooding,
              onSelected: (v) => setState(() => _isFlooding = v),
              selectedColor: Colors.red.shade100,
              checkmarkColor: Colors.red.shade900,
              labelStyle: TextStyle(
                  color: _isFlooding ? Colors.red.shade900 : AppColors.deepInk),
              backgroundColor: AppColors.cardBg,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            const SizedBox(height: 20),

            // ── Pain Intensity (NRS) ────────────────────────────────────────
            _buildPainSection(),
            const SizedBox(height: 20),

            // ── Symptoms (3 clinical categories) ───────────────────────────
            _buildSectionLabel('Symptoms'),
            const SizedBox(height: 12),
            ..._symptomCategories.entries.map((entry) =>
                _buildSymptomCategory(entry.key, entry.value)),

            // ── Custom Symptoms ────────────────────────────────────────────
            const SizedBox(height: 12),
            _buildSectionLabel('Custom Symptoms'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _customSymptomController,
                    decoration: InputDecoration(
                      hintText: 'e.g. Endo Belly, Hot Flashes',
                      hintStyle: const TextStyle(color: AppColors.mutedSage, fontSize: 13),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: (val) => _addCustomSymptom(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _addCustomSymptom,
                  icon: const Icon(Icons.add_circle, color: AppColors.deepInk),
                ),
              ],
            ),
            if (_selectedSymptoms.where((s) => !_symptomCategories.values.expand((l) => l).contains(s)).isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedSymptoms
                    .where((s) => !_symptomCategories.values.expand((l) => l).contains(s))
                    .map((symptom) {
                  return FilterChip(
                    label: Text(symptom, style: const TextStyle(fontSize: 12)),
                    selected: true,
                    onSelected: (_) {
                      setState(() {
                        _selectedSymptoms.remove(symptom);
                      });
                    },
                    selectedColor: AppColors.deepInk.withValues(alpha: 0.1),
                    checkmarkColor: AppColors.deepInk,
                    labelStyle: const TextStyle(
                      color: AppColors.deepInk,
                      fontWeight: FontWeight.w600,
                    ),
                    backgroundColor: AppColors.cardBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.transparent),
                    ),
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 32),

            // ── Save Button ────────────────────────────────────────────────
            ElevatedButton(
              onPressed: _selectedFlow == null ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandAction,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.lightBorder,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
              ),
              child: const Text('Save Entry',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ]
              .animate(interval: 40.ms)
              .fadeIn(duration: 250.ms)
              .slideY(begin: 0.08, duration: 250.ms),
        ),
      ),
    );
  }

  // ── Sub-widget builders ──────────────────────────────────────────────────────

  void _addCustomSymptom() {
    final text = _customSymptomController.text.trim();
    if (text.isNotEmpty && !_selectedSymptoms.contains(text)) {
      setState(() {
        _selectedSymptoms.add(text);
        _customSymptomController.clear();
      });
    }
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.deepInk,
        fontSize: 15,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
    );
  }

  /// Top banner that lets a user bypass the form and log an anovulatory month.
  Widget _buildAnovulatoryBanner() {
    return GestureDetector(
      onTap: _logAnovulatoryMonth,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.softLavender.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: AppColors.softLavender.withValues(alpha: 0.35)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.softLavender.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.calendar_month_outlined,
                  size: 18, color: AppColors.deepInk),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'No bleed this month?',
                    style: TextStyle(
                      color: AppColors.deepInk,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Tap to log an anovulatory / missed cycle for your clinical record.',
                    style: TextStyle(
                      color: AppColors.mutedSage,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                size: 18, color: AppColors.mutedSage),
          ],
        ),
      ),
    );
  }

  /// isTrueCycleStart toggle — auto-suggested by flow, user can override.
  Widget _buildCycleStartToggle() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: SwitchListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: const Text(
          'Day 1 of a new cycle?',
          style: TextStyle(
            color: AppColors.deepInk,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          _isTrueCycleStart
              ? 'Marked as the start of a new cycle — affects cycle length in your report.'
              : 'Switch on if this is Day 1. Off = mid-cycle spotting / breakthrough bleeding.',
          style: const TextStyle(
            color: AppColors.mutedSage,
            fontSize: 12,
            height: 1.4,
          ),
        ),
        value: _isTrueCycleStart,
        activeThumbColor: AppColors.brandAction,
        onChanged: (val) {
          setState(() {
            _isTrueCycleStart = val;
            _cycleStartManuallyOverridden = true;
          });
        },
      ),
    );
  }

  /// NRS 0–10 pain slider with colour-coded label.
  Widget _buildPainSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionLabel('Pain Intensity (NRS)'),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                _painLabel(_painIntensity),
                key: ValueKey(_painIntensity),
                style: TextStyle(
                  color: _painColor(_painIntensity),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Text('0',
                style: TextStyle(
                    color: AppColors.mutedSage,
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: _painColor(_painIntensity),
                  thumbColor: _painColor(_painIntensity),
                  inactiveTrackColor: AppColors.lightBorder,
                  overlayColor:
                      _painColor(_painIntensity).withValues(alpha: 0.15),
                  trackHeight: 5,
                ),
                child: Slider(
                  value: _painIntensity.toDouble(),
                  min: 0,
                  max: 10,
                  divisions: 10,
                  label: _painIntensity.toString(),
                  onChanged: (val) =>
                      setState(() => _painIntensity = val.toInt()),
                ),
              ),
            ),
            const Text('10',
                style: TextStyle(
                    color: AppColors.mutedSage,
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 8),
        FilterChip(
          label: const Text('Took pain relief medication'),
          selected: _painReliefTaken,
          onSelected: (v) => setState(() => _painReliefTaken = v),
          selectedColor: AppColors.mutedSage.withValues(alpha: 0.15),
          checkmarkColor: AppColors.deepInk,
          labelStyle: TextStyle(
            color: _painReliefTaken ? AppColors.deepInk : AppColors.mutedSage,
            fontSize: 13,
          ),
          backgroundColor: AppColors.cardBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ],
    );
  }

  /// One expandable category block of symptom chips.
  Widget _buildSymptomCategory(String category, List<String> symptoms) {
    // Category accent colors
    final Color accent;
    final Color accentBg;
    if (category.contains('PCOS')) {
      accent = AppColors.brandAction;
      accentBg = AppColors.brandLight;
    } else if (category.contains('Systemic')) {
      accent = AppColors.softLavender;
      accentBg = AppColors.softLavender.withValues(alpha: 0.12);
    } else {
      accent = AppColors.mutedSage;
      accentBg = AppColors.mutedSage.withValues(alpha: 0.10);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: accentBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              category,
              style: TextStyle(
                color: accent,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: symptoms.map((symptom) {
              final isSelected = _selectedSymptoms.contains(symptom);
              return FilterChip(
                label: Text(symptom,
                    style: const TextStyle(fontSize: 12)),
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
                selectedColor: accentBg,
                checkmarkColor: accent,
                labelStyle: TextStyle(
                  color: isSelected ? accent : AppColors.mutedSage,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                backgroundColor: AppColors.cardBg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: isSelected
                        ? accent.withValues(alpha: 0.4)
                        : Colors.transparent,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
