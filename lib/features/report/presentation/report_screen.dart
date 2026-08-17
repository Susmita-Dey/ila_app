import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import 'report_controller.dart';
import '../domain/report_payload.dart';
import '../../../core/widgets/illustrations/illustration_report.dart';
import '../../../core/providers/preferences_provider.dart';
import 'widgets/pdf_export_sheet.dart';

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
    final isRoutineGoal = ref.watch(isRoutineGoalProvider);

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
                emptySelectionAllowed: true,
                segments: const [
                  ButtonSegment(value: 3, label: Text('3 Months')),
                  ButtonSegment(value: 6, label: Text('6 Months')),
                  ButtonSegment(value: 0, label: Text('Custom')),
                ],
                selected: {_selectedMonths},
                onSelectionChanged: (Set<int> newSelection) async {
                  // If user taps the already selected segment, it returns empty.
                  final selection = newSelection.isEmpty ? _selectedMonths : newSelection.first;

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
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.lightBorder),
                  ),
                  child: state.isGenerating
                      ? const Center(child: CircularProgressIndicator())
                      : (data == null || data.isEmptyData)
                          ? _buildEmptyState(isCustomRange: _selectedMonths == 0)
                          : _buildDataView(data, isRoutineGoal),
                ),
              ),
              const SizedBox(height: 16),

              // Premium PDF Export Button
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.brandAction.withValues(alpha: 0.3)),
                  boxShadow: [
                    BoxShadow(color: AppColors.brandAction.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      onPressed: state.isGenerating || data == null
                          ? null
                          : () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => const PdfExportConfigSheet(),
                              );
                            },
                      icon: const Icon(Icons.picture_as_pdf_outlined),
                      label: const Text('Export Clinical PDF for Doctor', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brandAction,
                        foregroundColor: Colors.white,
                        iconColor: Colors.white,
                        disabledBackgroundColor: AppColors.lightBorder,
                        disabledIconColor: AppColors.mutedSage,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Generates a human-readable PDF summary of your cycle health, symptoms, and medications to share with your healthcare provider. (This is different from the encrypted .imyrabackup data file in Settings).',
                      style: TextStyle(fontSize: 12, color: AppColors.mutedSage, height: 1.4),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Empty State ──────────────────────────────────────────────────────────────

  Widget _buildEmptyState({bool isCustomRange = false}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const IllustrationReport(size: 140),
          const SizedBox(height: 20),
          Text(
            isCustomRange ? 'No data for this date range' : 'Your health story, visualised.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.deepInk,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              isCustomRange 
                ? 'We couldn\'t find any logged cycles, symptoms, or medications between the dates you selected. Try picking a wider date range.'
                : 'Log your period and medication for a cycle or two — then your cycle lengths, adherence, and symptom patterns will appear here.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.mutedSage, fontSize: 13, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  // ── Data View ────────────────────────────────────────────────────────────────

  Widget _buildDataView(DoctorReportData data, bool isRoutineGoal) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.dateRange,
            style: const TextStyle(color: AppColors.mutedSage, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // ── Charts row ─────────────────────────────────────────────────────
          Row(
            children: [
              // Adherence donut
              if (isRoutineGoal) ...[
                Expanded(
                  flex: 4,
                  child: _AdherenceDonut(percentage: data.adherencePercentage),
                ),
                const SizedBox(width: 16),
              ],
              // Cycle length bars
              Expanded(
                flex: 6,
                child: _CycleLengthBars(cycleRows: data.cycleRows),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: AppColors.lightBorder),
          const SizedBox(height: 12),

          // ── Text metrics ───────────────────────────────────────────────────
          _buildMetricRow('Cycles Recorded', '${data.totalCycles}'),
          const Divider(height: 16, color: AppColors.lightBorder),
          _buildMetricRow('Median Cycle Length', '${data.medianCycleLength} days'),
          const Divider(height: 16, color: AppColors.lightBorder),
          _buildMetricRow('Cycle Variation', '${data.cycleRangeMin} – ${data.cycleRangeMax} days'),
          if (isRoutineGoal) ...[
            const Divider(height: 16, color: AppColors.lightBorder),
            _buildMetricRow('Medication Adherence', '${data.adherencePercentage}%'),
          ],
          const SizedBox(height: 20),

          // ── Recent Cycles ──────────────────────────────────────────────────
          if (data.cycleRows.isNotEmpty) ...[
            const Text(
              'Recent Cycles',
              style: TextStyle(color: AppColors.deepInk, fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...data.cycleRows.take(3).map((row) => Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.softLavender.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          row[3], // length
                          style: const TextStyle(color: AppColors.deepInk, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${row[1]} – ${row[2]}',
                              style: const TextStyle(color: AppColors.deepInk, fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            if (row[4] != 'Unknown')
                              Text('Flow: ${row[4]}', style: const TextStyle(color: AppColors.mutedSage, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ],

          // ── Top Symptoms ───────────────────────────────────────────────────
          if (data.symptomPhaseClusters.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              'Top Symptoms',
              style: TextStyle(color: AppColors.deepInk, fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: data.symptomPhaseClusters.take(5).map((cluster) {
                return Chip(
                  label: Text('${cluster[0]} (${cluster[1]}x)', style: const TextStyle(fontSize: 12)),
                  backgroundColor: AppColors.brandLight,
                  labelStyle: const TextStyle(color: AppColors.brandAction),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.mutedSage, fontSize: 14, fontWeight: FontWeight.w500)),
        Text(value, style: const TextStyle(color: AppColors.deepInk, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// ── Adherence Donut Chart ─────────────────────────────────────────────────────

class _AdherenceDonut extends StatelessWidget {
  final int percentage;
  const _AdherenceDonut({required this.percentage});

  Color get _color {
    if (percentage >= 80) return const Color(0xFF22C55E); // green
    if (percentage >= 50) return const Color(0xFFF59E0B); // amber
    return AppColors.brandAction; // brand red
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 110,
          width: 110,
          child: CustomPaint(
            painter: _DonutPainter(
              percentage: percentage / 100.0,
              color: _color,
              trackColor: AppColors.lightBorder,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$percentage%',
                    style: TextStyle(
                      color: _color,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Adherence',
          style: TextStyle(color: AppColors.mutedSage, fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  final double percentage;
  final Color color;
  final Color trackColor;

  _DonutPainter({required this.percentage, required this.color, required this.trackColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 8;
    const strokeWidth = 12.0;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Track
    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc — starts at top (-π/2)
    final sweepAngle = 2 * math.pi * percentage;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_DonutPainter oldDelegate) =>
      oldDelegate.percentage != percentage || oldDelegate.color != color;
}

// ── Cycle Length Bar Chart ────────────────────────────────────────────────────

class _CycleLengthBars extends StatelessWidget {
  final List<List<String>> cycleRows;

  const _CycleLengthBars({required this.cycleRows});

  @override
  Widget build(BuildContext context) {
    // Extract cycle lengths from rows (index 3 = "XX days")
    final lengths = cycleRows.map((row) {
      final raw = row[3].replaceAll(RegExp(r'[^0-9]'), '');
      return int.tryParse(raw) ?? 0;
    }).where((v) => v > 0).toList();

    if (lengths.isEmpty) {
      return const SizedBox(
        height: 110,
        child: Center(
          child: Text(
            'No cycles recorded in this range.',
            style: TextStyle(color: AppColors.mutedSage, fontSize: 13),
          ),
        ),
      );
    }

    final maxVal = lengths.reduce(math.max);
    final median = _median(lengths);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 100,
          child: CustomPaint(
            painter: _BarChartPainter(
              values: lengths,
              maxValue: maxVal.toDouble(),
              barColor: AppColors.brandAction,
              medianColor: AppColors.deepInk.withValues(alpha: 0.25),
              median: median.toDouble(),
            ),
            size: Size.infinite,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Cycle Lengths',
          style: TextStyle(color: AppColors.mutedSage, fontSize: 12, fontWeight: FontWeight.w600),
        ),
        Text(
          'Median $median days',
          style: const TextStyle(color: AppColors.deepInk, fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  int _median(List<int> values) {
    final sorted = List<int>.from(values)..sort();
    final mid = sorted.length ~/ 2;
    return sorted.length.isOdd ? sorted[mid] : ((sorted[mid - 1] + sorted[mid]) / 2).round();
  }
}

class _BarChartPainter extends CustomPainter {
  final List<int> values;
  final double maxValue;
  final Color barColor;
  final Color medianColor;
  final double median;

  _BarChartPainter({
    required this.values,
    required this.maxValue,
    required this.barColor,
    required this.medianColor,
    required this.median,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty || maxValue == 0) return;

    final medianPaint = Paint()
      ..color = medianColor
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final count = values.length;
    final barSpacing = 4.0;
    final totalSpacing = barSpacing * (count - 1);
    final barWidth = (size.width - totalSpacing) / count;

    for (int i = 0; i < count; i++) {
      final barHeight = (values[i] / maxValue) * size.height;
      final left = i * (barWidth + barSpacing);
      final top = size.height - barHeight;

      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, barWidth, barHeight),
        const Radius.circular(4),
      );

      // Dim all except the most recent one slightly
      final opacity = i == count - 1 ? 0.9 : 0.45 + (i / count) * 0.35;
      canvas.drawRRect(rrect, Paint()..color = barColor.withValues(alpha: opacity));
    }

    // Median dashed line
    final medianY = size.height - (median / maxValue) * size.height;
    const dashWidth = 4.0;
    const dashGap = 3.0;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, medianY), Offset(math.min(x + dashWidth, size.width), medianY), medianPaint);
      x += dashWidth + dashGap;
    }
  }

  @override
  bool shouldRepaint(_BarChartPainter oldDelegate) => true;
}
