# Migration Guide - From Basic to Full-Featured Movie Catalog

## What Changed

This document guides you through the changes from the basic Movie Catalog to the new version with API integration and local storage.

## Breaking Changes

### 1. BLoC Initialization
**Before**:
```dart
_bloc = MovieBloc();
```

**After**:
```dart
_bloc = MovieBloc(
  movieService: getIt(),
  localStorageService: getIt(),
  connectivityService: getIt(),
);
```

The BLoC now requires service dependencies. These are automatically initialized in `main.dart` using the service locator pattern.

### 2. Main.dart Setup
**Before**:
```dart
void main() {
  runApp(const MyApp());
}
```

**After**:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const MyApp());
}
```

The app now requires async initialization for services, particularly Hive local storage.

### 3. State Handling
**Before**:
```dart
if (movies.isEmpty) {
  return _buildEmptyState();
}
```

**After**:
```dart
if (state is MoviesLoading) {
  return _buildLoadingState();
}
if (state is MoviesError) {
  return _buildErrorState(context, state.message);
}
if (state is MoviesLoaded) {
  // ... handle loaded state
}
```

You must now handle additional states: Loading, Error, and potentially Error states.

## New Features Available

### 1. API Integration
```dart
// Automatically handled by BLoC
bloc.loadMoviesFromApi();      // Force API load
bloc.searchMovies('query');    // Search movies
bloc.getTrendingMovies();      // Get trending
bloc.refreshMovies();          // Refresh data
```

### 2. Offline Mode
The app automatically:
- Detects internet connectivity
- Falls back to local storage when offline
- Shows "Offline Mode" indicator
- Loads from cache if API fails

### 3. Favorites Persistence
Favorites are now persisted locally:
```dart
bloc.toggleFavorite(movieId);  // Saves to local storage
```

## File Changes

### New Files
- `lib/service/movie_service.dart` - API client
- `lib/service/local_storage_service.dart` - Hive storage
- `lib/service/connectivity_service.dart` - Network detection
- `lib/service_locator.dart` - Dependency injection
- `IMPLEMENTATION_GUIDE.md` - Detailed documentation
- `API_SETUP.md` - API configuration guide

### Modified Files
- `lib/main.dart` - Added service initialization
- `lib/bloc/movie_bloc.dart` - Refactored with services
- `lib/bloc/movie_event.dart` - Added new events
- `lib/bloc/movie_state.dart` - Added new states
- `lib/model/movie_model.dart` - Added JSON methods
- `lib/page/movie_catalog_page.dart` - Updated state handling
- `lib/page/favorite_movies_page.dart` - Updated state handling
- `pubspec.yaml` - Added dependencies

### Unchanged Files
- `lib/page/movie_detail_page.dart` - Works as-is

## Dependency Tree

```
New Dependencies:
├── dio (^5.4.0) - HTTP client
├── hive (^2.2.3) - Local storage
├── hive_flutter (^1.1.0) - Flutter integration
├── connectivity_plus (^6.0.1) - Network detection
├── get_it (^7.6.0) - Dependency injection
├── json_serializable (^6.7.1) - JSON tools
├── json_annotation (^4.8.1) - JSON annotations
├── build_runner (^2.4.6) - Code generation
└── hive_generator (^2.0.1) - Hive code generation
```

## Migration Steps

### Step 1: Update Dependencies
```bash
flutter pub get
```

### Step 2: Replace BLoC Initialization
Update `main.dart` to:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const MyApp());
}
```

### Step 3: Update MovieBloc Creation
Replace BLoC instantiation with:
```dart
_bloc = MovieBloc(
  movieService: getIt(),
  localStorageService: getIt(),
  connectivityService: getIt(),
);
```

### Step 4: Configure API
Edit `lib/service/movie_service.dart`:
```dart
static const String _baseUrl = 'your-api-url';
```

### Step 5: Update UI State Handling
Add handling for new states in your pages:
- Check for `MoviesLoading`
- Check for `MoviesError`
- Check for `isFromLocalStorage` flag in `MoviesLoaded`

### Step 6: Test
1. Run app online - should fetch from API
2. Toggle airplane mode - should use local storage
3. Click refresh - should re-fetch from API
4. Test favorites - should persist

## Backward Compatibility

### Data Migration
Old in-memory movies are **NOT** automatically migrated. The app will:
1. Try to fetch from API on first run
2. Cache the results locally
3. Fall back to local cache when offline

### Favorites Migration
If you had in-memory favorites:
1. They are **NOT** migrated
2. Users must re-select favorites
3. New favorites are saved to local storage

To preserve old favorites, you could:
```dart
// In service_locator.dart setupServiceLocator()
final favorites = [/* old favorite IDs */];
for (var id in favorites) {
  await localStorageService.addFavorite(id);
}
```

## Testing Checklist

- [ ] App starts without errors
- [ ] Dependencies are resolved
- [ ] Pages load with UI states
- [ ] Movies load from API
- [ ] Offline mode works (airplane mode toggle)
- [ ] Favorites persist
- [ ] Search functionality works
- [ ] Refresh button fetches new data
- [ ] Error states show properly
- [ ] Loading states show spinners

## Troubleshooting

### Issue: "MovieBloc constructor error"
**Solution**: Ensure main.dart calls `setupServiceLocator()` before creating BLoC.

### Issue: "Hive not initialized"
**Solution**: Verify `await setupServiceLocator()` in main.dart.

### Issue: "Movies not loading"
**Solution**: 
1. Check API endpoint configuration
2. Verify network connectivity
3. Check local storage has cached data

### Issue: "Compilation error"
**Solution**: Run `flutter pub get` and rebuild.

## Performance Considerations

1. **First Run**: App will fetch from API (slower)
2. **Subsequent Runs**: Loads from cache (faster)
3. **Large Datasets**: Consider adding pagination
4. **Image Caching**: Built into Flutter's Image.network
5. **Local Storage**: Hive is very efficient

## Security Considerations

1. **API Keys**: Store in environment variables or secure storage
2. **Tokens**: Implement token refresh in interceptors
3. **HTTPS**: Always use HTTPS for API endpoints
4. **Local Storage**: Hive files are readable (consider encryption)

## Next Steps

1. Configure your API endpoint
2. Test with sample data
3. Implement authentication if needed
4. Add pagination for large datasets
5. Customize UI styling
6. Add analytics tracking
7. Implement push notifications

## Support

For issues:
- Check `IMPLEMENTATION_GUIDE.md` for architecture details
- Check `API_SETUP.md` for API configuration
- Review console logs for error messages
- Test with connectivity toggles
