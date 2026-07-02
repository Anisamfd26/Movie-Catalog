# Movie Catalog Flutter Application

A production-ready Flutter movie catalog app with API integration, local storage, and offline support using modern architectural patterns.

## 🎯 Features

### Core Features
- ✅ **API Integration** - Dio HTTP client with logging
- ✅ **Local Storage** - Hive database for offline mode
- ✅ **Connectivity Detection** - Real-time internet monitoring
- ✅ **BLoC Architecture** - Clean, scalable state management
- ✅ **Offline Support** - Automatic fallback to cached data
- ✅ **Error Handling** - Graceful error states with retry
- ✅ **Search Functionality** - Search movies by title/genre
- ✅ **Favorites Management** - Persistent favorite tracking
- ✅ **Responsive UI** - Works on all screen sizes

### UI Features
- 📱 Movie catalog with beautiful card layout
- ⭐ Rating display with visual indicators
- 🎬 Movie details page with full information
- ❤️ Favorites page with quick access
- 🔄 Refresh button for manual data sync
- 🌐 Offline mode indicator badge
- ⏳ Loading states with spinners
- ⚠️ Error states with retry buttons
- 🔍 Search functionality

## 📋 Architecture

### Technology Stack

| Component | Technology | Version |
|-----------|-----------|---------|
| **State Management** | BLoC + Streams | 8.1.3 |
| **API Client** | Dio | 5.4.0 |
| **Local Storage** | Hive | 2.2.3 |
| **Connectivity** | connectivity_plus | 6.0.1 |
| **Dependency Injection** | Get It | 7.6.0 |
| **JSON Serialization** | json_serializable | 6.7.1 |

### Project Structure

```
lib/
├── main.dart                      # App entry point
├── service_locator.dart           # Dependency injection
├── model/
│   └── movie_model.dart           # Data model
├── bloc/
│   ├── movie_bloc.dart            # Main BLoC
│   ├── movie_event.dart           # Events
│   └── movie_state.dart           # States
├── page/
│   ├── movie_catalog_page.dart    # Home page
│   ├── movie_detail_page.dart     # Detail page
│   └── favorite_movies_page.dart  # Favorites page
└── service/
    ├── movie_service.dart         # API client
    ├── local_storage_service.dart # Storage
    └── connectivity_service.dart  # Network
```

## 🚀 Getting Started

### Prerequisites
- Flutter 3.12.0 or higher
- Dart 3.12.0 or higher
- Android SDK / Xcode for mobile platforms

### Installation

1. **Clone/Open Project**
```bash
cd flutter_application_1
```

2. **Get Dependencies**
```bash
flutter pub get
```

3. **Configure API** (IMPORTANT)
Edit `lib/service/movie_service.dart`:
```dart
static const String _baseUrl = 'https://your-api-endpoint.com';
```

4. **Run App**
```bash
flutter run
```

## 📚 Documentation

- [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md) - Detailed architecture & implementation
- [API_SETUP.md](API_SETUP.md) - API configuration & integration guide
- [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) - Upgrading from previous versions

## 🔧 Configuration

### API Endpoint

The app expects an API that returns movies in this format:

```json
{
  "movies": [
    {
      "id": "1",
      "title": "Movie Title",
      "releaseDate": "2024-01-01",
      "rating": "8.5",
      "genre": "Action, Adventure",
      "description": "Description...",
      "poster": "https://image-url.jpg"
    }
  ]
}
```

See [API_SETUP.md](API_SETUP.md) for complete endpoint documentation.

### Authentication

To add API authentication, modify `movie_service.dart`:

```dart
_dio.options.headers['Authorization'] = 'Bearer YOUR_TOKEN';
```

## 📱 Usage

### Basic Operations

```dart
// Load movies
bloc.loadMovies();

// Search
bloc.searchMovies('Inception');

// Get trending
bloc.getTrendingMovies();

// Toggle favorite
bloc.toggleFavorite(movieId);

// Refresh
bloc.refreshMovies();
```

### State Handling

```dart
StreamBuilder<MovieState>(
  stream: bloc.state,
  builder: (context, snapshot) {
    final state = snapshot.data;

    if (state is MoviesLoading) {
      return LoadingWidget();
    }
    if (state is MoviesError) {
      return ErrorWidget(state.message);
    }
    if (state is MoviesLoaded) {
      return MoviesList(state.movies);
    }
    
    return SizedBox();
  },
)
```

## 🌐 Offline Mode

The app supports seamless offline functionality:

1. **Online**: Fetches from API, caches locally
2. **Offline**: Automatically loads from cache
3. **UI Indicator**: Shows "Offline Mode" badge
4. **Search**: Works on cached data
5. **Favorites**: Persist locally

### Test Offline Mode

1. Load app normally (caches data)
2. Enable airplane mode
3. App shows cached data with offline badge
4. All features continue working
5. Disable airplane mode to sync with API

## 🧪 Testing

### Unit Testing
```bash
flutter test
```

### Integration Testing
```bash
flutter test integration_test/
```

### Manual Testing Checklist

- [ ] Load movies online
- [ ] Toggle airplane mode (offline)
- [ ] Verify data still loads
- [ ] Search in offline mode
- [ ] Toggle favorites
- [ ] Re-enable internet
- [ ] Refresh data
- [ ] Check error states

## 🔐 Security Best Practices

1. **API Keys**: Use environment variables
   ```bash
   export API_KEY=your_key
   ```

2. **HTTPS**: Always use HTTPS endpoints

3. **Token Management**: Implement token refresh
   ```dart
   _dio.interceptors.add(InterceptorsWrapper(
     onRequest: (options, handler) {
       // Add token to request
       return handler.next(options);
     },
   ));
   ```

4. **Local Storage**: Consider encryption for sensitive data
   ```dart
   // Hive supports encrypted boxes
   await Hive.openBox('movies', encryptionCipher: cipher);
   ```

## 📊 Performance Optimization

1. **Image Caching**: Built-in with `Image.network()`
2. **Data Pagination**: Add limit/offset to API
3. **Lazy Loading**: Only load visible items
4. **Memory Management**: Dispose streams properly
5. **Database Indexing**: Use Hive indexes for large datasets

## 🐛 Troubleshooting

### Common Issues

**Movies not loading?**
- ✓ Check API endpoint configuration
- ✓ Verify internet connection
- ✓ Check API response format
- ✓ Review console logs

**Offline mode not working?**
- ✓ Ensure app was opened online first
- ✓ Check Hive initialization
- ✓ Verify storage permissions

**Favorites not persisting?**
- ✓ Verify local storage initialization
- ✓ Check file system permissions
- ✓ Clear app cache and retry

## 🚀 Deployment

### Build Release APK

```bash
flutter build apk --release
```

### Build iOS

```bash
flutter build ios --release
```

### Build for Web

```bash
flutter build web --release
```

## 📈 Scalability

This architecture supports scaling:

- **Pagination**: Add page/limit to API calls
- **Filtering**: Extend search with filters
- **Sorting**: Add sort parameters
- **Categories**: Add category support
- **Ratings**: Add rating system
- **Comments**: Add user comments
- **Sharing**: Add social sharing

## 🛣️ Roadmap

- [ ] User authentication
- [ ] Watchlist feature
- [ ] Rating & reviews
- [ ] Social sharing
- [ ] Push notifications
- [ ] Advanced filtering
- [ ] Dark mode
- [ ] Multiple languages
- [ ] Analytics integration
- [ ] Performance monitoring

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing`)
5. Open Pull Request

## 📝 License

This project is licensed under the MIT License - see LICENSE file for details.

## 📧 Support

For support:
- 📖 Read [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md)
- 🔧 Check [API_SETUP.md](API_SETUP.md)
- 🚀 Follow [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)

## 🎓 Learning Resources

- [Flutter BLoC Pattern](https://bloclibrary.dev/)
- [Dio HTTP Client](https://pub.dev/packages/dio)
- [Hive Database](https://docs.hivedb.dev/)
- [Flutter Best Practices](https://flutter.dev/docs/testing/best-practices)

## ✨ Highlights

- 🏗️ **Clean Architecture** - Separated concerns, testable code
- 🔄 **Reactive** - Stream-based state management
- 🔌 **Pluggable** - Easy to swap implementations
- 📦 **Scalable** - Grows with your needs
- 🛡️ **Robust** - Error handling & fallbacks
- 🚀 **Performant** - Optimized for speed
- 📱 **Mobile-First** - Works on all platforms

---

**Created with ❤️ using Flutter**

Last Updated: 2024
Version: 2.0.0 (With API Integration & Offline Support)
