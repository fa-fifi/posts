import 'package:flutter/material.dart';
import 'package:posts/screens/post.dart';
import '../models/post.dart';
import '../repositories/post.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Post>> _future;

  @override
  void initState() {
    super.initState();
    _future = PostRepository.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: Center(
        child: FutureBuilder<List<Post>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) => ListTile(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          PostScreen(id: snapshot.data![index].id))),
                  title: Text(snapshot.data![index].title),
                  subtitle: Text(snapshot.data![index].body),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
