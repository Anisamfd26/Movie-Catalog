import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Catalog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const MovieCatalogPage(),
    );
  }
}

class MovieCatalogPage extends StatelessWidget {
  const MovieCatalogPage({super.key});

  final List<Map<String, String>> dataFilm = const [
    {
      'judul': 'Inception',
      'tanggal': '2010-07-15',
      'rating': '8.4',
      'poster': 'https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_FMjpg_UX1000_.jpg',
    },
    {
      'judul': 'Interstellar',
      'tanggal': '2014-11-07',
      'rating': '8.6',
      'poster': 'https://m.media-amazon.com/images/I/514zBLkyJcL._AC_UF894,1000_QL80_.jpg',
    },
    {
      'judul': 'Tenet',
      'tanggal': '2020-08-22',
      'rating': '7.3',
      'poster': 'https://m.media-amazon.com/images/I/71W2aEcrxxL._AC_UF894,1000_QL80_.jpg',
    },
    {
      'judul': 'The Dark Knight Rises',
      'tanggal': '2012-07-16',
      'rating': '7.8',
      'poster': 'https://m.media-amazon.com/images/I/5151N2hUPiL._AC_UF894,1000_QL80_.jpg',
    },
    {
      'judul': 'Avatar: The Way of Water',
      'tanggal': '2022-12-14',
      'rating': '7.6',
      'poster': 'https://m.media-amazon.com/images/I/71Lvqoov42L.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Movie Catalog',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey.withValues(alpha: 0.2),
            height: 1.0,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        itemCount: dataFilm.length,
        itemBuilder: (context, index) {
          final film = dataFilm[index];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SISI KIRI: POSTER FILM
                Container(
                  width: 80,
                  height: 110,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      film['poster']!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.broken_image, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                
                // Desc Movie
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        film['judul']!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        film['tanggal']!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            film['rating']!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}