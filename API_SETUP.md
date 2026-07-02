# Quick Start Guide - API Configuration

## Step 1: Update API Endpoint

Edit **lib/service/movie_service.dart** (line ~8):

```dart
static const String _baseUrl = 'https://your-api-endpoint.com';
```

Replace with your actual API base URL.

## Step 2: Expected API Response Format

Your API should return data in this format:

### Get All Movies
**Endpoint**: `GET /movies`
```json
{
  "movies": [
    {
      "id": "movie-id",
      "title": "Movie Title",
      "releaseDate": "2024-01-01",
      "rating": "8.5",
      "genre": "Action, Adventure",
      "description": "Movie description...",
      "poster": "https://image-url.jpg"
    }
  ]
}
```

### Get Single Movie
**Endpoint**: `GET /movies/{id}`
```json
{
  "id": "movie-id",
  "title": "Movie Title",
  "releaseDate": "2024-01-01",
  "rating": "8.5",
  "genre": "Action, Adventure",
  "description": "Movie description...",
  "poster": "https://image-url.jpg"
}
```

### Search Movies
**Endpoint**: `GET /movies/search?q=query`
```json
{
  "movies": [...]
}
```

### Get Trending Movies
**Endpoint**: `GET /movies/trending`
```json
{
  "movies": [...]
}
```

## Step 3: Get Dependencies

```bash
flutter pub get
```

## Step 4: Run the App

```bash
flutter run
```

## Step 5: Test Features

### Online Mode
- App fetches from API
- Data is cached locally
- Shows data from API with timestamp

### Offline Mode
1. Enable airplane mode
2. App automatically loads from cache
3. Shows "Offline Mode" badge
4. All features work (search cached data, toggle favorites)

### Switching Modes
- Disable airplane mode
- Click refresh button
- App re-fetches from API

## Available Public Movie APIs

If you need a test API, try one of these:

1. **TMDB API** (Popular)
   - Website: https://www.themoviedb.org/settings/api
   - Requires: API Key registration
   - Endpoint: https://api.themoviedb.org/3/

2. **OMDb API**
   - Website: http://www.omdbapi.com/
   - Requires: API Key
   - Free tier: Limited requests/day

3. **Open Movie Database**
   - Website: https://rapidapi.com/SAdrian/api/open-movie-database
   - Via RapidAPI

## Customization Tips

### Change Timeout
In `movie_service.dart`:
```dart
connectTimeout: const Duration(seconds: 10),
receiveTimeout: const Duration(seconds: 10),
```

### Add Headers
In `movie_service.dart` constructor:
```dart
_dio.options.headers['Authorization'] = 'Bearer your-token';
_dio.options.headers['Accept'] = 'application/json';
```

### Add Query Parameters
In service methods:
```dart
final response = await _dio.get(
  '/movies',
  queryParameters: {
    'key': 'value',
    'page': 1,
    'limit': 20,
  },
);
```

## Debugging

### Enable Verbose Logging
The app logs all requests/responses. Check logcat:
```
flutter logs
```

### Check Local Storage
Local storage is managed by Hive. To clear:
```dart
await localStorageService.clearAll();
```

### Monitor Connectivity
Check if connectivity detection is working by looking at console output for "Internet connection" messages.

## Common Issues

### Q: Movies not loading
**A**: 
- Check API endpoint URL
- Verify internet connection
- Check if API returns expected format
- Look at console logs for error details

### Q: Local storage empty when offline
**A**: 
- Must load online first to cache data
- Check Hive initialization in main.dart
- Ensure app has file system permissions

### Q: Favorites not saving
**A**: 
- Verify local storage permissions
- Check if toggleFavorite() is called
- Clear app cache and try again

### Q: Search not working
**A**: 
- If online, check API search endpoint
- If offline, app searches cached local data
- Verify search query format

## Next Steps

1. ✅ Update API endpoint
2. ✅ Test with sample API
3. ✅ Configure authentication if needed
4. ✅ Add additional endpoints as required
5. ✅ Implement pagination
6. ✅ Add data filtering
7. ✅ Customize UI as needed

## Support

For issues or improvements:
- Check console logs for error messages
- Verify API response format matches expected structure
- Ensure all services are initialized in main.dart
- Test connectivity with airplane mode toggle
