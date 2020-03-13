import 'dart:async';
import 'dart:io';
import 'package:angel_orm_postgres/angel_orm_postgres.dart';
import 'package:postgres/postgres.dart';

final conn = PostgreSQLConnection('localhost', 5432, 'postgres',
    username: Platform.environment['POSTGRES_USERNAME'] ?? 'sureshkonakanchi',
    password: Platform.environment['POSTGRES_PASSWORD'] ?? '');

Future<PostgreSqlExecutor> connect() async {
  var executor = PostgreSqlExecutor(conn);
  await conn.open();
  return executor;
}
