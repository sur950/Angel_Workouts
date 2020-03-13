library first_a_p_i.src.routes;

import 'package:angel_framework/angel_framework.dart';
import 'package:angel_static/angel_static.dart';
import 'package:file/file.dart';
import 'controllers/controllers.dart' as controllers;

/// Put your app routes here!
///
AngelConfigurer configureServer(FileSystem fileSystem) {
  return (Angel app) async {
    // Typically, you want to mount controllers first, after any global middleware.
    await app.configure(controllers.configureServer);

    // Render `views/hello.jl` when a user visits the application root.
    app.get('/', (req, res) => res.render('hello'));
    app.get('/first', (req, res) => res.render('first'));
    app.get('/second', (req, res) => res.render('second'));

    // Write directly in webPage instead of using views.
    app.get('/headers', (req, res) {
      req.headers.forEach((key, values) {
        res.write('$key=$values');
        res.writeln();
      });
    });

    app.post('/greet', (req, res) async {
      await req.parseBody();
      var name = req.bodyAsMap['name'] as String;

      if (name == null) {
        throw AngelHttpException.badRequest(message: 'Missing name.');
        // error handling and all errors are wrapped in the 'AngelHttpException' class
      } else {
        // await res.render('greet', {'body': 'Hello $name'});
        var obj = {
          'message': 'Successfully, $name',
          'status': true,
          'body': [],
        };
        res.json(obj);
      }
    });

    app.put('/putValue', (req, res) async {
      await req.parseBody();
      var value = req.bodyAsMap['putVal'] as String;
      var name = req.queryParameters['name'] as String;

      if (name == null) {
        throw AngelHttpException.badRequest(message: 'Missing name.');
      } else if (value == null) {
        throw AngelHttpException.badRequest(
          message: 'Missing value.',
          errors: ['putVal param is missing in the body.'],
        );
      } else {
        var obj = {
          'message': 'Successfully',
          'status': true,
          'body': [],
        };
        res.json(obj);
      }
    });

    // Mount static server at web in development.
    // The `CachingVirtualDirectory` variant of `VirtualDirectory` also sends `Cache-Control` headers.
    //
    // In production, however, prefer serving static files through NGINX or a
    // similar reverse proxy.
    if (!app.environment.isProduction) {
      var vDir = VirtualDirectory(
        app,
        fileSystem,
        source: fileSystem.directory('web'),
      );
      app.fallback(vDir.handleRequest);
    }

    // Throw a 404 if no route matched the request.
    app.fallback((req, res) => throw AngelHttpException.notFound());

    var oldErrorHandler = app.errorHandler;
    app.errorHandler = (e, req, res) async {
      if (req.accepts('text/html', strict: true)) {
        if (e.statusCode == 404 && req.accepts('text/html', strict: true)) {
          await res
              .render('error', {'message': 'No file exists at ${req.uri}.'});
        } else {
          await res.render('error', {'message': e.message});
        }
      } else {
        return await oldErrorHandler(e, req, res);
      }
    };
  };
}
