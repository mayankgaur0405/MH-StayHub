import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/analytics_tracker.dart';
import '../../../../core/utils/loading/full_screen_loader.dart';
import '../providers/lead_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_state.dart';

class ScheduleVisitScreen extends ConsumerStatefulWidget {
  final String accommodationId;
  final String accommodationName;

  const ScheduleVisitScreen({
    super.key,
    required this.accommodationId,
    required this.accommodationName,
  });

  @override
  ConsumerState<ScheduleVisitScreen> createState() => _ScheduleVisitScreenState();
}

class _ScheduleVisitScreenState extends ConsumerState<ScheduleVisitScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AnalyticsTracker.trackScheduleVisitStarted(widget.accommodationId);
    
    // Pre-fill user data if available
    final authState = ref.read(authControllerProvider);
    if (authState is AuthAuthenticated) {
      if (authState.user.name != null) _nameController.text = authState.user.name!;
      _phoneController.text = authState.user.phone.replaceAll('+91', '');
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
    );
    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  void _submit() {
    if (_selectedDate == null || _selectedTime == null || _nameController.text.isEmpty || _phoneController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all required fields correctly.')));
      return;
    }

    AnalyticsTracker.trackScheduleVisitSubmitted(widget.accommodationId);

    // Combine date and time to ISO8601 string
    final combinedDateTime = DateTime(
      _selectedDate!.year, _selectedDate!.month, _selectedDate!.day,
      _selectedTime!.hour, _selectedTime!.minute,
    );

    ref.read(submitLeadProvider.notifier).submit(
      accommodationId: widget.accommodationId,
      preferredDate: combinedDateTime.toIso8601String(),
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final submitState = ref.watch(submitLeadProvider);

    // Listen for success state to navigate away
    ref.listen(submitLeadProvider, (prev, next) {
      if (next is AsyncData) {
        AnalyticsTracker.trackScheduleVisitSuccess(widget.accommodationId);
        // Show success screen/dialog then pop
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Visit Scheduled! 🎉'),
            content: Text('We will contact you shortly to confirm your visit to ${widget.accommodationName}.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  context.pop(); // Pop screen back to details
                },
                child: const Text('Done'),
              ),
            ],
          ),
        );
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.error.toString())));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Schedule Visit')),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.accommodationName,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.brandPrimary),
                ),
                const SizedBox(height: 32),

                // Date & Time
                const Text('When would you like to visit?', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.calendar_today),
                        label: Text(_selectedDate == null ? 'Select Date' : DateFormat('dd MMM, yyyy').format(_selectedDate!)),
                        onPressed: _pickDate,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.access_time),
                        label: Text(_selectedTime == null ? 'Select Time' : _selectedTime!.format(context)),
                        onPressed: _pickTime,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Contact Info
                const Text('Your Details', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixText: '+91 ',
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Any specific requirements? (Optional)',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 40),

                // Submit
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: submitState is AsyncLoading ? null : _submit,
                    child: const Text('Confirm Visit'),
                  ),
                ),
              ],
            ),
          ),
          if (submitState is AsyncLoading)
            const FullScreenLoader(message: 'Scheduling your visit...'),
        ],
      ),
    );
  }
}
