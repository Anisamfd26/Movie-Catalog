import 'package:get_it/get_it.dart';
import 'service/i_movie_service.dart';
import 'service/movie_service.dart';
import 'service/mock_movie_service.dart';
import 'service/local_storage_service.dart';
import 'service/connectivity_service.dart';

final getIt = GetIt.instance;

// Set ini ke false jika ingin menggunakan API asli
const bool USE_MOCK_DATA = true;

Future<void> setupServiceLocator() async {
  // Register services
  if (USE_MOCK_DATA) {
    // Gunakan mock service untuk development/testing
    print('🧪 Using MOCK data');
    getIt.registerSingleton<IMovieService>(MockMovieService());
  } else {
    // Gunakan real API service
    print('🌐 Using REAL API');
    getIt.registerSingleton<IMovieService>(MovieService());
  }

  final localStorageService = LocalStorageService();
  await localStorageService.init();
  getIt.registerSingleton<LocalStorageService>(localStorageService);

  getIt.registerSingleton<ConnectivityService>(ConnectivityService());
}
