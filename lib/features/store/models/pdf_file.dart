class PDFFile {
  final String id;
  final String fileName;
  final String filePath;
  final double fileSize;
  final DateTime addedAt;

  PDFFile({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.fileSize,
    required this.addedAt,
  });

  PDFFile copyWith({
    String? id,
    String? fileName,
    String? filePath,
    double? fileSize,
    DateTime? addedAt,
  }) {
    return PDFFile(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      fileSize: fileSize ?? this.fileSize,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}
