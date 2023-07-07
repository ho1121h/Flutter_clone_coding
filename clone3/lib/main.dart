import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

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
        // print("getMovieDetails!!!");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Back to list"),
      //   backgroundColor: Colors.transparent,
      // ),
      body: Stack(
        children: [
          Image.network(
            'https://image.tmdb.org/t/p/w500/${movieDetails['poster_path']}',
            fit: BoxFit.cover,
            height: 1111,
          ),
          Positioned(
            top: 60,
            left: 0,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                elevation: MaterialStateProperty.all(0),
              ),
              child: Row(
                children: [
                  Text(
                    '< ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(' Back to list'),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 50, // 화면의 최하단에 위치
            left: 50,
            right: 50,
            child: SizedBox(
              width: 100, // 버튼의 너비
              height: 50, // 버튼의 높이
              child: ElevatedButton(
                onPressed: () {
                  // 티켓 구매 로직
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.yellow),
                ),
                child: Text(
                  'Buy Tickets',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (movieDetails.containsKey('title') &&
                    movieDetails['title'] != null)
                  Text(
                    movieDetails['title'],
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                const SizedBox(height: 8),
                SmoothStarRating(
                  rating: (movieDetails['vote_average'] ?? 0).toDouble(),

                  // isReadOnly: true,
                  size: 20,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.star_half,
                  defaultIconData: Icons.star_border,
                  color: Colors.amber,
                  borderColor: Colors.amber,
                  starCount: 5,
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Text(
                        '${((movieDetails['runtime'] ?? 0) / 60).floor().toString()}h ${(movieDetails['runtime'] ?? 0) % 60}min',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        " | ",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        movieDetails['genres'] != null
                            ? (movieDetails['genres'] as List)
                                .map((genre) => genre['name'].toString())
                                .join(', ')
                            : 'No genres',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'Storyline',
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (movieDetails.containsKey('overview') &&
                    movieDetails['overview'] != null)
                  Text(
                    movieDetails['overview'],
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
