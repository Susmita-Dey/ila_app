import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/quote_service.dart';
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
import '../../../core/providers/preferences_provider.dart';

class TodayScreen extends ConsumerWidget {
  /// Called when the user taps the settings icon — lets the parent shell
  /// switch the bottom-nav to the Settings tab without a push route.
  final VoidCallback? onNavigateToSettings;
  const TodayScreen({super.key, this.onNavigateToSettings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayState = ref.watch(todayControllerProvider);
    final cycleState = ref.watch(cycleControllerProvider);
    final isRoutineGoal = ref.watch(isRoutineGoalProvider);
    final isAdvancedClinical = ref.watch(advancedClinicalTrackingProvider);

    return Scaffold(
      backgroundColor: AppColors.warmIvory,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Minimal logo app bar ──────────────────────────────────────────
            SliverAppBar(
              floating: true,
              pinned: false,
              backgroundColor: AppColors.warmIvory,
              surfaceTintColor: Colors.transparent,
              toolbarHeight: 56,
              leadingWidth: 140,
              leading: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ImyraLogo(size: 28),
                    const SizedBox(width: 10),
                    Text(
                      'imyra',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                            color: AppColors.brandAction,
                          ),
                    ),
                  ],
                ),
              ),
              actions: [
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
                  icon: const Icon(Icons.add_circle_outline,
                      color: AppColors.deepInk, size: 22),
                  tooltip: 'Add Medication',
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const RoutineSetupSheet(),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings_outlined,
                      color: AppColors.deepInk, size: 22),
                  tooltip: 'Settings',
                  onPressed: () {
                    onNavigateToSettings?.call();
                  },
                ),
              ],
            ),

            // ── Body ──────────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 4.0, bottom: 64.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Premium greeting block ──────────────────────────────
                    _GreetingBlock(cycleDay: cycleState.value?.currentCycleDay),
                    const SizedBox(height: 20),

                    todayState.when(
                      data: (state) => Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Cycle graph (if tracking)
                          if (cycleState.value?.currentCycleDay != null) ...[
                            CycleGraph(
                                    currentDay:
                                        cycleState.value!.currentCycleDay!)
                                .animate()
                                .fadeIn(duration: 400.ms)
                                .slideY(begin: 0.1, end: 0, duration: 400.ms),
                            const SizedBox(height: 12),
                            
                            // Clinical & Metabolic Cards (Progressive Disclosure)
                            if (isAdvancedClinical) ...[
                              _buildMetabolicCard(context),
                              const SizedBox(height: 12),
                              _buildPhenotypeCard(context),
                              const SizedBox(height: 24),
                            ],
                          ],

                          // Catch-up drawer
                          if (state.missedRecentLogs.isNotEmpty)
                            _buildCatchUpDrawer(context, ref, state.missedRecentLogs),

                          // Medication cards (one per active routine)
                          if (state.routineCards.isEmpty && isRoutineGoal)
                            _buildEmptyRoutineCard(context)
                          else if (state.routineCards.isNotEmpty)
                            ...state.routineCards.map((card) =>
                                _MedicationCard(
                                  key: ValueKey(card.routine.id),
                                  cardState: card,
                                  onMarkTaken: () =>
                                      ref.read(todayControllerProvider.notifier)
                                          .markTaken(DateTime.now(),
                                              routineId: card.routine.id),
                                  onEdit: () => showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (_) => RoutineSetupSheet(
                                        routine: card.routine),
                                  ),
                                  onDelete: () => _confirmDelete(
                                      context, ref, card.routine),
                                )),

                          // Add another medicine button (when at least one exists)
                          if (state.routineCards.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: OutlinedButton.icon(
                                onPressed: () => showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => const RoutineSetupSheet(),
                                ),
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text('Add another medication'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.deepInk,
                                  minimumSize: const Size(0, 44),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  side: const BorderSide(
                                      color: AppColors.lightBorder),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                        ],
                      ).animate().fade(duration: 400.ms).slideY(begin: 0.05),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (err, _) => Text('Error: $err'),
                    ),

                    const SizedBox(height: 16),
                    _buildCycleCard(context, cycleState.value),
                    const SizedBox(height: 32),

                    // All caught up state
                    if (todayState.value?.missedRecentLogs.isEmpty == true &&
                        todayState.value?.routineCards
                                .every((c) => c.todayLog?.status == 'Taken') ==
                            true &&
                        todayState.value!.routineCards.isNotEmpty)
                      Center(
                        child: Column(
                          children: [
                            const IllustrationCaughtUp(size: 150),
                            const SizedBox(height: 24),
                            Text(
                              "You're all caught up.",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
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

  void _confirmDelete(BuildContext context, WidgetRef ref, Routine routine) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.warmIvory,
        title: Text('Remove ${routine.name}?',
            style: const TextStyle(
                color: AppColors.deepInk, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                'This will delete the medication and all its logs. This cannot be undone.'),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      side: const BorderSide(color: AppColors.lightBorder),
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(
                            color: AppColors.deepInk,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      ref
                          .read(todayControllerProvider.notifier)
                          .deleteRoutine(routine.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('Remove',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCatchUpDrawer(
      BuildContext context, WidgetRef ref, List<RoutineLog> missedLogs) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.subtlePeach.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: AppColors.subtlePeach.withValues(alpha: 0.5)),
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
            final isYesterday =
                DateTime.now().difference(log.scheduledDate).inDays == 1;
            final dateLabel = isYesterday
                ? 'Yesterday'
                : DateFormat('EEEE').format(log.scheduledDate);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(dateLabel,
                      style: const TextStyle(
                          color: AppColors.deepInk, fontSize: 14)),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => ref
                            .read(todayControllerProvider.notifier)
                            .markSkipped(log.scheduledDate,
                                routineId: log.routineId),
                        child: const Text('Missed',
                            style: TextStyle(color: AppColors.mutedSage)),
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
                            ref
                                .read(todayControllerProvider.notifier)
                                .markTaken(log.scheduledDate,
                                    completedAt: customDate,
                                    routineId: log.routineId);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brandAction,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
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
          builder: (_) => const RoutineSetupSheet(),
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
              'Add a medication routine',
              style: TextStyle(
                color: AppColors.charcoalInk,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Track Metformin, Inositol, birth control and more.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.mutedSage, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCycleCard(BuildContext context, CycleState? state) {
    final cycleDay = state?.currentCycleDay;
    final mostRecentEvent =
        state?.recentEvents.isNotEmpty == true ? state!.recentEvents.first : null;
    final isAnovulatory = mostRecentEvent?.flowType == 'Anovulatory';

    String subtitle = 'Tap to log your period';
    if (cycleDay != null) {
      subtitle = 'Currently on Day $cycleDay';
    } else if (state?.estimatedCycleDay != null) {
      subtitle = isAnovulatory 
          ? 'Cycle Day ~${state!.estimatedCycleDay} (Post-Anovulatory)'
          : 'Cycle Day ~${state!.estimatedCycleDay} (estimated)';
    } else if (isAnovulatory) {
      subtitle = 'Anovulatory cycle logged';
    }

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const QuickLogSheet(),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.softLavender.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: AppColors.brandAction.withValues(alpha: 0.3), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Cycle Log',
                    style: TextStyle(
                        color: AppColors.deepInk,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(
                        color: AppColors.mutedSage, fontSize: 14)),
              ],
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.brandAction),
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
          builder: (_) => const MetabolicLogSheet(),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.subtlePeach.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: AppColors.subtlePeach.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Metabolic Tracking',
                    style: TextStyle(
                        color: AppColors.deepInk,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Weight, Waist-to-Hip, Signs',
                    style:
                        TextStyle(color: AppColors.mutedSage, fontSize: 14)),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                  color: AppColors.cardBg, shape: BoxShape.circle),
              child: const Icon(Icons.monitor_weight_outlined,
                  color: AppColors.charcoalInk),
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
          builder: (_) => const PhenotypeSetupSheet(),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.brandAction.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: AppColors.brandAction.withValues(alpha: 0.15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Clinical Profile',
                    style: TextStyle(
                        color: AppColors.deepInk,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Rotterdam Phenotype Config',
                    style: TextStyle(color: AppColors.mutedSage, fontSize: 14)),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                  color: AppColors.cardBg, shape: BoxShape.circle),
              child: const Icon(Icons.medical_information_outlined,
                  color: AppColors.brandAction),
            ),
          ],
        ),
      ),
    );
  }
} // end TodayScreen

// ── Premium Greeting Block ────────────────────────────────────────────────────

class _GreetingBlock extends ConsumerWidget {
  final int? cycleDay;
  const _GreetingBlock({this.cycleDay});

  static String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning.';
    if (hour < 17) return 'Good afternoon.';
    if (hour < 21) return 'Good evening.';
    return 'Good night.';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, MMM d').format(now);
    
    // Watch the quote service provider
    final quoteAsync = ref.watch(quoteServiceProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getGreeting(),
          style: const TextStyle(
            color: AppColors.deepInk,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          dateStr,
          style: const TextStyle(
            color: AppColors.mutedSage,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (cycleDay != null) ...[
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.brandAction.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Cycle Day $cycleDay',
              style: const TextStyle(
                color: AppColors.brandAction,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
        const SizedBox(height: 14),
        // ── Daily quote ──────────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.brandAction.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.brandAction.withValues(alpha: 0.12)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('✨', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 8),
              Expanded(
                child: quoteAsync.when(
                  data: (service) => Text(
                    service.getTodaysQuote(),
                    style: const TextStyle(
                      color: AppColors.charcoalInk,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                      letterSpacing: -0.1,
                    ),
                  ),
                  loading: () => const Text('...', style: TextStyle(color: AppColors.mutedSage)),
                  error: (_, __) => const Text('Have a wonderful day.', style: TextStyle(color: AppColors.charcoalInk, fontStyle: FontStyle.italic)),
                ),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.08, end: 0);
  }
}

// ── Individual Medication Card ────────────────────────────────────────────────

class _MedicationCard extends StatelessWidget {
  final RoutineCardState cardState;
  final VoidCallback onMarkTaken;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MedicationCard({
    super.key,
    required this.cardState,
    required this.onMarkTaken,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final routine = cardState.routine;
    final phase = cardState.phaseState;
    final isTaken = cardState.todayLog?.status == 'Taken';
    final isBreak = phase.isBreakPeriod;

    final routineDose = (routine.dose != null && routine.dose!.isNotEmpty)
        ? ' (${routine.dose})'
        : '';

    final String phaseText = isBreak
        ? '🌿 Treatment Break · Day ${phase.dayInPhase} / ${phase.totalPhaseDays}'
        : (phase.totalPhaseDays == null)
            ? '💊 ${routine.name}$routineDose · Day ${phase.dayInPhase}'
            : '💊 ${routine.name}$routineDose · Day ${phase.dayInPhase} / ${phase.totalPhaseDays}';

    final String subText = isBreak
        ? 'No medication required today.'
        : 'Scheduled for ${routine.reminderTime}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      phaseText,
                      style: const TextStyle(
                        color: AppColors.deepInk,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subText,
                      style: const TextStyle(
                          color: AppColors.mutedSage, fontSize: 13),
                    ),
                  ],
                ),
              ),
              // Edit / Delete menu
              PopupMenuButton<String>(
                onSelected: (val) {
                  if (val == 'edit') onEdit();
                  if (val == 'delete') onDelete();
                },
                icon: const Icon(Icons.more_vert,
                    color: AppColors.mutedSage, size: 20),
                color: AppColors.cardBg,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined,
                            size: 18, color: AppColors.deepInk),
                        SizedBox(width: 10),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline,
                            size: 18, color: Colors.red),
                        SizedBox(width: 10),
                        Text('Remove',
                            style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (!isBreak) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: isTaken
                  ? OutlinedButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.check, color: AppColors.mutedSage),
                      label: Text(
                        'Taken at ${DateFormat('h:mm a').format(cardState.todayLog!.completedAt ?? DateTime.now())}',
                        style: const TextStyle(color: AppColors.mutedSage),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.lightBorder),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: onMarkTaken,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brandAction,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: const Text('Mark as Taken',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.06, end: 0);
  }
}
