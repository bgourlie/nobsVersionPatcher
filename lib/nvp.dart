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
      'BUILD_NUMBER' : env['TRAVIS_BUILD_NUMBER'],
      'BRANCH' : env['TRAVIS_BRANCH'],
      'COMMIT_ID' : env['TRAVIS_COMMIT'],
      'BUILD_TIME' : env['BUILD_TIME']
  };
}