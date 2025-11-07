import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

/// Custom date picker widget using table_calendar.
///
/// Provides a reusable calendar widget for date selection following
/// Material 3 design principles.
///
/// Example:
/// ```dart
/// DatePickerWidget(
///   selectedDate: selectedDate,
///   onDateSelected: (date) => setState(() => selectedDate = date),
///   firstDate: DateTime.now(),
///   lastDate: DateTime.now().add(Duration(days: 90)),
/// )
/// ```
class DatePickerWidget extends StatefulWidget {
  const DatePickerWidget({
    required this.selectedDate,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
    this.enabledDates,
    this.disabledDates,
    this.markedDates,
    this.showHeader = true,
    super.key,
  });

  /// Currently selected date.
  final DateTime? selectedDate;

  /// Callback when date is selected.
  final ValueChanged<DateTime> onDateSelected;

  /// Earliest selectable date.
  final DateTime? firstDate;

  /// Latest selectable date.
  final DateTime? lastDate;

  /// List of explicitly enabled dates.
  final List<DateTime>? enabledDates;

  /// List of explicitly disabled dates.
  final List<DateTime>? disabledDates;

  /// Map of dates to mark with indicators.
  final Map<DateTime, List<dynamic>>? markedDates;

  /// Whether to show month/year header.
  final bool showHeader;

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  late DateTime _focusedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.selectedDate ?? DateTime.now();
  }

  bool _isDayEnabled(DateTime day) {
    // Check if before firstDate
    if (widget.firstDate != null && day.isBefore(widget.firstDate!)) {
      return false;
    }

    // Check if after lastDate
    if (widget.lastDate != null && day.isAfter(widget.lastDate!)) {
      return false;
    }

    // Check disabled dates
    if (widget.disabledDates != null) {
      for (final disabledDate in widget.disabledDates!) {
        if (isSameDay(day, disabledDate)) {
          return false;
        }
      }
    }

    // Check enabled dates (if specified, only these are enabled)
    if (widget.enabledDates != null) {
      for (final enabledDate in widget.enabledDates!) {
        if (isSameDay(day, enabledDate)) {
          return true;
        }
      }
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: TableCalendar(
          firstDay: widget.firstDate ?? DateTime(2020),
          lastDay: widget.lastDate ?? DateTime(2030),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            return widget.selectedDate != null && isSameDay(widget.selectedDate!, day);
          },
          enabledDayPredicate: _isDayEnabled,
          onDaySelected: (selectedDay, focusedDay) {
            if (_isDayEnabled(selectedDay)) {
              setState(() {
                _focusedDay = focusedDay;
              });
              widget.onDateSelected(selectedDay);
            }
          },
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          headerVisible: widget.showHeader,
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: theme.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
            leftChevronIcon: Icon(
              Icons.chevron_left,
              color: colorScheme.onSurface,
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              color: colorScheme.onSurface,
            ),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: theme.textTheme.bodySmall!.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
            weekendStyle: theme.textTheme.bodySmall!.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          calendarStyle: CalendarStyle(
            // Today
            todayDecoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            todayTextStyle: TextStyle(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),

            // Selected
            selectedDecoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
            selectedTextStyle: TextStyle(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),

            // Default
            defaultDecoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            defaultTextStyle: TextStyle(
              color: colorScheme.onSurface,
            ),

            // Weekend
            weekendDecoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            weekendTextStyle: TextStyle(
              color: colorScheme.onSurface,
            ),

            // Disabled
            disabledDecoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            disabledTextStyle: TextStyle(
              color: colorScheme.onSurfaceVariant.withOpacity(0.4),
            ),

            // Outside (different month)
            outsideDecoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            outsideTextStyle: TextStyle(
              color: colorScheme.onSurfaceVariant.withOpacity(0.4),
            ),

            // Markers
            markerDecoration: BoxDecoration(
              color: colorScheme.secondary,
              shape: BoxShape.circle,
            ),
            markerSize: 6,
          ),
          eventLoader: (day) {
            if (widget.markedDates != null) {
              for (final entry in widget.markedDates!.entries) {
                if (isSameDay(entry.key, day)) {
                  return entry.value;
                }
              }
            }
            return [];
          },
        ),
      ),
    );
  }
}

/// Date picker field that shows a dialog when tapped.
///
/// Example:
/// ```dart
/// DatePickerField(
///   label: 'Reservation Date',
///   selectedDate: selectedDate,
///   onDateSelected: (date) => setState(() => selectedDate = date),
/// )
/// ```
class DatePickerField extends StatelessWidget {
  const DatePickerField({
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
    this.helperText,
    this.errorText,
    this.enabled = true,
    super.key,
  });

  /// Field label.
  final String label;

  /// Currently selected date.
  final DateTime? selectedDate;

  /// Callback when date is selected.
  final ValueChanged<DateTime> onDateSelected;

  /// Earliest selectable date.
  final DateTime? firstDate;

  /// Latest selectable date.
  final DateTime? lastDate;

  /// Helper text.
  final String? helperText;

  /// Error text.
  final String? errorText;

  /// Whether field is enabled.
  final bool enabled;

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime.now(),
      lastDate: lastDate ?? DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String displayText = selectedDate != null
        ? DateFormat('EEEE, MMMM d, yyyy').format(selectedDate!)
        : 'Select a date';

    return InkWell(
      onTap: enabled ? () => _showDatePicker(context) : null,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          helperText: helperText,
          errorText: errorText,
          prefixIcon: const Icon(Icons.calendar_today),
          suffixIcon: selectedDate != null && enabled
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => onDateSelected(DateTime.now()),
                  tooltip: 'Clear',
                )
              : null,
          enabled: enabled,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          displayText,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: selectedDate != null
                ? colorScheme.onSurface
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

/// Date range picker field.
///
/// Example:
/// ```dart
/// DateRangePickerField(
///   label: 'Date Range',
///   startDate: startDate,
///   endDate: endDate,
///   onRangeSelected: (start, end) {
///     setState(() {
///       startDate = start;
///       endDate = end;
///     });
///   },
/// )
/// ```
class DateRangePickerField extends StatelessWidget {
  const DateRangePickerField({
    required this.label,
    required this.startDate,
    required this.endDate,
    required this.onRangeSelected,
    this.firstDate,
    this.lastDate,
    this.helperText,
    this.errorText,
    this.enabled = true,
    super.key,
  });

  /// Field label.
  final String label;

  /// Start date of range.
  final DateTime? startDate;

  /// End date of range.
  final DateTime? endDate;

  /// Callback when range is selected.
  final void Function(DateTime start, DateTime end) onRangeSelected;

  /// Earliest selectable date.
  final DateTime? firstDate;

  /// Latest selectable date.
  final DateTime? lastDate;

  /// Helper text.
  final String? helperText;

  /// Error text.
  final String? errorText;

  /// Whether field is enabled.
  final bool enabled;

  Future<void> _showDateRangePicker(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: firstDate ?? DateTime.now(),
      lastDate: lastDate ?? DateTime.now().add(const Duration(days: 365)),
      initialDateRange: startDate != null && endDate != null
          ? DateTimeRange(start: startDate!, end: endDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onRangeSelected(picked.start, picked.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String displayText = startDate != null && endDate != null
        ? '${DateFormat('MMM d').format(startDate!)} - ${DateFormat('MMM d, yyyy').format(endDate!)}'
        : 'Select date range';

    return InkWell(
      onTap: enabled ? () => _showDateRangePicker(context) : null,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          helperText: helperText,
          errorText: errorText,
          prefixIcon: const Icon(Icons.date_range),
          enabled: enabled,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          displayText,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: startDate != null
                ? colorScheme.onSurface
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

/// Quick date selection chips (Today, Tomorrow, Next Week, etc).
///
/// Example:
/// ```dart
/// QuickDateSelector(
///   onDateSelected: (date) => setState(() => selectedDate = date),
/// )
/// ```
class QuickDateSelector extends StatelessWidget {
  const QuickDateSelector({
    required this.onDateSelected,
    this.selectedDate,
    super.key,
  });

  /// Callback when date is selected.
  final ValueChanged<DateTime> onDateSelected;

  /// Currently selected date.
  final DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final nextWeek = today.add(const Duration(days: 7));

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _QuickDateChip(
          label: 'Today',
          date: today,
          isSelected: selectedDate != null && isSameDay(selectedDate!, today),
          onTap: () => onDateSelected(today),
        ),
        _QuickDateChip(
          label: 'Tomorrow',
          date: tomorrow,
          isSelected: selectedDate != null && isSameDay(selectedDate!, tomorrow),
          onTap: () => onDateSelected(tomorrow),
        ),
        _QuickDateChip(
          label: 'Next Week',
          date: nextWeek,
          isSelected: selectedDate != null && isSameDay(selectedDate!, nextWeek),
          onTap: () => onDateSelected(nextWeek),
        ),
      ],
    );
  }
}

class _QuickDateChip extends StatelessWidget {
  const _QuickDateChip({
    required this.label,
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: colorScheme.primaryContainer,
      checkmarkColor: colorScheme.onPrimaryContainer,
      labelStyle: TextStyle(
        color: isSelected
            ? colorScheme.onPrimaryContainer
            : colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
