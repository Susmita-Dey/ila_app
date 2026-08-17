import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../domain/report_payload.dart';

class DoctorPdfGenerator {
  /// Generates the PDF bytes. Safe to run in an Isolate via compute().
  static Future<Uint8List> generatePdfBytes(DoctorReportData data) async {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'PATIENT HEALTH SUMMARY - CLINICAL OBSERVATION RECORD',
                style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Observation Window: ${data.dateRange}  |  Source: Ila Local-First Log',
                style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
              ),
              pw.Divider(thickness: 1.5, color: PdfColors.black),
              pw.SizedBox(height: 8),

              // Vitals Summary Grid
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey400),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatBlock('Total Cycles', '${data.totalCycles} Recorded'),
                    _buildStatBlock('Median Length', '${data.medianCycleLength > 0 ? '${data.medianCycleLength} Days' : 'N/A'}'),
                    _buildStatBlock('Avg Pain', '${data.averagePainScore}/10'),
                    _buildStatBlock('Luteal Pain', '${data.lutealAveragePainScore}/10'),
                    _buildStatBlock('Med Adherence', '${data.adherencePercentage}%'),
                    _buildStatBlock('Flooding/Clots', '${data.totalHeavyWithClotsDays + data.floodingEventsCount} Days'),
                  ],
                ),
              ),
              pw.SizedBox(height: 12),

              // Tier 4: Rotterdam Phenotype Screening
              pw.Text('Rotterdam Diagnostic Indicators (PCOS/PMOS)', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.deepPurple900)),
              pw.SizedBox(height: 4),
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  color: PdfColors.purple50,
                  border: pw.Border.all(color: PdfColors.purple200),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    _buildRotterdamFlag('1. Ovulatory Dysfunction', data.rotterdamOvulatoryDysfunction),
                    _buildRotterdamFlag('2. Hyperandrogenism (Clinical)', data.rotterdamHyperandrogenism),
                    _buildRotterdamFlag('3. Polycystic Ovaries (PCOM)', data.rotterdamPCOM),
                  ],
                ),
              ),
              pw.SizedBox(height: 12),

              pw.Text('Recorded Menstrual Cycles', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 4),
              pw.TableHelper.fromTextArray(
                headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                cellStyle: const pw.TextStyle(fontSize: 7.5),
                headers: ['Cycle', 'Start Date', 'End Date', 'Length', 'Flow', 'Symptoms'],
                data: data.cycleRows,
              ),
              
              if (data.symptomPhaseClusters.isNotEmpty) ...[
                pw.SizedBox(height: 12),
                pw.Text('Symptom Phase Clustering (PMDD/Dysmenorrhea Screen)', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),
                pw.TableHelper.fromTextArray(
                  headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                  cellStyle: const pw.TextStyle(fontSize: 7.5),
                  headers: ['Symptom', 'Frequency', 'Clinical Pattern'],
                  data: data.symptomPhaseClusters,
                ),
              ],

              if (data.labResultsRows.isNotEmpty) ...[
                pw.SizedBox(height: 12),
                pw.Text('Laboratory Results', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),
                pw.TableHelper.fromTextArray(
                  headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                  cellStyle: const pw.TextStyle(fontSize: 7.5),
                  headers: ['Date', 'Test Name', 'Value', 'Notes'],
                  data: data.labResultsRows,
                ),
              ],

              if (data.metabolicRows.isNotEmpty) ...[
                pw.SizedBox(height: 12),
                pw.Text('Metabolic & Anthropometric Trends', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),
                pw.TableHelper.fromTextArray(
                  headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                  cellStyle: const pw.TextStyle(fontSize: 7.5),
                  headers: ['Date', 'Weight', 'W/H Ratio', 'Clinical Signs (Insulin Resistance)'],
                  data: data.metabolicRows,
                ),
              ],

              if (data.treatmentBenchmark != null) ...[
                pw.SizedBox(height: 12),
                pw.Text('Treatment Benchmark: ${data.treatmentBenchmark!['title']}', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    border: pw.Border.all(color: PdfColors.grey400),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(data.treatmentBenchmark!['pre']!, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.red900)),
                      pw.Text(data.treatmentBenchmark!['post']!, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.green900)),
                    ],
                  ),
                ),
              ],
              
              pw.Spacer(),
              pw.Divider(thickness: 0.5, color: PdfColors.grey400),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Self-reported patient record. Prepared for clinical review.', style: const pw.TextStyle(fontSize: 6.5)),
                  pw.Text('Zero Cloud Storage | Local Verification', style: const pw.TextStyle(fontSize: 6.5)),
                ],
              ),
            ],
          );
        },
      ),
    );

    return doc.save();
  }

  static Future<void> sharePdf(Uint8List bytes) async {
    await Printing.sharePdf(bytes: bytes, filename: 'Ila_clinical_summary.pdf');
  }

  static pw.Widget _buildStatBlock(String label, String value) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label, style: const pw.TextStyle(fontSize: 6.5, color: PdfColors.grey600)),
        pw.SizedBox(height: 2),
        pw.Text(value, style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
      ],
    );
  }

  static pw.Widget _buildRotterdamFlag(String label, bool isPresent) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label, style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey800)),
        pw.SizedBox(height: 2),
        pw.Text(
          isPresent ? 'YES / FLAGGED' : 'Not Indicated',
          style: pw.TextStyle(
            fontSize: 9, 
            fontWeight: pw.FontWeight.bold, 
            color: isPresent ? PdfColors.red900 : PdfColors.grey600,
          ),
        ),
      ],
    );
  }
}

