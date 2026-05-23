import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  for (final file in files) {
    if (file.path.endsWith('.g.dart')) continue;
    var content = file.readAsStringSync();
    if (content.contains('@riverpod') || content.contains('Riverpod(')) {
      if (!content.contains("import 'package:flutter_riverpod/flutter_riverpod.dart';") &&
          !content.contains("import 'package:riverpod/riverpod.dart';")) {
        // Insert after the first import or at the beginning
        final lines = content.split('\n');
        int insertIndex = 0;
        for (int i = 0; i < lines.length; i++) {
          if (lines[i].startsWith('import ')) {
            insertIndex = i + 1;
          } else if (lines[i].trim().isNotEmpty && insertIndex > 0) {
            break;
          }
        }
        lines.insert(insertIndex, "import 'package:flutter_riverpod/flutter_riverpod.dart';");
        file.writeAsStringSync(lines.join('\n'));
        print('Added import to ${file.path}');
      }
    }
  }
}
