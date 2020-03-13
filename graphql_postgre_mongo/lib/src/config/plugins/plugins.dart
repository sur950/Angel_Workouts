library first_a_p_i.src.config.plugins;

// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'package:angel_auth/angel_auth.dart';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_mongo/services.dart';
import 'package:first_a_p_i/src/serializers/user.dart';
import 'package:mongo_dart/mongo_dart.dart';

Future configureServer(Angel app) async {
  var auth = AngelAuth(jwtKey: 'abcdefghijklmn', allowCookie: true);
  auth.serializer = (user) async => serializeUserToId(user);
  auth.deserializer = (id) async => deserializeUserFromId(id);

  auth.strategies['local'] = LocalAuthStrategy((username, password) async {
    return await findCorrespondingUser(username, password);
  });

  app.post('/auth/local', auth.authenticate('local'));

  // Apply angel_auth-specific configuration.
  await app.configure(auth.configureServer);
}

Future<User> deserializeUserFromId(id) async {
  if (id != '1234567890') {
    throw UnimplementedError();
  } else {
    return User(
      id: '1234567890',
      username: 'sur950',
      description: 'User name is suresh',
      password: 'Suresh950',
    );
  }
}

Future serializeUserToId(user) async {
  return '1234567890';
}

Future findCorrespondingUser(String name, String pass) async {
  if (name == 'sur950' && pass == 'Suresh950') {
    return User(
      id: '1234567890',
      username: name,
      description: 'User name is suresh',
      password: pass,
    );
  } else {
    throw AngelHttpException.notAuthenticated(message: 'Invalid credentials');
  }
}

Future configureServer1(Angel app) async {
  Db db = Db('mongodb://localhost:27017/local');
  await db.open();
  await db.collection('users').drop();
  await db.collection('users').insert({
    'name': 'ramesh',
    'status': true,
  });

  var service =
      await app.use('/api/users', MongoService(db.collection('users')));
  await service.afterCreated.listen((event) {
    print('New user: ${event.result}');
  });
}
