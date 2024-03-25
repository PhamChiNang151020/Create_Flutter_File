import 'package:create_file_tool/utils/structure_json.dart';
import 'package:create_file_tool/widget/my_button.dart';
import 'package:flutter/material.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Config page".toUpperCase()),
        ),
        body: Center(
          child: Column(
            children: [
              // Text("Project name: "),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: MyData.dataConfigStructure.length,
                  itemBuilder: (context, index) {
                    final item = MyData.dataConfigStructure[index];

                    return SizedBox(
                        width: 150,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: MyButton(
                            title: "${item['title']}",
                            onPressed: () {},
                          ),
                        ));
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
