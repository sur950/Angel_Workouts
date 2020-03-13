import 'package:angel_framework/angel_framework.dart';
import 'package:angel_framework/http.dart';

main() async {
  var app = Angel();
  var http = AngelHttp(app);

  // get root method
  app.get('/', (req, res) => res.write('Hello, world!'));
  app.get(r'/number/:num([0-9]+(\.[0-9])?)',
      (req, res) => res.write('Hey, RegExp. Example'));

  /// get the headers and command is
  ///
  /// curl -H 'X-Foo: bar' -H 'Accept-Language: en-US' \
  /// http://localhost:3000/headers && echo
  ///
  app.get('/headers', (req, res) {
    req.headers.forEach((key, values) {
      res.write('$key=$values');
      res.writeln();
    });
  });

  /// post to /greet and command is
  ///
  /// curl -X POST -d 'name=Bob' localhost:3000/greet && echo
  ///
  app.post('/greet', (req, res) async {
    await req.parseBody();

    var name = req.bodyAsMap['name'] as String;

    if (name == null) {
      throw AngelHttpException.badRequest(message: 'Missing name.');
      // error handling and all errors are wrapped in the 'AngelHttpException' class
    } else {
      res.write('Hello, $name!');
    }
  });

  /// Error handler is as follows
  ///
  var oldErrorHandler = app.errorHandler;

  app.errorHandler = (e, req, res) {
    if (e.statusCode == 400) {
      res.write('Oops! You forgot to include your name.');
    } else {
      return oldErrorHandler(e, req, res);
    }
  };

  await http.startServer('localhost', 3000);
}
