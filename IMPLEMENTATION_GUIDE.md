# Movie Catalog - API Integration & Local Storage Implementation

## Overview
This project implements a complete API integration with local storage fallback using popular Flutter packages while maintaining the BLoC architecture pattern.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     MovieCatalogApp                         │
└─────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────┼───────────────┐
              │               │               │
        ┌─────▼──────┐  ┌────▼──────┐  ┌────▼─────┐
        │  Movie UI  │  │Movie Detail│  │ Favorites│
        │   Pages    │  │   Pages    │  │  Pages   │
        └─────┬──────┘  └────┬──────┘  └────┬─────┘
              │               │               │
              └───────────────┼───────────────┘
                              │
                      ┌───────▼────────┐
                      │   MovieBloc    │
                      └───────┬────────┘
                              │
              ┌───────────────┼───────────────┐
              │               │               │
        ┌────▼──────┐   ┌────▼──────┐  ┌────▼────────┐
        │API Service│   │   Local    │  │Connectivity│
        │  (Dio)    │   │  Storage   │  │  Service   │
        │           │   │  (Hive)    │  │            │
        └───────────┘   └────────────┘  └────────────┘
```

## Technologies Used

### 1. **API Integration - Dio**
- **Package**: `dio: ^5.4.0`
- **Location**: [lib/service/movie_service.dart](lib/service/movie_service.dart)
- **Features**:
  - HTTP client with timeout configuration
  - Request/Response logging via interceptors
  - Error handling
  - Multiple endpoints (fetch, search, trending)

### 2. **Local Storage - Hive**
- **Packages**: 
  - `hive: ^2.2.3`
  - `hive_flutter: ^1.1.0`
  - `hive_generator: ^2.0.1` (dev dependency)
- **Location**: [lib/service/local_storage_service.dart](lib/service/local_storage_service.dart)
- **Features**:
  - Fast, efficient local storage
  - Supports movies and favorites
  - Fallback storage when API is unavailable
  - Easy clear/reset functionality

### 3. **Connectivity Detection - Connectivity Plus**
- **Package**: `connectivity_plus: ^6.0.1`
- **Location**: [lib/service/connectivity_service.dart](lib/service/connectivity_service.dart)
- **Features**:
  - Real-time connectivity status monitoring
  - Supports WiFi and Mobile connections
  - Stream-based connectivity changes

### 4. **Dependency Injection - Get It**
- **Package**: `get_it: ^7.6.0`
- **Location**: [lib/service_locator.dart](lib/service_locator.dart)
- **Features**:
  - Centralized service initialization
  - Singleton pattern for services
  - Easy access via `getIt()` function

### 5. **JSON Serialization**
- **Packages**: 
  - `json_annotation: ^4.8.1`
  - `json_serializable: ^6.7.1` (dev dependency)
  - `build_runner: ^2.4.6` (dev dependency)
- **Implementation**: Manual JSON methods in Movie model for simplicity

## Key Components

### Movie Model
[lib/model/movie_model.dart](lib/model/movie_model.dart)
- Enhanced with `toJson()` and `fromJson()` methods
- Supports serialization to/from local storage
- Maintains favorite status

### BLoC Architecture
[lib/bloc/movie_bloc.dart](lib/bloc/movie_bloc.dart)

**Events**:
- `LoadMovies` - Initial load
- `LoadMoviesFromApi` - Force API load
- `SearchMovies` - Search functionality
- `GetTrendingMovies` - Get trending movies
- `ToggleFavorite` - Toggle favorite status
- `RefreshMovies` - Refresh from API

**States**:
- `MoviesInitial` - Initial state
- `MoviesLoading` - Loading data
- `MoviesLoaded` - Successfully loaded with `isFromLocalStorage` flag
- `MoviesError` - Error state with message
- `SearchLoading` - Search in progress
- `SearchResults` - Search results loaded

### Smart Fallback Logic
The BLoC implements intelligent fallback:

```dart
// Try API first if connected
if (hasInternet) {
  try {
    movies = await movieService.fetchMovies();
    // Save to local storage for offline use
    await localStorageService.saveMovies(movies);
  } catch (e) {
    // Fallback to local storage on API error
    await loadMoviesFromStorage();
  }
} else {
  // Use local storage if no internet
  await loadMoviesFromStorage();
}
```

## File Structure

```
lib/
├── main.dart                          # App entry point with service initialization
├── service_locator.dart              # Dependency injection setup
├── model/
│   └── movie_model.dart              # Movie model with JSON serialization
├── bloc/
│   ├── movie_bloc.dart               # Main BLoC with API & storage logic
│   ├── movie_event.dart              # Event definitions
│   └── movie_state.dart              # State definitions
├── page/
│   ├── movie_catalog_page.dart       # Home page with loading/error states
│   ├── movie_detail_page.dart        # Detail page
│   └── favorite_movies_page.dart     # Favorites page
└── service/
    ├── movie_service.dart            # Dio API client
    ├── local_storage_service.dart    # Hive local storage
    └── connectivity_service.dart     # Network connectivity
```

## Setup Instructions

### 1. Get Dependencies
```bash
flutter pub get
```

### 2. Run Code Generator (Optional, for JSON serialization)
```bash
flutter pub run build_runner build
```

### 3. Configure API Endpoint
Edit [lib/service/movie_service.dart](lib/service/movie_service.dart):
```dart
static const String _baseUrl = 'https://your-api-endpoint.com';
```

### 4. Run the App
```bash
flutter run
```

## API Integration Points

### Available Methods in MovieService
- `fetchMovies()` - Get all movies
- `fetchMovieById(id)` - Get specific movie
- `searchMovies(query)` - Search movies
- `getTrendingMovies()` - Get trending movies

### Local Storage Methods
- `saveMovies(movies)` - Save movie list
- `getMovies()` - Retrieve all movies
- `addFavorite(movieId)` - Add to favorites
- `getFavorites()` - Get favorite IDs
- `isFavorite(movieId)` - Check if favorite

## Features

### ✅ API Integration
- HTTP client with timeout handling
- Error handling and logging
- Multiple endpoints support
- Request/response interceptors

### ✅ Local Storage Fallback
- Automatically caches API responses
- Loads from cache when offline
- Persistent favorites
- Easy data management

### ✅ Connectivity Awareness
- Real-time internet detection
- Graceful degradation
- UI indicator for offline mode
- Automatic retry on reconnect

### ✅ BLoC Pattern
- Clean separation of concerns
- Event-driven architecture
- State management
- Easy testing

### ✅ User Experience
- Loading states with spinners
- Error states with retry buttons
- Offline mode indicator
- Refresh functionality
- Search capabilities

## Error Handling

The app handles various error scenarios:
1. **No Internet**: Loads from local storage
2. **API Error**: Falls back to cached data
3. **Empty Storage**: Shows appropriate message
4. **Network Timeout**: Shows error with retry button

## Usage Example

```dart
// In any page using the BLoC
class MyPage extends StatelessWidget {
  final MovieBloc bloc;

  void loadMovies() {
    bloc.loadMovies(); // Or loadMoviesFromApi()
  }

  void search(String query) {
    bloc.searchMovies(query);
  }

  void toggleFav(String id) {
    bloc.toggleFavorite(id);
  }
}
```

## Best Practices Implemented

1. **Service Locator Pattern** - Centralized dependency management
2. **Repository Pattern** - Service layer abstraction
3. **Stream-based State** - Reactive state management
4. **Error Handling** - Comprehensive error scenarios
5. **Logging** - Request/response logging for debugging
6. **Caching Strategy** - Intelligent cache management
7. **Offline-First** - Local storage as primary fallback
8. **Connectivity Awareness** - Network status detection

## Testing

To test offline functionality:
1. Start the app in online mode (API data gets cached)
2. Enable airplane mode
3. App will automatically load from local storage
4. Disable airplane mode to re-enable API access

## Future Enhancements

- [ ] Add pagination for large datasets
- [ ] Implement database sync queue
- [ ] Add image caching
- [ ] Implement push notifications
- [ ] Add offline search functionality
- [ ] Implement data refresh strategies
- [ ] Add analytics tracking
- [ ] Implement rate limiting

## Troubleshooting

### Movies not loading
- Check API endpoint configuration
- Verify internet connection
- Check local storage has cached data

### Favorites not persisting
- Ensure Hive initialization completes
- Check file system permissions
- Verify local storage service initialization

### Connectivity detection not working
- Grant internet permission in manifest
- Check platform-specific settings
- Verify connectivity_plus initialization

## License
This implementation demonstrates best practices in Flutter development with modern architecture patterns.
