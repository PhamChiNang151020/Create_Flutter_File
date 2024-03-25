class FileContent {
  static String getContentBLoC({
    required String projectName,
    required String fileName,
  }) {
    return '''
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:$projectName/base_class/bloc/base_bloc.dart';
import '$fileName.dart';

class ${snakeCaseToPascalCase(fileName)}Bloc extends BaseBloc{
  ${snakeCaseToPascalCase(fileName)}Bloc(super.initialState, super.context){
    //on<ExampleEvent>(_exampleEvent);
  }

  // Future<void> _exampleEvent(
  //     CreateEnquiry event,
  //     Emitter<BaseBlocState> emit,
  //     ) async {
        // do something in here
  // }
}
    ''';
  }

  static String getContentState({required String projectName}) {
    return '''''';
  }

  static String getContentEvent({required String projectName}) {
    return '''''';
  }

  static String getContentExport({required String fileName}) {
    return '''
export '${fileName}_bloc.dart';
export '${fileName}_event.dart';
export '${fileName}_form.dart';
export '${fileName}_page.dart';
export '${fileName}_state.dart';

''';
  }

  static String getContentPage(
      {required String projectName, required String fileName}) {
    final newValue = snakeCaseToPascalCase(fileName);
    return '''
import 'package:$projectName/base_class/bloc/base_bloc_page.dart';
import 'package:$projectName/utils/utils.dart';
import 'package:$projectName/base_class/router.dart';
import 'package:flutter/material.dart';
import '$fileName.dart';

class ${newValue}Page extends BaseBlocPage<${newValue}Bloc> {
  const ${newValue}Page({super.key});

  @override
  Widget getForm() {
    return const ${newValue}Form();
  }

  @override
  ${newValue}Bloc myBloc(BuildContext context) {
    return ${newValue}Bloc(initialState, context);
  }
}
goto${newValue}Page({required BuildContext context}) {
  var data = {};
  Utils().changeScreenNamedWithData(context, "PAGE_NAME", data);
}

${newValue}Page ${snakeCaseToLowerCamelCase(fileName)}Page(RouteSettings settings) {
  var arguments = getArguments(settings);
  //var type = arguments["field name"];
  return const ${newValue}Page();
}
    ''';
  }

  static String getContentForm(
      {required String projectName, required String fileName}) {
    final newValue = snakeCaseToPascalCase(fileName);
    return '''
import 'package:$projectName/base_class/bloc/base_bloc_form_state_full.dart';
import 'package:$projectName/base_class/bloc/base_state.dart';

import 'package:flutter/material.dart';
import '$fileName.dart';


class ${newValue}Form extends StatefulWidget {
  const ${newValue}Form({super.key});

  @override
  State<${newValue}Form> createState() => _${newValue}FormState();
}

class _${newValue}FormState extends BaseBLocFormStateFull<${newValue}Bloc, ${newValue}Form> {
  @override
  Widget getWidget(BuildContext context, BaseBlocState state) {
    return Container();
  }

  @override
  void listener(BuildContext context, BaseBlocState state) {
    // TODO: implement listener
  }
}
    ''';
  }

  static String snakeCaseToPascalCase(String input) {
    List<String> words = input.split('_');
    String result = '';
    for (String word in words) {
      result += word[0].toUpperCase() + word.substring(1);
    }
    return result;
  }

  static String snakeCaseToLowerCamelCase(String input) {
    List<String> words = input.split('_');
    String result = words[0];
    for (int i = 1; i < words.length; i++) {
      result += words[i][0].toUpperCase() + words[i].substring(1);
    }
    return result;
  }
}
