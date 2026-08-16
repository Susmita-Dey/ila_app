import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import 'report_controller.dart';

import '../../../core/widgets/illustrations/illustration_report.dart';

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  int _selectedMonths = 3;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reportControllerProvider.notifier).generatePreview(_selectedMonths);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reportControllerProvider);
    final data = state.previewData;

    return Scaffold(
      backgroundColor: AppColors.warmIvory,
      appBar: AppBar(
        title: const Text('My Insights'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Range Selector
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 3, label: Text('3 Months')),
                  ButtonSegment(value: 6, label: Text('6 Months')),
                  ButtonSegment(value: 0, label: Text('Custom')),
                ],
                selected: {_selectedMonths},
                onSelectionChanged: (Set<int> newSelection) async {
                  final selection = newSelection.first;
                  
                  if (selection == 0) {
                    final now = DateTime.now();
                    final picked = await showDateRangePicker(
                      context: context,
                      firstDate: now.subtract(const Duration(days: 365 * 10)),
                      lastDate: now,
                    );
                    
                    if (picked != null) {
                      setState(() => _selectedMonths = 0);
                      ref.read(reportControllerProvider.notifier).generatePreviewForRange(picked.start, picked.end);
                    }
                  } else {
                    setState(() => _selectedMonths = selection);
                    ref.read(reportControllerProvider.notifier).generatePreview(selection);
                  }
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                    if (states.contains(WidgetState.selected)) return AppColors.deepInk;
                    return AppColors.cardBg;
                  }),
                  foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                    if (states.contains(WidgetState.selected)) return AppColors.warmIvory;
                    return AppColors.deepInk;
                  }),
                ),
              ),
              const SizedBox(height: 24),

              // Preview Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.lightBorder),
                  ),
                  child: state.isGenerating
                      ? const Center(child: CircularProgressIndicator())
                      : (data == null || data.totalCycles == 0)
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IllustrationReport(size: 140),
                                  SizedBox(height: 16),
                                  Text(
                                    'No data available for this period.',
                                    style: TextStyle(color: AppColors.mutedSage),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.dateRange,
                                  style: const TextStyle(
                                    color: AppColors.mutedSage,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                _buildMetricRow('Cycles Recorded', '${data.totalCycles}'),
                                const Divider(height: 32, color: AppColors.lightBorder),
                                _buildMetricRow('Median Cycle Length', '${data.medianCycleLength} days'),
                                const Divider(height: 32, color: AppColors.lightBorder),
                                _buildMetricRow('Cycle Variation', '${data.cycleRangeMin} – ${data.cycleRangeMax} days'),
                                const Divider(height: 32, color: AppColors.lightBorder),
                                _buildMetricRow('Medication Adherence', '${data.adherencePercentage}%'),
                              ],
                            ),
                ),
              ),
              const SizedBox(height: 24),

              // Export Button
              ElevatedButton.icon(
                onPressed: state.isGenerating || data == null || data.totalCycles == 0
                    ? null
                    : () {
                        ref.read(reportControllerProvider.notifier).exportPdf();
                      },
                icon: const Icon(Icons.ios_share),
                label: const Text('Generate Doctor Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandAction,
                  foregroundColor: Colors.white,
                  iconColor: Colors.white, // Explicit white icon
                  disabledBackgroundColor: AppColors.lightBorder,
                  disabledIconColor: AppColors.mutedSage,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.deepInk,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.deepInk,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
