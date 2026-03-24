import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class AddPDFDialog extends StatefulWidget {
  final Function(String fileName, double fileSize) onSave;

  const AddPDFDialog({Key? key, required this.onSave}) : super(key: key);

  @override
  State<AddPDFDialog> createState() => _AddPDFDialogState();
}

class _AddPDFDialogState extends State<AddPDFDialog> {
  late TextEditingController _fileNameController;
  late TextEditingController _fileSizeController;

  @override
  void initState() {
    super.initState();
    _fileNameController = TextEditingController();
    _fileSizeController = TextEditingController();
  }

  @override
  void dispose() {
    _fileNameController.dispose();
    _fileSizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Store PDF',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _fileNameController,
                decoration: InputDecoration(
                  labelText: 'PDF File Name',
                  hintText: 'e.g., document.pdf',
                  prefixIcon: const Icon(Icons.description),
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _fileSizeController,
                decoration: InputDecoration(
                  labelText: 'File Size (in KB)',
                  hintText: 'e.g., 1024',
                  prefixIcon: const Icon(Icons.storage),
                ),
                maxLines: 1,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(AppConstants.cancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_fileNameController.text.isEmpty ||
                            _fileSizeController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill all fields'),
                            ),
                          );
                          return;
                        }
                        widget.onSave(
                          _fileNameController.text,
                          double.parse(_fileSizeController.text) * 1024,
                        );
                        Navigator.pop(context);
                      },
                      child: const Text(AppConstants.save),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
