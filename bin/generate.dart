import 'dart:io';
import 'dart:isolate';
import 'package:args/args.dart';
import 'package:path/path.dart' as p;

Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('target', allowed: ['web', 'mobile'], help: 'Build target');

  final args = parser.parse(arguments);
  final target = args['target'];

  if (target == null) {
    _exitWithError(
        '❌ Error: --target is required. Use --target=web or --target=mobile');
  }

  final resolved = await Isolate.resolvePackageUri(
    Uri.parse(
        'package:flutter_secure_recaptcha/assets/recaptcha_template.html'),
  );

  if (resolved == null) {
    _exitWithError(
        '❌ Error: Could not resolve path to recaptcha_template.html');
  }

  final templateFile = File(resolved!.toFilePath());
  if (!templateFile.existsSync()) {
    _exitWithError('❌ Error: Template file not found.');
  }

  final content = await templateFile.readAsString();
  final outputPath = _getOutputPath(target);
  final outputFile = File(outputPath);

  await outputFile.create(recursive: true);
  await outputFile.writeAsString(content);

  stdout.writeln('✅ recaptcha.html created');
}

String _getOutputPath(String target) {
  final basePath = Directory.current.path;
  return target == 'mobile'
      ? p.join(basePath, 'recaptcha_asset', 'recaptcha.html')
      : p.join(basePath, 'web', 'recaptcha.html');
}

void _exitWithError(String message) {
  stderr.writeln(message);
  exit(1);
}
