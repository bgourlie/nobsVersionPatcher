import 'dart:io';
import 'dart:convert' show JSON;
import 'package:path/path.dart' as path;
import 'package:args/args.dart';
import 'package:nvp/nvp.dart' as nvp;

int main(args) {
  final parser = new ArgParser();
  parser.addCommand('genServerVersion')
      ..addOption('projectDir', abbr: 'p', defaultsTo: Directory.current.path, help: 'The directory where the project.json exists.')
      ..addOption('out', abbr: 'o', defaultsTo: path.join(Directory.current.path, 'version.json'), help: 'Where to write the version.json file.');

  final parsed = parser.parse(args);

  if(parsed.command == null){
    print('No command or unknown command specified.');
    return 1;
  }

  try{
    switch(parsed.command.name){
      case 'genServerVersion':
        final projectDir = parsed.command['projectDir'];
        final version = nvp.getServerVersion(projectDir);
        final versionObj = nvp.getBuildInfo();
        versionObj['VERSION'] = version;
        final outputLocation = parsed.command['out'];
        final outputFile = new File(outputLocation);
        outputFile.writeAsStringSync(JSON.encode(versionObj));
        print('Successfully wrote $outputFile');
        break;
    default:
      print('command not implemented.');
      return 70;
    }
  }catch(ex) {
    if (ex is String) {
      print(ex);
      return 60;
    }
    rethrow;
  }
  return 0;
}
