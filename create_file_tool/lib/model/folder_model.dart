import 'dart:convert';

class FolderData {
  final String id;
  final String path;
  final String folderName;
  final bool isDefault;
  final String versionName;
  final String versionId;
  FolderData({
    required this.id,
    required this.path,
    required this.folderName,
    required this.isDefault,
    required this.versionName,
    required this.versionId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'path': path,
      'folderName': folderName,
      'isDefault': isDefault,
      'versionName': versionName,
      'versionId': versionId,
    };
  }

  factory FolderData.fromMap(Map<String, dynamic> map) {
    return FolderData(
      id: map['id'] ?? '',
      path: map['path'] ?? '',
      folderName: map['folderName'] ?? '',
      isDefault: map['isDefault'] ?? false,
      versionName: map['versionName'] ?? '',
      versionId: map['versionId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory FolderData.fromJson(String source) =>
      FolderData.fromMap(json.decode(source));

  FolderData copyWith({
    String? id,
    String? path,
    String? folderName,
    bool? isDefault,
    String? versionName,
    String? versionId,
  }) {
    return FolderData(
      id: id ?? this.id,
      path: path ?? this.path,
      folderName: folderName ?? this.folderName,
      isDefault: isDefault ?? this.isDefault,
      versionName: versionName ?? this.versionName,
      versionId: versionId ?? this.versionId,
    );
  }

  @override
  String toString() {
    return 'FolderData(id: $id, path: $path, folderName: $folderName, isDefault: $isDefault, versionName: $versionName, versionId: $versionId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is FolderData &&
      other.id == id &&
      other.path == path &&
      other.folderName == folderName &&
      other.isDefault == isDefault &&
      other.versionName == versionName &&
      other.versionId == versionId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      path.hashCode ^
      folderName.hashCode ^
      isDefault.hashCode ^
      versionName.hashCode ^
      versionId.hashCode;
  }
}
