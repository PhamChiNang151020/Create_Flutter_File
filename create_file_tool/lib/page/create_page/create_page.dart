import 'package:create_file_tool/utils/file_manager.dart';
import 'package:create_file_tool/widget/my_button.dart';
import 'package:create_file_tool/widget/my_toast.dart';
import 'package:flutter/material.dart';

import '../../utils/key_storage.dart';
import '../../utils/my_share_preferences.dart';

class CreateFilePage extends StatefulWidget {
  const CreateFilePage({super.key});

  @override
  State<CreateFilePage> createState() => _CreateFilePageState();
}

class _CreateFilePageState extends State<CreateFilePage> {
  final _fileNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isOpenFolder = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create file page".toUpperCase()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: AppSharedPreferences()
                    .getSharedPreferences(KeyStorage.PROJECT_NAME),
                builder: (context, snapshot) {
                  return Text("Project Name: ${snapshot.data}");
                },
              ),
              const SizedBox(height: 20),
              _fileName(),
              const SizedBox(height: 20),
              MyButton(
                width: 300,
                title: "Choose Directory and Create File",
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    FileManager.chooseDirectoryAndCreateFile(
                      fileName: _fileNameController.text,
                    ).then((value) => {
                          MyToast.showToastSuccess(
                            message: "File created successfully",
                          ),
                          _fileNameController.clear(),
                          setState(() {
                            isOpenFolder = true;
                          }),
                        });
                  }
                },
              ),
              const SizedBox(height: 20),
              isOpenFolder
                  ? MyButton(
                      title: "Open Folder",
                      onPressed: () {
                        FileManager.openFolder();
                      })
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Row _fileName() {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: TextFormField(
            controller: _fileNameController,
            decoration: const InputDecoration(
              hintText: "File name",
              hintStyle: TextStyle(color: Colors.blueGrey),
              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "Please enter file name";
              }
              return null;
            },
          ),
        ),
        const Expanded(flex: 6, child: SizedBox()),
      ],
    );
  }
}
