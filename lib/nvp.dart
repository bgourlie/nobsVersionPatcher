library nvp;

import 'dart:io';
import 'dart:convert' show JSON;
import 'package:path/path.dart' as path;
import 'package:xml/xml.dart' as xml;

String getServerVersion(String projectDir){
  var projectJson = new File(path.join(projectDir, 'project.json'));

  if(!projectJson.existsSync()){
    throw 'project.json not found.';
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

void patchWebConfig(String configLocation){
  const patchFragment = """

  <system.webServer>
    <staticContent>
      <mimeMap fileExtension=".json" mimeType="text/html" />
    </staticContent>
  </system.webServer>
""";

  final configFile = new File(configLocation);
  if(!configFile.existsSync()){
    throw '$configFile doesn\'t exist';
  }

  final configContents = configFile.readAsStringSync();

  if(configContents.contains(patchFragment)){
    throw 'It appears $configLocation has already been patched.';
  }

  final patched = configContents.replaceFirst(r'<configuration>', '<configuration>$patchFragment');
  configFile.writeAsStringSync(patched, mode: FileMode.WRITE);
}