import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import 'today_controller.dart';
import '../../cycle/presentation/cycle_controller.dart';
import '../../cycle/presentation/widgets/quick_log_sheet.dart';
import '../../cycle/presentation/widgets/cycle_graph.dart';
import '../../routines/presentation/routine_setup_sheet.dart';
import 'widgets/phenotype_setup_sheet.dart';
import 'widgets/metabolic_log_sheet.dart';
import '../../../core/database/app_database.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/utils/dev_seed_data.dart';
import '../../../core/widgets/imyra_logo.dart';
import '../../../core/utils/snackbar_utils.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import '../../../core/widgets/illustrations/illustration_caught_up.dart';
import '../../../core/widgets/illustrations/illustration_routine.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayState = ref.watch(todayControllerProvider);
    final cycleState = ref.watch(cycleControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.warmIvory,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 80.0,
              floating: true,
              pinned: true,
              backgroundColor: AppColors.warmIvory,
              surfaceTintColor: Colors.transparent,
              leadingWidth: 140,
              leading: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ImyraLogo(size: 32),
                    const SizedBox(width: 12),
                    Text(
                      'Imyra',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                    ),
                  ],
                ),
              ),
              title: _buildHeader(context, cycleState.value?.currentCycleDay),
              actions: [
                // Debug-only: seed test data button — hidden in release builds
                if (kDebugMode)
                  IconButton(
                    icon: const Icon(Icons.science_outlined),
                    tooltip: 'Seed 6-Month Test Data',
                    onPressed: () async {
                      final db = ref.read(appDatabaseProvider);
                      await DevDataSeeder.seedSixMonths(db);
                      if (context.mounted) {
                        SnackbarUtils.show(
                          context: context,
                          title: 'Data Seeded',
                          message: 'Seeded 6 months of clinical records.',
                          contentType: ContentType.success,
                        );
                      }
                    },
                  ),
                IconButton(
                  icon: const Icon(Icons.settings_outlined, color: AppColors.deepInk),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const RoutineSetupSheet(),
                    );
                  },
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 64.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    todayState.when(
                      data: (state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (cycleState.value?.currentCycleDay != null) ...[
                              CycleGraph(currentDay: cycleState.value!.currentCycleDay!)
                                .animate()
                                .fadeIn(duration: 400.ms)
                                .slideY(begin: 0.1, end: 0, duration: 400.ms),
                                const SizedBox(height: 16),
                                _buildMetabolicCard(context),
                                const SizedBox(height: 16),
                                _buildPhenotypeCard(context),
                                const SizedBox(height: 32),
                              ],
                            if (state.missedRecentLogs.isNotEmpty)
                              _buildCatchUpDrawer(context, ref, state.missedRecentLogs),
                            if (state.activeRoutine == null)
                              _buildEmptyRoutineCard(context)
                            else
                              _buildMedicationCard(context, ref, state),
                          ],
                        ).animate().fade(duration: 400.ms).slideY(begin: 0.05, end: 0);
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Text('Error: $err'),
                    ),
                    const SizedBox(height: 16),
                    _buildCycleCard(context, cycleState.value),
                    const SizedBox(height: 32),
                    if (todayState.value?.missedRecentLogs.isEmpty == true &&
                        todayState.value?.todayLog?.status == 'Taken')
                      Center(
                        child: Column(
                          children: [
                            const IllustrationCaughtUp(size: 150),
                            const SizedBox(height: 24),
                            Text(
                              "You're all caught up.",
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.charcoalInk,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Returns a contextually appropriate greeting based on the time of day.
  static String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning.';
    if (hour < 17) return 'Good afternoon.';
    if (hour < 21) return 'Good evening.';
    return 'Good night.';
  }

  Widget _buildHeader(BuildContext context, int? cycleDay) {
    final now = DateTime.now();
    final dateStr = DateFormat('d MMM').format(now);
    final cycleStr = cycleDay != null
        ? AppLocalizations.of(context)!.cycleDay(cycleDay)
        : AppLocalizations.of(context)!.logCycle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getGreeting(),
          style: const TextStyle(
            color: AppColors.deepInk,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$cycleStr · $dateStr',
          style: const TextStyle(
            color: AppColors.mutedSage,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCatchUpDrawer(BuildContext context, WidgetRef ref, List<RoutineLog> missedLogs) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.subtlePeach.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.subtlePeach.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Catch Up',
            style: TextStyle(
              color: AppColors.deepInk,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...missedLogs.map((log) {
            final isYesterday = DateTime.now().difference(log.scheduledDate).inDays == 1;
            final dateLabel = isYesterday ? 'Yesterday' : DateFormat('EEEE').format(log.scheduledDate);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateLabel,
                    style: const TextStyle(color: AppColors.deepInk, fontSize: 14),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => ref.read(todayControllerProvider.notifier).markSkipped(log.scheduledDate),
                        child: const Text('Missed', style: TextStyle(color: AppColors.mutedSage)),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: const TimeOfDay(hour: 8, minute: 0),
                            helpText: 'When did you take this?',
                          );
                          if (time != null) {
                            final customDate = DateTime(
                              log.scheduledDate.year,
                              log.scheduledDate.month,
                              log.scheduledDate.day,
                              time.hour,
                              time.minute,
                            );
                            ref.read(todayControllerProvider.notifier).markTaken(log.scheduledDate, completedAt: customDate);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brandAction,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          // Override the global double.infinity minimumSize —
                          // this button lives in a Row and must not be full-width.
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Taken'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEmptyRoutineCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const RoutineSetupSheet(),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: const Column(
          children: [
            IllustrationRoutine(size: 100),
            SizedBox(height: 16),
            Text(
              'Set up a medication routine',
              style: TextStyle(
                color: AppColors.charcoalInk,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationCard(BuildContext context, WidgetRef ref, TodayState state) {
    final phase = state.phaseState;
    if (phase == null) return const SizedBox.shrink();

    final isTaken = state.todayLog?.status == 'Taken';
    final isBreak = phase.isBreakPeriod;

    final routineName = state.activeRoutine?.name ?? 'Medicine';
    // Use dose if it exists, otherwise empty
    final routineDose = state.activeRoutine?.dose != null && state.activeRoutine!.dose!.isNotEmpty 
      ? ' (${state.activeRoutine!.dose})' : '';

    String phaseText = isBreak 
      ? '🌿 Treatment Break · Day ${phase.dayInPhase} / ${phase.totalPhaseDays}'
      : (phase.totalPhaseDays == null)
        ? '💊 $routineName$routineDose · Day ${phase.dayInPhase}'
        : '💊 $routineName$routineDose · Day ${phase.dayInPhase} / ${phase.totalPhaseDays}';

    String subText = isBreak 
      ? 'No medication required today.'
      : 'Scheduled for ${state.activeRoutine?.reminderTime}';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            phaseText,
            style: const TextStyle(
              color: AppColors.deepInk,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subText,
            style: const TextStyle(
              color: AppColors.mutedSage,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          if (!isBreak)
            SizedBox(
              width: double.infinity,
              height: 56,
              child: isTaken
                  ? OutlinedButton.icon(
                      // null disables the button with proper Material greyed-out styling
                      // rather than an empty () {} which keeps it tappable with no effect.
                      onPressed: null,
                      icon: const Icon(Icons.check, color: AppColors.mutedSage),
                      label: Text(
                        'Taken at ${DateFormat('h:mm a').format(state.todayLog!.completedAt ?? DateTime.now())}',
                        style: const TextStyle(color: AppColors.mutedSage),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.lightBorder),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        ref.read(todayControllerProvider.notifier).markTaken(DateTime.now());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brandAction,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const Text('Mark as Taken', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
            ),
        ],
      ),
    );
  }

  Widget _buildCycleCard(BuildContext context, CycleState? state) {
    final cycleDay = state?.currentCycleDay;
    final mostRecentEvent = state?.recentEvents.isNotEmpty == true ? state!.recentEvents.first : null;
    final isAnovulatory = mostRecentEvent?.flowType == 'Anovulatory';

    String subtitle = 'Tap to log your period';
    if (cycleDay != null) {
      subtitle = 'Currently on Day $cycleDay';
    } else if (isAnovulatory) {
      subtitle = 'Anovulatory cycle logged';
    } else if (state?.estimatedCycleDay != null) {
      subtitle = 'Cycle Day ~${state!.estimatedCycleDay} (estimated)';
    }

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const QuickLogSheet(),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.softLavender.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.brandAction.withValues(alpha: 0.3), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cycle Log',
                  style: TextStyle(
                    color: AppColors.deepInk,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.mutedSage,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.brandAction),
          ],
        ),
      ),
    );
  }

  Widget _buildMetabolicCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const MetabolicLogSheet(),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.subtlePeach.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.subtlePeach.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Metabolic Tracking',
                  style: TextStyle(color: AppColors.deepInk, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text('Weight, Waist-to-Hip, Signs', style: TextStyle(color: AppColors.mutedSage, fontSize: 14)),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(color: AppColors.cardBg, shape: BoxShape.circle),
              child: const Icon(Icons.monitor_weight_outlined, color: AppColors.charcoalInk),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhenotypeCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const PhenotypeSetupSheet(),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.brandAction.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.brandAction.withValues(alpha: 0.15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Clinical Profile',
                  style: TextStyle(color: AppColors.deepInk, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text('Rotterdam Phenotype Config', style: TextStyle(color: AppColors.mutedSage, fontSize: 14)),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(color: AppColors.cardBg, shape: BoxShape.circle),
              child: const Icon(Icons.medical_information_outlined, color: AppColors.brandAction),
            ),
          ],
        ),
      ),
    );
  }
}

