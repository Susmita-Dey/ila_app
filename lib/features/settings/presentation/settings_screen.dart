import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/diagnostics/diagnostics_service.dart';
import '../../../core/providers/database_provider.dart';
import '../../today/presentation/today_controller.dart';
import '../../cycle/presentation/cycle_controller.dart';
import '../../report/presentation/report_controller.dart';
import '../../../core/services/backup_service.dart';
import 'widgets/feedback_dialog.dart';
import 'widgets/backup_passphrase_dialog.dart';
import '../../../l10n/app_localizations.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _appVersion = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _appVersion = 'Version ${info.version}+${info.buildNumber}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmIvory,
      appBar: AppBar(
        backgroundColor: AppColors.warmIvory,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppColors.deepInk,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              AppLocalizations.of(context)!.settingsDataPrivacy,
              style: const TextStyle(
                color: AppColors.deepInk,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Card(
            color: AppColors.cardBg,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppColors.lightBorder),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.cloud_off, color: AppColors.brandAction),
                  title: Text(AppLocalizations.of(context)!.settingsOfflineBadge, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Divider(height: 1, color: AppColors.lightBorder),
                ListTile(
                  leading: const Icon(Icons.lock_outline, color: AppColors.deepInk),
                  title: const Text('Export Encrypted Backup'),
                  subtitle: const Text('Save your data locally as an AES-256 encrypted file'),
                  trailing: const Icon(Icons.download_outlined, color: AppColors.mutedSage),
                  onTap: () async {
                    final passphrase = await showDialog<String>(
                      context: context,
                      builder: (context) => const BackupPassphraseDialog(),
                    );

                    if (passphrase != null && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Encrypting backup...')),
                      );
                      final db = ref.read(appDatabaseProvider);
                      await BackupService.exportEncryptedBackup(db, passphrase!);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Help & Testing',
              style: TextStyle(
                color: AppColors.deepInk,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Card(
            color: AppColors.cardBg,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppColors.lightBorder),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.feedback_outlined, color: AppColors.deepInk),
                  title: const Text('Send Feedback / Report an Issue'),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.mutedSage),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const FeedbackDialog(),
                    );
                  },
                ),
                const Divider(height: 1, color: AppColors.lightBorder),
                ListTile(
                  leading: const Icon(Icons.bug_report_outlined, color: AppColors.deepInk),
                  title: const Text('Export Anonymous Diagnostics'),
                  trailing: const Icon(Icons.file_download_outlined, color: AppColors.mutedSage),
                  onTap: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Compiling diagnostic report...')),
                    );
                    await DiagnosticsService.exportDiagnosticsPackage();
                  },
                ),
                const Divider(height: 1, color: AppColors.lightBorder),
                ListTile(
                  leading: const Icon(Icons.warning_amber_rounded, color: Colors.red),
                  title: const Text('Trigger Test Crash', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    throw Exception('Simulated test exception to verify ErrorLogger');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: AppColors.cardBg,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Colors.red, width: 1.5),
            ),
            child: ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('Erase All Data on Device', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: AppColors.warmIvory,
                    title: const Text('Erase All Data?', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    content: const Text('This immediately wipes all cycle, medication, and symptom records from this phone. This action cannot be undone.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel', style: TextStyle(color: AppColors.deepInk)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.brandAction, foregroundColor: Colors.white),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          final db = ref.read(appDatabaseProvider);
                          await db.transaction(() async {
                            await db.delete(db.cycleEvents).go();
                            await db.delete(db.routineLogs).go();
                            await db.delete(db.routines).go();
                            await db.delete(db.treatmentInterventions).go();
                          });
                          ref.invalidate(appDatabaseProvider);
                          ref.invalidate(todayControllerProvider);
                          ref.invalidate(cycleControllerProvider);
                          ref.invalidate(reportControllerProvider);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('All data has been permanently erased.')),
                            );
                          }
                        },
                        child: const Text('Erase'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              'Ila Local-First Compliance App\n$_appVersion',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.mutedSage,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

