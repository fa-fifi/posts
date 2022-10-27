import 'package:flutter/material.dart';
import '../models/post.dart';
import '../repositories/post.dart';

class PostScreen extends StatefulWidget {
  final int id;

  const PostScreen({super.key, required this.id});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late Future<Post> _future;

  @override
  void initState() {
    super.initState();
    _future = PostRepository.fetchPost(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post ${widget.id}'),
      ),
      body: Center(
        child: FutureBuilder<Post>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: [
                  ListTile(
                      title: Text(snapshot.data!.title),
                      subtitle: Text(
                        snapshot.data!.body,
                      )),
                ],
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
