import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List popularMovies = [];
  List nowPlayingMovies = [];
  List comingSoonMovies = [];

  @override
  void initState() {
    super.initState();
    getPopularMovies();
    getNowPlayingMovies();
    getComingSoonMovies();
  }

  void getPopularMovies() async {
    var response = await http
        .get(Uri.parse('https://movies-api.nomadcoders.workers.dev/popular'));
    if (response.statusCode == 200) {
      setState(() {
        popularMovies = jsonDecode(response.body)['results'];
      });
    }
  }

  void getNowPlayingMovies() async {
    var response = await http.get(
        Uri.parse('https://movies-api.nomadcoders.workers.dev/now-playing'));
    if (response.statusCode == 200) {
      setState(() {
        nowPlayingMovies = jsonDecode(response.body)['results'];
      });
    }
  }

  void getComingSoonMovies() async {
    var response = await http.get(
        Uri.parse('https://movies-api.nomadcoders.workers.dev/coming-soon'));
    if (response.statusCode == 200) {
      setState(() {
        comingSoonMovies = jsonDecode(response.body)['results'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Popular Movies',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: popularMovies.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                              movieId: nowPlayingMovies[index]['id']),
                        ),
                      ),
                      child: SizedBox(
                        width: 285,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(8), // 테두리 둥글게
                                  child: Image.network(
                                    'https://image.tmdb.org/t/p/w500/${popularMovies[index]['poster_path']}',
                                    height: 200,
                                    width: 280,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Now in Cinemas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: nowPlayingMovies.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                              movieId: nowPlayingMovies[index]['id']),
                        ),
                      ),
                      child: SizedBox(
                        width: 130,
                        height: 130,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    'https://image.tmdb.org/t/p/w500/${nowPlayingMovies[index]['poster_path']}',
                                    height: 130,
                                    width: 130,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  nowPlayingMovies[index]['title'],
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Coming Soon',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: comingSoonMovies.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                              movieId: comingSoonMovies[index]['id']),
                        ),
                      ),
                      child: SizedBox(
                        width: 130,
                        height: 130,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  'https://image.tmdb.org/t/p/w500/${comingSoonMovies[index]['poster_path']}',
                                  height: 130,
                                  width: 130,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                nowPlayingMovies[index]['title'],
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DetailScreen extends StatefulWidget {
  final int movieId;

  const DetailScreen({super.key, required this.movieId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Map movieDetails = {};

  @override
  void initState() {
    super.initState();
    getMovieDetails();
  }

  void getMovieDetails() async {
    var response = await http.get(Uri.parse(
        'https://movies-api.nomadcoders.workers.dev/movie?id=${widget.movieId}'));
    if (response.statusCode == 200) {
      setState(() {
        movieDetails = jsonDecode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Image.network(
            'https://image.tmdb.org/t/p/w500/${movieDetails['poster_path']}',
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              print(error); // 예외 메시지 출력
              return Text('Error loading image');
            },
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (movieDetails.containsKey('title') &&
                    movieDetails['title'] != null)
                  Text(
                    movieDetails['title'],
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                const SizedBox(height: 8),
                Text('Rating: ${movieDetails['vote_average']}'),
                const SizedBox(height: 8),
                const Text('Overview'),
                const SizedBox(height: 8),
                if (movieDetails.containsKey('overview') &&
                    movieDetails['overview'] != null)
                  Text(
                    movieDetails['overview'],
                    style: const TextStyle(
                        fontSize: 8, fontWeight: FontWeight.bold),
                  ),
                const SizedBox(height: 8),
                const Text('Genres'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: movieDetails['genres'] != null
                      ? List.generate(
                          (movieDetails['genres'] as List).length,
                          (index) => Chip(
                            label: Text((movieDetails['genres'] as List)[index]
                                ['name']),
                          ),
                        )
                      : [],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
