
import 'package:get_it/get_it.dart';
import 'package:unikids_uz/db/sqlite_helper.dart';
import 'package:unikids_uz/service/parents/parents_service.dart';
import 'package:unikids_uz/service/service.dart';

GetIt locator = GetIt.instance;

void locatorSetUp(){
  locator.registerSingleton(MyService());
  locator.registerSingleton(DatabaseHelper());
  locator.registerSingleton(ParentsService());
}