import 'package:chat_app/app/modules/auth/repository/auth_repository.dart';
import 'package:chat_app/app/data/services/auth/auth_service.dart';
import 'package:chat_app/app/data/services/internet/internet_service.dart';
import 'package:chat_app/app/data/services/local_db/storage_service.dart';
import 'package:chat_app/app/data/services/network_db/api_service.dart';
import 'package:get/get.dart';

Future<void> initServices() async {
  Get.put(CheckInternetService(), permanent: true);
  await Get.putAsync<StorageService>(() async => StorageService().init(), permanent: true);
  Get.put(ApiService(), permanent: true);
  Get.put(AuthRepository(), permanent: true);
  Get.put(AuthService(), permanent: true);
}
