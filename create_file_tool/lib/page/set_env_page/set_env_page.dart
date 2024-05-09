// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';

import 'package:create_file_tool/common/my_assets.dart';
import 'package:create_file_tool/model/folder_model.dart';
import 'package:create_file_tool/utils/file_manager.dart';
import 'package:create_file_tool/utils/key_storage.dart';
import 'package:create_file_tool/utils/my_share_preferences.dart';
import 'package:create_file_tool/widget/my_button.dart';
import 'package:flutter/material.dart';

class SetupEnvPage extends StatefulWidget {
  const SetupEnvPage({super.key});

  @override
  _SetupEnvPageState createState() => _SetupEnvPageState();
}

class _SetupEnvPageState extends State<SetupEnvPage> {
  List<FolderData> _listSubFolder = [];
  String? _selectedFolderId;
  FolderData? _selectedFolder;

  @override
  void initState() {
    getListSubFolder();
    super.initState();
  }

  Future<void> getListSubFolder() async {
    final folderPath =
        await AppSharedPreferences().getSharedPreferences(KeyStorage.ENV_PATH);
    List<FolderData> subFolders = FileManager.getSubFolders(folderPath ?? "");
    setState(() {
      _listSubFolder = subFolders;

      _selectedFolderId = _getDefaultFolderId();
      _selectedFolder = _getDefaultFolder();
    });
  }

  String? _getDefaultFolderId() {
    for (FolderData folder in _listSubFolder) {
      if (folder.isDefault) {
        return folder.id;
      }
    }

    return null;
  }

  FolderData? _getDefaultFolder() {
    for (FolderData folder in _listSubFolder) {
      if (folder.isDefault) {
        return folder;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Set Env".toUpperCase()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _chooseFolder(),
            Expanded(
              child: ListView.builder(
                itemCount: _listSubFolder.length,
                itemBuilder: (context, index) {
                  final item = _listSubFolder[index];

                  return RadioListTile<FolderData>(
                    title: Container(
                      padding: const EdgeInsets.all(4),
                      width: 300,
                      decoration: BoxDecoration(
                          color: item.isDefault
                              ? const Color.fromARGB(255, 100, 223, 66)
                              : const Color.fromARGB(255, 204, 216, 211),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 40,
                            child: Image.asset(
                              item.isDefault
                                  ? MyAssets.icFolder
                                  : MyAssets.icFolderVersion,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(item.versionName),
                        ],
                      ),
                    ),
                    value: item,
                    groupValue: _selectedFolder,
                    onChanged: (FolderData? value) {
                      setState(() {
                        _selectedFolder = value;
                      });
                      if (item.versionId.isEmpty) {
                        _openVersionInputDialog(context);
                      }
                    },
                    activeColor: const Color.fromARGB(255, 100, 223, 66),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chooseFolder() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: MyButton(
            title: "Choose folder ENV",
            onPressed: () async {
              String? folderPath = await FileManager.chooseDirectory();
              List<FolderData> subFolders =
                  FileManager.getSubFolders(folderPath ?? "");
              AppSharedPreferences()
                  .setSharedPreferences(KeyStorage.ENV_PATH, folderPath);

              setState(() {
                _listSubFolder = subFolders;
                _selectedFolder = _getDefaultFolder();
              });
            },
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 7,
          child: FutureBuilder(
            future: AppSharedPreferences()
                .getSharedPreferences(KeyStorage.ENV_PATH),
            builder: (context, snapshot) {
              return Text("PATH: ${snapshot.data}");
            },
          ),
        )
      ],
    );
  }

  void _openVersionInputDialog(BuildContext context) {
    String versionId = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Version Info'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  versionId = value;
                },
                decoration: const InputDecoration(labelText: 'Version ID'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addOrUpdateFolderData(versionId);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addOrUpdateFolderData(String versionId) {
    final existingFolderDataIndex =
        _listSubFolder.indexWhere((folderData) => folderData.versionId == "");
    if (existingFolderDataIndex != -1) {
      // Update existing FolderData
      _listSubFolder[existingFolderDataIndex] =
          _listSubFolder[existingFolderDataIndex].copyWith(
        id: "flutter_$versionId",
        versionId: versionId,
        versionName: "Version $versionId",
      );
      log("${_listSubFolder[existingFolderDataIndex]}");
    }
    setState(() {});
  }
}
