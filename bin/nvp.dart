import 'dart:io';
import 'dart:convert' show JSON;
import 'package:path/path.dart' as path;
import 'package:args/args.dart';

int main(args) {
  final env = Platform.environment;
  final parser = new ArgParser();
  final patchServerCmd = parser.addCommand("genServerVersion");
  patchServerCmd.addOption("projectDir", abbr: 'p', defaultsTo: Directory.current.path, help: "The directory where the project.json exists.");
  patchServerCmd.addOption('out', abbr: 'o', defaultsTo: path.join(Directory.current.path, 'version.json'), help: "Where to write the version.json file.");
  final parsed = parser.parse(args);

  switch(parsed.command.name){
    case "genServerVersion":

      final projectDir = parsed.command["projectDir"];
      var projectJson = new File(path.join(projectDir, "project.json"));

      if(!projectJson.existsSync()){
        print("project.json not found.");
        return 60;
      }

      final parsedProjectJson = JSON.decode(projectJson.readAsStringSync());
      final version = parsedProjectJson['version'];
      final buildNumber = env['TRAVIS_BUILD_NUMBER'];
      final commitId = env['TRAVIS_COMMIT'];
      final branch = env['TRAVIS_BRANCH'];

      final versionObj = {
          'version' : version,
          'buildNumber' : buildNumber,
          'branch' : branch,
          'commitId' : commitId,
          'buildTime' : new DateTime.now().toUtc().toIso8601String()
      };

      final outputLocation = parsed.command["out"];
      final outputFile = new File(outputLocation);
      outputFile.writeAsStringSync(JSON.encode(versionObj));
      break;
  default:
    print('unknown command');
    return 70;
  }

  return 0;
}
