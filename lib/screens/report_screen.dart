import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../services/api_service.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
// Para formatear fecha y generar nombre de archivo
import 'package:intl/intl.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<Map<String, dynamic>> candidates = [];
  List<Map<String, dynamic>> departments = [];
  bool isVotingFinished = false;

  @override
  void initState() {
    super.initState();
    fetchCandidates();
    fetchDepartments();
  }

  Future<void> fetchCandidates() async {
    try {
      final data = await ApiService.get('/candidatas');
      final rawList = List<Map<String, dynamic>>.from(data);

      // Ordenar desc por CAND_NOTA_FINAL
      rawList.sort((a, b) {
        final notaB = (b['CAND_NOTA_FINAL'] ?? 0).toDouble();
        final notaA = (a['CAND_NOTA_FINAL'] ?? 0).toDouble();
        return notaB.compareTo(notaA);
      });

      // Verificar si TODAS las candidatas tienen CAND_NOTA_FINAL > 0
      final allHaveNotaFinal = rawList.every((cand) =>
          cand['CAND_NOTA_FINAL'] != null && (cand['CAND_NOTA_FINAL'] as num) > 0);

      setState(() {
        candidates = rawList;
        isVotingFinished = allHaveNotaFinal;
      });
    } catch (error) {
      print('Error fetching candidates: $error');
    }
  }

  Future<void> fetchDepartments() async {
    try {
      final data = await ApiService.get('/candidatas/carruselCandidatas');
      final rawList = List<Map<String, dynamic>>.from(data);

      // Ordenar desc por CAND_NOTA_FINAL
      rawList.sort((a, b) {
        final notaB = (b['CAND_NOTA_FINAL'] ?? 0).toDouble();
        final notaA = (a['CAND_NOTA_FINAL'] ?? 0).toDouble();
        return notaB.compareTo(notaA);
      });

      // Tomar solo las 3 primeras (top3)
      final top3 = rawList.take(3).toList();

      setState(() {
        departments = top3;
      });
    } catch (error) {
      print('Error fetching departments: $error');
    }
  }

  /// Generar nombre de archivo dinámico, p.ej: "ResultadoReinado2024_20230812_134527.pdf"
  String _generateFileName() {
    final now = DateTime.now();
    final year = now.year;
    final dateFormatted = DateFormat('yyyyMMdd_HHmmss').format(now);
    return 'ResultadoReinado${year}_$dateFormatted.pdf';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reporte')),
      body: Center(
        child: isVotingFinished
            ? PdfPreview(
                // Generamos el PDF
                build: (format) => _generatePdf(format, candidates, departments),
                // Asignamos el nombre dinámico
                pdfFileName: _generateFileName(),
              )
            : const Text(
                'No se puede reportar una ganadora. Las votaciones aún no terminan.',
              ),
      ),
    );
  }

  Future<Uint8List> _generatePdf(
    PdfPageFormat format,
    List<Map<String, dynamic>> allCandidates,
    List<Map<String, dynamic>> top3Departments,
  ) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.oswaldRegular();

    // -----------------------
    // Usamos pw.MultiPage
    // -----------------------
    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        theme: pw.ThemeData.withFont(
          base: font,
        ),
        build: (pw.Context context) => [
          // ===========================
          // 1) INFORME DE RESULTADOS
          // ===========================
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Informe de Resultados',
                  style: pw.TextStyle(fontSize: 24, font: font)),
              pw.Text(
                'Puntajes Arrojados por el Sistema Informático',
                style: pw.TextStyle(fontSize: 14, font: font),
              ),
              pw.Text(
                'Hora de Corte del Sistema (GMT-05): ${DateTime.now()}',
                style: pw.TextStyle(fontSize: 14, font: font),
              ),
              pw.SizedBox(height: 20),

              // Listado COMPLETO de candidatas con su posición
              pw.Wrap(
                children: allCandidates.map((c) {
                  final lugar = allCandidates.indexOf(c) + 1; // Posición en el ranking
                  // Títulos especiales en base a la posición
                  String tituloEspecial = '';
                  if (lugar == 1) {
                    tituloEspecial = 'Reina ESPE 2024';
                  } else if (lugar == 2) {
                    tituloEspecial = 'Srta. Confraternidad';
                  } else if (lugar == 3) {
                    tituloEspecial = 'Srta. Simpatía';
                  }

                  return pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 8),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        if (tituloEspecial.isNotEmpty)
                          pw.Text(
                            tituloEspecial,
                            style: pw.TextStyle(fontSize: 16, font: font),
                          ),
                        if (c['ID_ELECCION'] == 1)
                          pw.Text(
                            'Candidata Amistad',
                            style: pw.TextStyle(fontSize: 16, font: font),
                          ),
                        pw.Text(
                          'Lugar $lugar: ${c['CAND_NOMBRE1']} ${c['CAND_APELLIDOPATERNO']}',
                          style: pw.TextStyle(fontSize: 14, font: font),
                        ),
                        pw.Text(
                          'Puntuación Final: ${c['CAND_NOTA_FINAL']}/150',
                          style: pw.TextStyle(fontSize: 14, font: font),
                        ),
                        pw.SizedBox(height: 5),
                      ],
                    ),
                  );
                }).toList(),
              ),

              pw.SizedBox(height: 20),
              pw.Text('____________________',
                  style: pw.TextStyle(fontSize: 14, font: font)),
              pw.Text('Veedor', style: pw.TextStyle(fontSize: 14, font: font)),
              pw.Text('Dr. Marcelo Mejía Mena',
                  style: pw.TextStyle(fontSize: 14, font: font)),
              pw.Text('CI: 1803061033',
                  style: pw.TextStyle(fontSize: 14, font: font)),
            ],
          ),

          // Forzamos un salto de página
          pw.NewPage(),

          // ==============================
          // 2) PROCLAMACIÓN DE GANADORAS
          // ==============================
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Proclamación de Ganadoras',
                style: pw.TextStyle(fontSize: 24, font: font),
              ),
              pw.Text(
                'Hora de Corte del Sistema (GMT-05): ${DateTime.now()}',
                style: pw.TextStyle(fontSize: 14, font: font),
              ),
              pw.SizedBox(height: 20),

              // Solo top 3
              pw.Wrap(
                children: top3Departments.map((d) {
                  final pos = top3Departments.indexOf(d) + 1;
                  String tituloPos = '';
                  if (pos == 1) {
                    tituloPos = 'Reina ESPE 2024';
                  } else if (pos == 2) {
                    tituloPos = 'Srta. Confraternidad';
                  } else if (pos == 3) {
                    tituloPos = 'Srta. Simpatía';
                  }

                  return pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 8),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        if (tituloPos.isNotEmpty)
                          pw.Text(
                            tituloPos,
                            style: pw.TextStyle(fontSize: 16, font: font),
                          ),
                        if (d['ID_ELECCION'] == 1)
                          pw.Text(
                            'Candidata Amistad',
                            style: pw.TextStyle(fontSize: 16, font: font),
                          ),
                        pw.Text(
                          '${d['CAND_NOMBRE1']} ${d['CAND_APELLIDOPATERNO']}',
                          style: pw.TextStyle(fontSize: 14, font: font),
                        ),
                        pw.Text(
                          '${d['DEPARTMENTO_NOMBRE']}',
                          style: pw.TextStyle(fontSize: 14, font: font),
                        ),
                        pw.Text(
                          'Puntuación Final de: ${d['CAND_NOTA_FINAL']}/150',
                          style: pw.TextStyle(fontSize: 14, font: font),
                        ),
                        pw.SizedBox(height: 5),
                      ],
                    ),
                  );
                }).toList(),
              ),

              pw.SizedBox(height: 20),
              pw.Text('____________________',
                  style: pw.TextStyle(fontSize: 14, font: font)),
              pw.Text('Veedor', style: pw.TextStyle(fontSize: 14, font: font)),
              pw.Text('Dr. Marcelo Mejía Mena',
                  style: pw.TextStyle(fontSize: 14, font: font)),
              pw.Text('CI: 1803061033',
                  style: pw.TextStyle(fontSize: 14, font: font)),
            ],
          ),
        ],
      ),
    );

    return pdf.save();
  }
}