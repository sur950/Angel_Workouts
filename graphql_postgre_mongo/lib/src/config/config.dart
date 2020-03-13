library first_a_p_i.src.config;

import 'package:angel_configuration/angel_configuration.dart';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_jael/angel_jael.dart';
import 'package:file/file.dart';
import 'plugins/plugins.dart' as plugins;

/// This is a perfect place to include configuration and load plug-ins.
AngelConfigurer configureServer(FileSystem fileSystem) {
  return (Angel app) async {
    // Load configuration from the `config/` directory.
    await app.configure(configuration(fileSystem));
    // Configure our application to render Jael templates from the `views/` directory.
    await app.configure(jael(fileSystem.directory('views')));
    // Configure plugins
    await plugins.configureServer(app);
    await plugins.configureServer1(app);
  };
}
