import 'package:intl/intl.dart';

class FileContentV2 {
  static String getContentBLoC({
    required String projectName,
    required String fileName,
  }) {
    final nameOfClass = snakeCaseToPascalCase(fileName);
    final date = DateFormat('dd/MM/yyyy').format(DateTime.now());
    return '''
// * Author: phamchinang
// * Date: $date
// * ====================


import 'package:bloc/bloc.dart';
import 'package:$projectName/core/base/base_bloc.dart';
import 'package:$projectName/core/base/base_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part '${fileName}_event.dart';
part '${fileName}_state.dart';

class ${nameOfClass}Bloc extends BaseBloc<${nameOfClass}Event, ${nameOfClass}State> {
  ${nameOfClass}Bloc() : super(${nameOfClass}Initial()) {
    on<Init${nameOfClass}Event>(_mapInitState);
  }

  Future<void> _mapInitState(
    Init${nameOfClass}Event event,
    Emitter<${nameOfClass}State> emit,
  ) async {
    emit(${nameOfClass}InitSuccessful());
  }
}
    ''';
  }

  static String getContentState({
    required String projectName,
    required String fileName,
  }) {
    final nameOfClass = snakeCaseToPascalCase(fileName);
    final date = DateFormat('dd/MM/yyyy').format(DateTime.now());
    return '''
// * Author: phamchinang
// * Date: $date
// * ====================


part of '${fileName}_bloc.dart';

@immutable
sealed class ${nameOfClass}State extends BaseState {
  const ${nameOfClass}State();
}

class ${nameOfClass}Initial extends ${nameOfClass}State {
  @override
  bool get isLoading => true;
}

class ${nameOfClass}InitSuccessful extends ${nameOfClass}State {
  @override
  bool get isLoading => false;
}
  ''';
  }

  static String getContentEvent({
    required String projectName,
    required String fileName,
  }) {
    final nameOfClass = snakeCaseToPascalCase(fileName);
    final date = DateFormat('dd/MM/yyyy').format(DateTime.now());
    return '''
// * Author: phamchinang
// * Date: $date

// * ====================


part of '${fileName}_bloc.dart';

abstract class ${nameOfClass}Event extends Equatable {
  const ${nameOfClass}Event();

  @override
  List<Object> get props => [];
}

class Init${nameOfClass}Event extends ${nameOfClass}Event {}

''';
  }

  static String getContentPage({
    required String projectName,
    required String fileName,
  }) {
    final nameOfClass = snakeCaseToPascalCase(fileName);
    final date = DateFormat('dd/MM/yyyy').format(DateTime.now());
    return '''
// * Author: phamchinang
// * Date: $date
// * ====================


import 'package:$projectName/core/base/base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '${fileName}_bloc.dart';


class ${nameOfClass}Page extends BasePage<${nameOfClass}Bloc> {
  const ${nameOfClass}Page({super.key});

  @override
  ${nameOfClass}Bloc createBloc() => ${nameOfClass}Bloc()..add(Init${nameOfClass}Event());

  @override
  State<StatefulWidget> createState() {
    return _${nameOfClass}PageState();
  }
}

class _${nameOfClass}PageState extends BasePageState<${nameOfClass}Page, ${nameOfClass}Bloc> {
  @override
  Widget buildContent(BuildContext context) {
    return Scaffold(
      body: BlocListener<${nameOfClass}Bloc, ${nameOfClass}State>(
        listener: (context, state) {
          if (state is ${nameOfClass}InitSuccessful) {
            //* context.go('/home');
          }
        },
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

    ''';
  }

//   static String getContentForm(
//       {required String projectName, required String fileName}) {
//     final newValue = snakeCaseToPascalCase(fileName);
//     return '''
// import 'package:$projectName/base_class/bloc/base_bloc_form_state_full.dart';
// import 'package:$projectName/base_class/bloc/base_state.dart';

// import 'package:flutter/material.dart';
// import '$fileName.dart';

// class ${newValue}Form extends StatefulWidget {
//   const ${newValue}Form({super.key});

//   @override
//   State<${newValue}Form> createState() => _${newValue}FormState();
// }

// class _${newValue}FormState extends BaseBLocFormStateFull<${newValue}Bloc, ${newValue}Form> {
//   @override
//   Widget getWidget(BuildContext context, BaseBlocState state) {
//     return Container();
//   }

//   @override
//   void listener(BuildContext context, BaseBlocState state) {
//     // TODO: implement listener
//   }
// }
//     ''';
//   }

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
