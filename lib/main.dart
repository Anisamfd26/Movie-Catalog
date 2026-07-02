import 'package:flutter/material.dart';
import 'bloc/movie_bloc.dart';
import 'page/movie_catalog_page.dart';
import 'service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize services
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final MovieBloc _bloc;

  @override
  void initState() {
    super.initState();
    // Initialize BLoC with services from service locator
    _bloc = MovieBloc(
      movieService: getIt(),
      localStorageService: getIt(),
      connectivityService: getIt(),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Catalog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: MovieCatalogPage(bloc: _bloc),
    );
  }
}
