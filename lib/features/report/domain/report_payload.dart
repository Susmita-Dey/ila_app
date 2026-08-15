class DoctorReportData {
  final String dateRange;
  final int totalCycles;
  final int cycleRangeMin;
  final int cycleRangeMax;
  final int medianCycleLength;
  final int adherencePercentage;
  final int totalHeavyWithClotsDays;
  final int floodingEventsCount;
  final String spottingColorProfile;
  final List<List<String>> cycleRows;
  final List<List<String>> symptomPhaseClusters; // [Symptom, Frequency, Cluster]
  final Map<String, String>? treatmentBenchmark; // Pre- vs Post- stats

  DoctorReportData({
    required this.dateRange,
    required this.totalCycles,
    required this.cycleRangeMin,
    required this.cycleRangeMax,
    required this.medianCycleLength,
    required this.adherencePercentage,
    required this.totalHeavyWithClotsDays,
    required this.floodingEventsCount,
    required this.spottingColorProfile,
    required this.cycleRows,
    required this.symptomPhaseClusters,
    this.treatmentBenchmark,
  });

  /// Fallback empty state for reports
  factory DoctorReportData.empty(String rangeLabel) {
    return DoctorReportData(
      dateRange: rangeLabel,
      totalCycles: 0,
      cycleRangeMin: 0,
      cycleRangeMax: 0,
      medianCycleLength: 0,
      adherencePercentage: 0,
      totalHeavyWithClotsDays: 0,
      floodingEventsCount: 0,
      spottingColorProfile: 'N/A',
      cycleRows: [],
      symptomPhaseClusters: [],
      treatmentBenchmark: null,
    );
  }
}
