library nvp;

import 'dart:io';
import 'dart:convert' show JSON;
import 'package:path/path.dart' as path;

String getServerVersion(String projectDir){
  var projectJson = new File(path.join(projectDir, "project.json"));

  if(!projectJson.existsSync()){
    throw "project.json not found.";
  }

  final parsedProjectJson = JSON.decode(projectJson.readAsStringSync());
  return parsedProjectJson['version'];
}

Map<String, String> getBuildInfo(){
  final env = Platform.environment;
  return {
      'buildNumber' : env['TRAVIS_BUILD_NUMBER'],
      'branch' : env['TRAVIS_BRANCH'],
      'commitId' : env['TRAVIS_COMMIT'],
      'buildTime' : new DateTime.now().toUtc().toIso8601String()
  };
}