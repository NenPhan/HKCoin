class CheckUpdateResult {
  final bool updateAvailable;
  final String? version;
  final String? name;
  final String? releaseNotes;
  final String? downloadUrl;
  final String? currentVersion;

  CheckUpdateResult({
    required this.updateAvailable,
    this.version,
    this.name,
    this.releaseNotes,
    this.downloadUrl,
    this.currentVersion,
  });

  factory CheckUpdateResult.fromJson(Map<String, dynamic> json) {
    return CheckUpdateResult(
      updateAvailable: json['UpdateAvailable'] ?? false,
      version: json['Version'],
      name: json['Name'],
      releaseNotes: json['ReleaseNotes'],
      downloadUrl: json['DownloadUrl'],
      currentVersion: json['CurrentVersion'],
    );
  }
}