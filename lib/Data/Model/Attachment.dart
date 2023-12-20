class Attachment {
  int fileId;
  String fileName;
  String fileExt;
  String filePath;
  String url;

  Attachment({
    required this.fileId,
    required this.fileName,
    required this.fileExt,
    required this.filePath,
    required this.url,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
        fileId: json['file_id'],
        fileName: json['file_name'],
        fileExt: json['file_ext'],
        filePath: json['file_path'],
        url: json['url']);
  }
}
