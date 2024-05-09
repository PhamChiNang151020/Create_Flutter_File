import 'dart:developer';
import 'dart:io';

import 'package:create_file_tool/model/folder_model.dart';
import 'package:create_file_tool/template/template_file.dart';
import 'package:create_file_tool/utils/key_storage.dart';
import 'package:create_file_tool/utils/my_share_preferences.dart';
import 'package:file_selector/file_selector.dart' as file_selector;

class FileManager {
  static Future<String?> chooseDirectory() async {
    final directory = await file_selector.getDirectoryPath();
    return directory;
  }

  /// Asynchronously chooses a directory to store a file and creates the file with the given [fileName].
  ///
  /// The [fileName] parameter is required and represents the name of the file to be created.
  ///
  /// Returns a [Future] that completes with void once the directory is chosen and the file is created.
  static Future<void> chooseDirectoryAndCreateFile(
      {required String fileName}) async {
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

  /// Creates a new directory and file with the given [directory] and [fileName].
  ///
  /// The function creates a new directory with the name [fileName] inside the
  /// [directory]. It then creates a new file with the name [fileName].dart inside
  /// the newly created directory and writes the string "Hello, World!" to the file.
  ///
  /// Parameters:
  /// - [directory]: The path of the directory where the new directory and file
  ///   should be created.
  /// - [fileName]: The name of the new directory and file.
  ///
  /// Returns: None.
  static Future<void> createDirectoryAndFile(
      {required String directory, required String fileName}) async {
    final projectName = await AppSharedPreferences()
        .getSharedPreferences(KeyStorage.PROJECT_NAME);
    final folder = Directory('$directory/$fileName');
    folder.createSync(recursive: true);

    // * Create file BLoC
    File blocFile = File('$directory/$fileName/${fileName}_bloc.dart');
    blocFile.writeAsStringSync(
      FileContent.getContentBLoC(
        projectName: projectName,
        fileName: fileName,
      ),
    );

    // * Create file State
    File stateFile = File('$directory/$fileName/${fileName}_state.dart');
    stateFile.writeAsStringSync(
      FileContent.getContentState(projectName: projectName),
    );

    // * Create file Event
    File eventFile = File('$directory/$fileName/${fileName}_event.dart');
    eventFile.writeAsStringSync(
      FileContent.getContentEvent(projectName: projectName),
    );

    // * Create file Form
    File formFile = File('$directory/$fileName/${fileName}_form.dart');
    formFile.writeAsStringSync(
      FileContent.getContentForm(
        projectName: projectName,
        fileName: fileName,
      ),
    );

    // * Create file Page
    File pageFile = File('$directory/$fileName/${fileName}_page.dart');
    pageFile.writeAsStringSync(
      FileContent.getContentPage(
        projectName: projectName,
        fileName: fileName,
      ),
    );
    // * Create file Page
    File exportFile = File('$directory/$fileName/$fileName.dart');
    exportFile.writeAsStringSync(
      FileContent.getContentExport(fileName: fileName),
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
