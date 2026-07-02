# Architecture & Data Flow Documentation

## 🏗️ System Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        UI Layer                             │
│  ┌────────────┐  ┌──────────────┐  ┌─────────────────┐    │
│  │  Catalog   │  │    Detail    │  │   Favorites     │    │
│  │   Page     │  │    Page      │  │     Page        │    │
│  └────────────┘  └──────────────┘  └─────────────────┘    │
└──────────────────────┬──────────────────────────────────────┘
                       │ StreamBuilder
┌──────────────────────▼──────────────────────────────────────┐
│                    Business Logic                           │
│              ┌────────────────────┐                         │
│              │   MovieBloc        │                         │
│              │  (Event Handler)   │                         │
│              └────────────────────┘                         │
└──┬──────────────────────┬──────────────────────┬───────────┘
   │                      │                      │
   ▼                      ▼                      ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐
│ MovieService │  │   LocalStore │  │ ConnectivityService  │
│   (Dio API)  │  │  (Hive DB)   │  │  (Network Monitor)   │
│              │  │              │  │                      │
├──────────────┤  ├──────────────┤  ├──────────────────────┤
│ • fetch      │  │ • saveMovies │  │ • hasInternet()      │
│ • search     │  │ • getMovies  │  │ • connectivityStream │
│ • trending   │  │ • favorites  │  │                      │
│ • logging    │  │ • persistence│  │                      │
└──────────────┘  └──────────────┘  └──────────────────────┘
```

## 📊 Data Flow Diagram

### When User Loads Movies (Online)

```
User Taps "Load Movies"
        │
        ▼
   [Load Event]
        │
        ▼
  MovieBloc checks: Is Internet?
        │
   ┌────┴────┐
   │ YES     │
   ▼         │
Call API ────┘
   │
   ├─► Success: Save to Hive Cache
   │
   └─► Failure: Load from Hive Cache
        │
        ▼
Emit MovieState.Loaded
        │
        ▼
UI updates with movies
```

### When User Loads Movies (Offline)

```
User Taps "Load Movies"
        │
        ▼
   [Load Event]
        │
        ▼
  MovieBloc checks: Is Internet?
        │
   ┌────┴────┐
   │ NO      │
   ▼         │
Load from Hive ─┘
   │
   ├─► Found: Emit MovieState.Loaded with flag
   │
   └─► Empty: Emit MovieState.Error
        │
        ▼
UI updates appropriately
```

### Toggle Favorite Flow

```
User Taps Heart Icon
        │
        ▼
   [ToggleFavorite Event]
        │
        ▼
 BLoC finds movie
        │
        ├─► isFavorite = true  ──► Remove from Hive
        │
        └─► isFavorite = false ──► Add to Hive
                │
                ▼
         Emit MovieState.Loaded
                │
                ▼
         UI updates heart icon
```

## 🔄 Event-State Flow

### Event Types

```
┌─────────────────────────────────────────┐
│          MovieEvent Types               │
├─────────────────────────────────────────┤
│ • LoadMovies                            │
│ • LoadMoviesFromApi                     │
│ • SearchMovies(query)                   │
│ • GetTrendingMovies                     │
│ • ToggleFavorite(movieId)               │
│ • RefreshMovies                         │
└─────────────────────────────────────────┘
```

### State Types

```
┌──────────────────────────────────────────────┐
│           MovieState Types                   │
├──────────────────────────────────────────────┤
│ • MoviesInitial                              │
│ • MoviesLoading                              │
│ • MoviesLoaded(movies, favorites, fromCache)│
│ • MoviesError(message)                       │
│ • SearchLoading                              │
│ • SearchResults(results, favorites)          │
└──────────────────────────────────────────────┘
```

## 🔌 Service Layer Architecture

### MovieService (API Integration)

```
MovieService
│
├─ Dio Instance
│  ├─ BaseURL: https://api.example.com
│  ├─ Timeout: 10s
│  └─ Interceptors
│     ├─ Request Logger
│     ├─ Response Logger
│     └─ Error Handler
│
└─ Methods
   ├─ fetchMovies() ──► GET /movies
   ├─ fetchMovieById(id) ──► GET /movies/{id}
   ├─ searchMovies(query) ──► GET /movies/search?q=query
   └─ getTrendingMovies() ──► GET /movies/trending
```

### LocalStorageService (Hive Integration)

```
LocalStorageService
│
├─ Movies Box
│  ├─ Key: movie.id
│  └─ Value: Map<String, dynamic>
│
├─ Favorites Box
│  ├─ Key: movieId
│  └─ Value: movieId (String)
│
└─ Methods
   ├─ saveMovies(List<Movie>)
   ├─ getMovies() ──► List<Movie>
   ├─ saveMovie(Movie)
   ├─ getMovieById(id) ──► Movie?
   ├─ addFavorite(id)
   ├─ removeFavorite(id)
   ├─ getFavorites() ──► List<String>
   ├─ isFavorite(id) ──► bool
   └─ clearAll()
```

### ConnectivityService (Network Detection)

```
ConnectivityService
│
├─ Connectivity Plugin
│
└─ Methods
   ├─ hasInternetConnection() ──► Future<bool>
   │  └─ Checks: WiFi || Mobile
   │
   └─ connectivityStream ──► Stream<bool>
      └─ Emits: true/false on changes
```

## 🚀 Request/Response Flow

### API Request Flow

```
BLoC Event
    │
    ▼
movieService.fetchMovies()
    │
    ▼
Dio HTTP Request
    │
    ├─► Interceptor: Log Request
    │
    ├─► Add Headers
    │
    ├─► Send Request
    │
    └─► Interceptor: Log Response
            │
            ├─► Success (200)
            │   ├─► Parse JSON
            │   ├─► Map to Movie objects
            │   ├─► Save to Local Storage
            │   └─► Return List<Movie>
            │
            └─► Error (4xx, 5xx, timeout)
                ├─► Catch Exception
                └─► Throw for BLoC handling
```

## 💾 Local Storage Schema

### Hive Boxes

```
📦 movies (Box<Map>)
├─ Key: "inception"
└─ Value: {
    "id": "inception",
    "title": "Inception",
    "releaseDate": "2010-07-15",
    "rating": "8.4",
    "genre": "Sci-Fi, Action",
    "description": "...",
    "poster": "https://...",
    "isFavorite": false
   }

📦 favorites (Box<String>)
├─ Key: "inception"
├─ Value: "inception"
├─ Key: "interstellar"
└─ Value: "interstellar"
```

## 🔀 Connectivity Transitions

```
ONLINE State
   │
   ├─ Load from API
   ├─ Cache results
   └─ Listen for disconnection
         │
         ▼
    OFFLINE Detected
         │
         ├─ Emit MoviesLoaded (isFromLocalStorage: true)
         ├─ Show "Offline Mode" badge
         └─ Listen for reconnection
              │
              ▼
         ONLINE Detected
              │
              ├─ Auto-refresh from API
              ├─ Update cache
              └─ Emit new state
```

## 🎯 State Management Flow

### Complete Lifecycle

```
App Start
   │
   ▼
Initialize Services (ServiceLocator)
   │
   ├─► MovieService (Dio)
   ├─► LocalStorageService (Hive init)
   └─► ConnectivityService
   │
   ▼
Create MovieBloc with Services
   │
   ├─► Load Initial Movies
   │   ├─► Check Internet
   │   ├─► Load from API or Cache
   │   ├─► Load Favorites
   │   └─► Emit MoviesLoaded
   │
   ├─► Listen for Events
   │   ├─► User Interaction
   │   ├─► Connectivity Changes
   │   └─► Update State
   │
   └─► Display UI
        ├─► StreamBuilder listens to State
        ├─► UI reflects current state
        └─► User can interact

User Interaction
   │
   ├─► Tap Favorite ──► ToggleFavorite Event
   ├─► Search ──────► SearchMovies Event
   ├─► Refresh ─────► RefreshMovies Event
   └─► Navigate ────► Load Details
```

## 📈 Performance Optimizations

```
Optimization Strategy
│
├─ Caching Layer
│  ├─ API responses cached in Hive
│  ├─ Favorites cached locally
│  └─ Images cached by Flutter
│
├─ Lazy Loading
│  ├─ Only load visible items
│  ├─ Pagination support
│  └─ Stream-based updates
│
├─ Connectivity Awareness
│  ├─ Skip API calls when offline
│  ├─ Pre-cache on online
│  └─ Batch updates
│
└─ Memory Management
   ├─ Dispose streams properly
   ├─ Close database boxes
   └─ Clear unused caches
```

## 🔐 Error Handling Flow

```
Operation Attempted
   │
   ├─► No Internet Connection
   │   └─► Use Local Storage
   │       ├─► Found ──► Load & Emit State
   │       └─► Empty ──► Emit Error State
   │
   ├─► API Request Fails
   │   └─► Fallback to Local Storage
   │       ├─► Found ──► Load & Emit State
   │       └─► Empty ──► Emit Error State
   │
   ├─► Local Storage Error
   │   └─► Emit Error State with message
   │
   └─► Timeout
       └─► Catch & Emit Error State
           └─► Offer Retry Option
```

## 🧩 Dependency Injection Flow

```
main.dart
   │
   ▼
setupServiceLocator()
   │
   ├─► MovieService()
   │   └─► GetIt.registerSingleton()
   │
   ├─► LocalStorageService()
   │   ├─► await Hive.initFlutter()
   │   ├─► await openBox('movies')
   │   ├─► await openBox('favorites')
   │   └─► GetIt.registerSingleton()
   │
   ├─► ConnectivityService()
   │   └─► GetIt.registerSingleton()
   │
   ▼
MovieBloc(
   movieService: getIt(),
   localStorageService: getIt(),
   connectivityService: getIt(),
)
```

## 📱 UI Layer Integration

```
StreamBuilder<MovieState>
   │
   ├─► MoviesLoading
   │   └─► Show Spinner
   │
   ├─► MoviesLoaded
   │   ├─► Check isFromLocalStorage
   │   ├─► Show Movies List
   │   ├─► Show "Offline" badge if needed
   │   └─► Enable all interactions
   │
   ├─► MoviesError
   │   ├─► Show Error Message
   │   ├─► Show Retry Button
   │   └─► Disable interactions
   │
   └─► SearchResults
       ├─► Show Search Results
       ├─► Show Result Count
       └─► Enable result interactions
```

---

This architecture provides:
- 🔄 Reactive state management
- 🔌 Pluggable services
- 🛡️ Robust error handling
- 🚀 Performance optimization
- 📱 Responsive UI
- 🔐 Security considerations
