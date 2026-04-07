import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:intl/date_symbol_data_local.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';

class DatePickerBottomSheet extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  const DatePickerBottomSheet({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  State<DatePickerBottomSheet> createState() => _DatePickerBottomSheetState();
}

class _DatePickerBottomSheetState extends State<DatePickerBottomSheet> {
  static const _accent = AppColors.mainColor;
  static const _muted = Color(0xFF666666);
  static const _surface = Colors.white;
  DateTime? _selected;
  final _gController = Get.find<GlobalController>();
  late final bool isArabic;

  @override
  void initState() {
    super.initState();
    isArabic = _gController.locale.languageCode == 'ar';
    initializeDateFormatting(isArabic ? 'ar' : 'en');
  }

  @override
  Widget build(BuildContext context) {
    final handle = Container(
      width: 100,
      height: 5,
      margin: const .only(top: 8, bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: .circular(3),
      ),
    );

    return Directionality(
      textDirection: isArabic ? .rtl : .ltr,
      child: SafeArea(
        top: false,
        child: Container(
          constraints: BoxConstraints(maxHeight: Get.height * 0.80),
          decoration: const BoxDecoration(
            color: _surface,
            borderRadius: .vertical(top: .circular(28)),
          ),
          child: Column(
            mainAxisSize: .min,
            children: [
              handle,
              Padding(
                padding: const .symmetric(horizontal: 12),
                child: DatePickerView(
                  initialDate: widget.initialDate,
                  firstDate: widget.firstDate,
                  lastDate: widget.lastDate,
                  onDateChanged: (d) => setState(() => _selected = d),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const .fromLTRB(16, 0, 16, 20),
                child: SizedBox(
                  width: .infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selected == null
                          ? const Color(0xFFE9E9E9)
                          : _accent,
                      foregroundColor: _selected == null
                          ? _muted
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: .circular(16),
                      ),
                    ),
                    onPressed: _selected == null
                        ? null
                        : () {
                            Navigator.of(context).pop(_selected);
                          },
                    child: const Text(
                      'متابعة',
                      style: TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontSize: 16,
                        fontWeight: .w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DatePickerView extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime>? onDateChanged;
  final ValueChanged<DateTime>? onDisplayedMonthChanged;

  const DatePickerView({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.onDateChanged,
    this.onDisplayedMonthChanged,
  });
  @override
  State<DatePickerView> createState() => _DatePickerViewState();
}

class _DatePickerViewState extends State<DatePickerView> {
  static const _text = Color(0xFF1A1A1A);
  static const _muted = Color(0xFF666666);
  final _gController = Get.find<GlobalController>();
  late final bool isArabic;
  late DateTime _displayedMonth;
  DateTime? _selected;
  bool _localeInitialized = false;

  @override
  void initState() {
    super.initState();
    isArabic = _gController.locale.languageCode == 'ar';
    _displayedMonth = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
    );
    _selected = widget.initialDate;
    initializeDateFormatting(isArabic ? 'ar' : 'en').then((_) {
      if (mounted) setState(() => _localeInitialized = true);
    });
  }

  void _prevMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
      );
    });
    widget.onDisplayedMonthChanged?.call(_displayedMonth);
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
      );
    });
    widget.onDisplayedMonthChanged?.call(_displayedMonth);
  }

  String _monthLabel(DateTime date) {
    final localeTag = _localeInitialized ? (isArabic ? 'ar' : 'en') : 'en';
    final month = DateFormat('MMMM', localeTag).format(date);
    return '$month ${date.year}';
  }

  int _daysInMonth(DateTime date) {
    final nextMonth = DateTime(date.year, date.month + 1, 0);
    return nextMonth.day;
  }

  int _weekdayToIndexSatFirst(int weekday) {
    const map = {6: 0, 7: 1, 1: 2, 2: 3, 3: 4, 4: 5, 5: 6};
    return map[weekday] ?? 0;
  }

  bool _isDisabled(DateTime d) =>
      d.isBefore(widget.firstDate) || d.isAfter(widget.lastDate);

  @override
  Widget build(BuildContext context) {
    final daysCount = _daysInMonth(_displayedMonth);
    final firstDayIndex = _weekdayToIndexSatFirst(
      DateTime(_displayedMonth.year, _displayedMonth.month, 1).weekday,
    );
    final totalCells = firstDayIndex + daysCount;
    final rows = (totalCells / 7.0).ceil();

    return Directionality(
      textDirection: isArabic ? .rtl : .ltr,
      child: Column(
        mainAxisSize: .min,
        children: [
          Padding(
            padding: const .symmetric(horizontal: 20),
            child: Row(
              children: [
                IconButton(
                  onPressed: _prevMonth,
                  icon: const Icon(Icons.chevron_left, size: 28, color: _muted),
                  splashRadius: 20,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final int? selectedYear = await showDialog<int>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(isArabic ? 'اختر السنة' : 'Select Year', style: AppTextStyles.bold16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            content: SizedBox(
                              width: 300,
                              height: 300,
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(primary: AppColors.mainColor),
                                ),
                                child: YearPicker(
                                  firstDate: widget.firstDate,
                                  lastDate: widget.lastDate,
                                  selectedDate: _displayedMonth,
                                  onChanged: (DateTime dateTime) {
                                    Navigator.pop(context, dateTime.year);
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                      if (selectedYear != null) {
                        setState(() {
                          _displayedMonth = DateTime(selectedYear, _displayedMonth.month);
                        });
                        widget.onDisplayedMonthChanged?.call(_displayedMonth);
                      }
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _monthLabel(_displayedMonth),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: _text,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_drop_down, color: _text, size: 28),
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _nextMonth,
                  icon: const Icon(
                    Icons.chevron_right,
                    size: 28,
                    color: _muted,
                  ),
                  splashRadius: 20,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const .symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                _WeekLabel(isArabic ? 'سبت' : 'Sat'),
                _WeekLabel(isArabic ? 'الأحد' : 'Sun'),
                _WeekLabel(isArabic ? 'اثنين' : 'Mon'),
                _WeekLabel(isArabic ? 'ثلاثاء' : 'Tue'),
                _WeekLabel(isArabic ? 'أربعاء' : 'Wed'),
                _WeekLabel(isArabic ? 'خميس' : 'Thu'),
                _WeekLabel(isArabic ? 'جمعة' : 'Fri'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const .symmetric(horizontal: 12),
            child: Column(
              children: List.generate(rows, (row) {
                return Padding(
                  padding: const .symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: .spaceBetween,
                    children: List.generate(7, (col) {
                      final cellIndex = row * 7 + col;
                      final dayNumber = cellIndex - firstDayIndex + 1;
                      if (dayNumber < 1 || dayNumber > daysCount) {
                        return const DayCell.empty();
                      }
                      final d = DateTime(
                        _displayedMonth.year,
                        _displayedMonth.month,
                        dayNumber,
                      );
                      final isToday = DateUtils.isSameDay(d, DateTime.now());
                      final isSelected =
                          _selected != null &&
                          DateUtils.isSameDay(_selected, d);
                      final disabled = _isDisabled(d);
                      return DayCell(
                        day: dayNumber,
                        isSelected: isSelected,
                        isToday: isToday,
                        disabled: disabled,
                        onTap: disabled
                            ? null
                            : () {
                                setState(() => _selected = d);
                                widget.onDateChanged?.call(d);
                              },
                      );
                    }),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekLabel extends StatelessWidget {
  final String text;
  const _WeekLabel(this.text);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(child: Text(text, style: AppTextStyles.regular12)),
    );
  }
}

class DayCell extends StatelessWidget {
  final int day;
  final bool isSelected;
  final bool isToday;
  final bool disabled;
  final VoidCallback? onTap;

  const DayCell({
    super.key,
    required this.day,
    required this.isSelected,
    required this.isToday,
    required this.disabled,
    required this.onTap,
  });

  const DayCell.empty({super.key})
    : day = 0,
      isSelected = false,
      isToday = false,
      disabled = true,
      onTap = null;

  @override
  Widget build(BuildContext context) {
    if (day == 0) {
      return const SizedBox(width: 40, height: 40);
    }
    final borderColor = isSelected
        ? AppColors.mainColor
        : isToday
        ? AppColors.mainColor.withValues(alpha: 0.5)
        : const Color(0xFFF0F0F0);
    final bg = isSelected ? AppColors.mainColor : Colors.transparent;
    final textColor = disabled
        ? const Color(0xFFD1D1D1)
        : isSelected
        ? Colors.white
        : isToday
        ? AppColors.mainColor
        : const Color(0xFF2D3142);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor,
            width: isSelected || isToday ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.mainColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          '$day',
          style: TextStyle(
            fontFamily: 'IBMPlexSansArabic',
            fontSize: 15,
            fontWeight: isSelected || isToday
                ? FontWeight.bold
                : FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
