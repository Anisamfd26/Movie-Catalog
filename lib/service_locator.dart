import 'package:get_it/get_it.dart';
import 'service/movie_service.dart';
import 'service/local_storage_service.dart';
import 'service/connectivity_service.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Register services
  getIt.registerSingleton<MovieService>(MovieService());
  
  final localStorageService = LocalStorageService();
  await localStorageService.init();
  getIt.registerSingleton<LocalStorageService>(localStorageService);
  
  getIt.registerSingleton<ConnectivityService>(ConnectivityService());
}
