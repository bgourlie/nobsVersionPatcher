library client_version_patcher;

import 'dart:async';
import 'package:barback/barback.dart';
import 'package:nvp/nvp.dart' as nvp;

class ClientVersionPatcher extends Transformer{
  final BarbackSettings _settings;

  ClientVersionPatcher.asPlugin(this._settings);

  Future apply(Transform transform) {
      if(_settings.mode.name == 'debug') {
        return null;
      }

      return transform.primaryInput.readAsString().then((content) {
        final buildInfo = nvp.getBuildInfo();
        final id = transform.primaryInput.id;
        var newContent = _replaceConst(content, 'BUILD_NUMBER', buildInfo['BUILD_NUMBER']);
        newContent = _replaceConst(newContent, 'BRANCH', buildInfo['BRANCH']);
        newContent = _replaceConst(newContent, 'COMMIT_ID', buildInfo['COMMIT_ID']);
        newContent = _replaceConst(newContent, 'BUILD_TIME', buildInfo['BUILD_TIME']);
        transform.addOutput(new Asset.fromString(id,  newContent));
      });
  }

  Future<bool> isPrimary(AssetId id) {
    final entryPoint = 'web/${this._settings.configuration['entryPoint']}';
    return new Future<bool>(() => id.path == '$entryPoint');
  }

  static String _replaceConst(String content, String constName, String newValue){
    final regex = new RegExp(r"const " + constName + r" = '(.+)'");
    return content.replaceFirst(regex, 'const $constName = "$newValue"');
  }
}