import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/notifications/notification_service.dart';

class RoutineSetupSheet extends ConsumerStatefulWidget {
  const RoutineSetupSheet({super.key});

  @override
  ConsumerState<RoutineSetupSheet> createState() => _RoutineSetupSheetState();
}

class _RoutineSetupSheetState extends ConsumerState<RoutineSetupSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String _selectedRegimen = 'Cyclic_21_7';
  TimeOfDay _reminderTime = const TimeOfDay(hour: 20, minute: 0); // 8:00 PM default
  DateTime _startDate = DateTime.now();

  @override
  void dispose() {
    _nameController.dispose();
    _doseController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.deepInk,
              onPrimary: AppColors.warmIvory,
              surface: AppColors.warmIvory,
              onSurface: AppColors.deepInk,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _reminderTime = picked);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.deepInk,
              onPrimary: AppColors.warmIvory,
              surface: AppColors.warmIvory,
              onSurface: AppColors.deepInk,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

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
              'Medication or Supplement Routine',
              style: TextStyle(
                color: AppColors.deepInk,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            
            // Name
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name (e.g. Metformin, Inositol)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 16),
            
            // Dose
            TextField(
              controller: _doseController,
              decoration: InputDecoration(
                labelText: 'Dose (e.g. 500mg, 1 cup)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 16),
            
            // Notes
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Notes (optional)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),

            // Regimen Type
            const Text(
              'Regimen Type',
              style: TextStyle(color: AppColors.deepInk, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            RadioGroup<String>(
              groupValue: _selectedRegimen,
              onChanged: (val) => setState(() => _selectedRegimen = val!),
              child: Column(
                children: [
                  _buildRadioTile(
                    title: 'Standard 21/7 Regimen',
                    subtitle: '21 active days followed by 7 break days',
                    value: 'Cyclic_21_7',
                  ),
                  _buildRadioTile(
                    title: 'Continuous Daily',
                    subtitle: 'Daily medication without breaks',
                    value: 'Daily',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Start Date
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Start Date', style: TextStyle(color: AppColors.deepInk, fontWeight: FontWeight.w600)),
              subtitle: Text(DateFormat('MMM d, yyyy').format(_startDate)),
              trailing: const Icon(Icons.calendar_today, color: AppColors.mutedSage),
              onTap: () => _selectDate(context),
            ),
            const Divider(color: AppColors.lightBorder),

            // Reminder Time
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Daily Reminder', style: TextStyle(color: AppColors.deepInk, fontWeight: FontWeight.w600)),
              subtitle: Text(_reminderTime.format(context)),
              trailing: const Icon(Icons.access_time, color: AppColors.mutedSage),
              onTap: () => _selectTime(context),
            ),
            const SizedBox(height: 32),

            // Save Button
            ElevatedButton(
              onPressed: () async {
                final name = _nameController.text.trim().isEmpty ? 'My Routine' : _nameController.text.trim();
                final timeStr = '${_reminderTime.hour.toString().padLeft(2, '0')}:${_reminderTime.minute.toString().padLeft(2, '0')}';
                final routineId = await ref.read(routineDaoProvider).insertRoutine(
                  name: name,
                  regimenType: _selectedRegimen,
                  startDate: _startDate,
                  reminderTime: timeStr,
                  dose: _doseController.text.trim().isEmpty ? null : _doseController.text.trim(),
                  notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
                );
                
                // Schedule local notification
                await NotificationService.scheduleRoutineReminder(routineId, name, _reminderTime.hour, _reminderTime.minute);
                
                // The provider will automatically update due to the stream
                if (context.mounted) Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandAction,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
              ),
              child: const Text('Save Routine', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioTile({
    required String title,
    required String subtitle,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _selectedRegimen == value ? AppColors.deepInk : AppColors.lightBorder,
          width: _selectedRegimen == value ? 2 : 1,
        ),
      ),
      child: RadioListTile<String>(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.deepInk)),
        subtitle: Text(subtitle, style: const TextStyle(color: AppColors.mutedSage, fontSize: 12)),
        value: value,
        activeColor: AppColors.deepInk,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
