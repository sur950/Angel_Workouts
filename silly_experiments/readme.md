## Step-1
    Create a folder and add `pubspec.yaml`
## Step-2
    Add the following in .yaml file
    ```
    name: project_name
    dependencies:
        angel_framework: ^2.0.0
    ```
## Step-3
    Run `pub get` in the project folder -- This will install angel_framework library and it's dependencies.
## Step-4
    Create a `bin` folder and add `main.dart` inside bin and
    add the following to bin/main.dart:
    ```
    import 'package:angel_framework/angel_framework.dart';
    import 'package:angel_framework/http.dart';

    main() async {
        var app = Angel();
        var http = AngelHttp(app);
        await http.startServer('localhost', 3000);
    }
    ```
## Step-5
    Running project: `dart bin/main.dart`
    Abive line will listen to port.
    Actual run: `curl localhost:3000 && echo`

# Use the following link for more details:
https://docs.angel-dart.dev/v/2.x/guides/getting-started
https://github.com/angel-dart/route
