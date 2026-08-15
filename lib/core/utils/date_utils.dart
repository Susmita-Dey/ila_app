class AppDateUtils {
  /// Strips the time component from a DateTime, returning a new DateTime at midnight.
  static DateTime stripTime(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Checks if two dates are on the same day.
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
