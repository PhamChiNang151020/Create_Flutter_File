import 'dart:developer';
import 'dart:io';

import 'package:create_file_tool/model/folder_model.dart';

import 'package:create_file_tool/template/template_file_v2.dart';
import 'package:create_file_tool/utils/key_storage.dart';
import 'package:create_file_tool/utils/my_share_preferences.dart';
import 'package:file_selector/file_selector.dart' as file_selector;

class FileManagerV2 {
  static Future<String?> chooseDirectory() async {
    final directory = await file_selector.getDirectoryPath();
    return directory;
  }

  static Future<void> chooseDirectoryAndCreateFile({
    required String fileName,
  }) async {
    final directory = await file_selector.getDirectoryPath();
    if (directory != null) {
      log('Selected Directory: $directory');
      AppSharedPreferences()
          .setSharedPreferences(KeyStorage.PROJECT_PATH, directory);

      createDirectoryAndFile(
        directory: directory,
        fileName: fileName,
      );
    } else {
      log('No directory selected.');
    }
  }

  static Future<void> createDirectoryAndFile(
      {required String directory, required String fileName}) async {
    final projectName = await AppSharedPreferences()
        .getSharedPreferences(KeyStorage.PROJECT_NAME);
    final folder = Directory('$directory/$fileName');
    folder.createSync(recursive: true);

    // * Create file BLoC
    File blocFile = File('$directory/$fileName/${fileName}_bloc.dart');
    blocFile.writeAsStringSync(
      FileContentV2.getContentBLoC(
        projectName: projectName,
        fileName: fileName,
      ),
    );

    // * Create file State
    File stateFile = File('$directory/$fileName/${fileName}_state.dart');
    stateFile.writeAsStringSync(
      FileContentV2.getContentState(
          projectName: projectName, fileName: fileName),
    );

    // * Create file Event
    File eventFile = File('$directory/$fileName/${fileName}_event.dart');
    eventFile.writeAsStringSync(
      FileContentV2.getContentEvent(
          projectName: projectName, fileName: fileName),
    );

    // * Create file Page
    File pageFile = File('$directory/$fileName/${fileName}_page.dart');
    pageFile.writeAsStringSync(
      FileContentV2.getContentPage(
        projectName: projectName,
        fileName: fileName,
      ),
    );
  }

  static Future<void> openFolder() async {
    final folderPath = await AppSharedPreferences()
        .getSharedPreferences(KeyStorage.PROJECT_PATH);
    await Process.run('open', [folderPath]);
  }

  static List<FolderData> getSubFolders(String folderPath) {
    if (folderPath.isEmpty || folderPath == "") {
      return [];
    }
    Directory directory = Directory(folderPath);
    List<FileSystemEntity> subFolders = directory.listSync();
    List<FolderData> folderDataList = [];
    bool hasDefault = false;

    for (var entity in subFolders) {
      if (entity is Directory) {
        String folderName = entity.path.split('/').last;
        String versionName = formatVersionName(folderName);
        String versionId = formatVersionId(folderName);
        bool isDefault = folderName == "flutter";
        if (isDefault && !hasDefault) {
          hasDefault = true;
          versionName = "";
          versionId = "";
        } else {
          isDefault = false;
        }
        folderDataList.add(
          FolderData(
            id: folderName,
            path: entity.path,
            folderName: folderName,
            isDefault: isDefault,
            versionName: versionName,
            versionId: versionId,
          ),
        );
      }
    }
    // log(folderDataList);
    return folderDataList;
  }

  static String formatVersionName(String input) {
    String versionNumber = input.replaceAll("flutter_", "");

    versionNumber = versionNumber.replaceAll("_", ".");

    return "Version $versionNumber";
  }

  static String formatVersionId(String input) {
    String versionNumber = input.replaceAll("flutter_", "");
    versionNumber = versionNumber.replaceAll("_", ".");
    return versionNumber;
  }
}
