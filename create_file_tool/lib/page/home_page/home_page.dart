import 'package:create_file_tool/page/config_page/config_page.dart';
import 'package:create_file_tool/page/create_page/create_page.dart';
import 'package:create_file_tool/page/set_env_page/set_env_page.dart';
import 'package:create_file_tool/utils/key_storage.dart';
import 'package:create_file_tool/utils/my_share_preferences.dart';
import 'package:create_file_tool/widget/my_button.dart';
import 'package:create_file_tool/widget/my_toast.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _projectNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _setProjectName(),
              const SizedBox(height: 20),
              MyButton(
                  title: "Config Structure",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ConfigPage()),
                    );
                  }),
              const SizedBox(height: 20),
              MyButton(
                title: "Create File",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateFilePage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              MyButton(
                title: "Set ENV Flutter",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SetupEnvPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Form _setProjectName() {
    return Form(
      key: _formKey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Set Project Name"),
          const SizedBox(width: 20),
          SizedBox(
            width: 300,
            child: TextFormField(
              controller: _projectNameController,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  hintText: 'Enter your project name',
                  hintStyle:
                      TextStyle(color: Color.fromARGB(194, 96, 125, 139))),
              keyboardType: TextInputType.number,
              validator: _validateInput,
              onSaved: (String? value) {},
            ),
          ),
          const SizedBox(width: 20),
          _btnSave()
        ],
      ),
    );
  }

  Widget _btnSave() {
    return MyButton(
        title: "Save",
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            AppSharedPreferences()
                .setSharedPreferences(
                    KeyStorage.PROJECT_NAME, _projectNameController.text)
                .then((value) =>
                    MyToast.showToastSuccess(message: "Save success!"));
          } else {
            MyToast.showToastError(message: "Cannot Save!");
          }
        });
  }

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      // MyToast.showToastSuccess(message: "Please enter a value!");
      return 'Please enter a value';
    }
    if (value.contains(' ')) {
      // MyToast.showToastSuccess(message: "No spaces allowed");
      return 'No spaces allowed';
    }
    if (value.contains(RegExp(r'[A-Z]'))) {
      // MyToast.showToastSuccess(message: "No uppercase letters allowed");
      return 'No uppercase letters allowed';
    }

    return null;
  }
}
