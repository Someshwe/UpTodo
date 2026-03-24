import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/pdf_file.dart';

class StoreProvider extends ChangeNotifier {
  final List<PDFFile> _pdfFiles = [];
  static const String _pdfsKey = 'pdfs_list';
  late SharedPreferences _prefs;

  List<PDFFile> get pdfFiles => _pdfFiles;
  int get filesCount => _pdfFiles.length;

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadPDFs();
  }

  // Save PDFs to local storage
  Future<void> _savePDFs() async {
    try {
      final pdfList = _pdfFiles.map((pdf) {
        return {
          'id': pdf.id,
          'fileName': pdf.fileName,
          'filePath': pdf.filePath,
          'fileSize': pdf.fileSize,
          'addedAt': pdf.addedAt.toIso8601String(),
        };
      }).toList();
      await _prefs.setString(_pdfsKey, jsonEncode(pdfList));
    } catch (e) {
      debugPrint('Error saving PDFs: $e');
    }
  }

  // Load PDFs from local storage
  Future<void> _loadPDFs() async {
    try {
      final pdfsJson = _prefs.getString(_pdfsKey);
      if (pdfsJson != null) {
        final List<dynamic> decodedList = jsonDecode(pdfsJson);
        _pdfFiles.clear();
        for (var pdfJson in decodedList) {
          _pdfFiles.add(
            PDFFile(
              id: pdfJson['id'],
              fileName: pdfJson['fileName'],
              filePath: pdfJson['filePath'],
              fileSize: pdfJson['fileSize'],
              addedAt: DateTime.parse(pdfJson['addedAt']),
            ),
          );
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading PDFs: $e');
    }
  }

  // Add PDF
  void addPDF(String fileName, String filePath, double fileSize) {
    if (fileName.isEmpty) return;

    final newPDF = PDFFile(
      id: const Uuid().v4(),
      fileName: fileName,
      filePath: filePath,
      fileSize: fileSize,
      addedAt: DateTime.now(),
    );

    _pdfFiles.insert(0, newPDF);
    _savePDFs();
    notifyListeners();
  }

  // Delete PDF
  PDFFile? deletePDF(String id) {
    final index = _pdfFiles.indexWhere((pdf) => pdf.id == id);
    if (index != -1) {
      final deletedPDF = _pdfFiles.removeAt(index);
      _savePDFs();
      notifyListeners();
      return deletedPDF;
    }
    return null;
  }

  // Restore PDF
  void restorePDF(PDFFile pdf) {
    _pdfFiles.insert(0, pdf);
    _savePDFs();
    notifyListeners();
  }

  // Get PDF by id
  PDFFile? getPDFById(String id) {
    try {
      return _pdfFiles.firstWhere((pdf) => pdf.id == id);
    } catch (e) {
      return null;
    }
  }

  // Clear all PDFs
  Future<void> clearAllPDFs() async {
    _pdfFiles.clear();
    await _prefs.remove(_pdfsKey);
    notifyListeners();
  }

  // Format file size
  String formatFileSize(double bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    int i = 0;
    double size = bytes.toDouble();
    while (size > 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    return '${size.toStringAsFixed(2)} ${suffixes[i]}';
  }
}
