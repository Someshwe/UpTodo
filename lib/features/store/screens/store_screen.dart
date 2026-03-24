import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:ui';
import '../providers/store_provider.dart';
import '../widgets/pdf_card.dart';
import '../widgets/empty_store_state.dart';
import '../widgets/add_pdf_dialog.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_effect.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  void _showAddPDFDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddPDFDialog(
        onSave: (fileName, fileSize) {
          context.read<StoreProvider>().addPDF(
            fileName,
            'storage/pdfs/$fileName',
            fileSize,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('📁 PDF stored!'),
              duration: Duration(seconds: 2),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  Future<void> _browseAndPickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'doc',
          'docx',
          'txt',
          'xls',
          'xlsx',
          'ppt',
          'pptx',
        ],
        allowMultiple: false,
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        final storeProvider = context.read<StoreProvider>();
        storeProvider.addPDF(file.name, file.path ?? '', file.size / 1024);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('📁 ${file.name} stored successfully!'),
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking file: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('📄 Store'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<StoreProvider>(
        builder: (context, storeProvider, _) {
          return Column(
            children: [
              // Browse Button with Modern Glass Effect
              Padding(
                padding: const EdgeInsets.all(16),
                child: GlassEffect(
                  blur: 15,
                  borderRadius: BorderRadius.circular(24),
                  color: AppColors.glassDark,
                  opacity: 0.7,
                  border: Border.all(
                    color: AppColors.accentCyan.withOpacity(0.4),
                    width: 1.5,
                  ),
                  padding: EdgeInsets.zero,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _browseAndPickFile,
                      borderRadius: BorderRadius.circular(24),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 24,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.file_open_rounded,
                              color: AppColors.accentCyan,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Browse & Add Files',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Files List
              Expanded(
                child: storeProvider.pdfFiles.isEmpty
                    ? const EmptyStoreState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: storeProvider.pdfFiles.length,
                        itemBuilder: (context, index) {
                          final pdf = storeProvider.pdfFiles[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: PDFCard(
                              pdf: pdf,
                              onDelete: () {
                                storeProvider.deletePDF(pdf.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('🗑️ File deleted!'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryGradient1, AppColors.primaryGradient2],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGradient1.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showAddPDFDialog(context),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(Icons.add_rounded, size: 28, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
