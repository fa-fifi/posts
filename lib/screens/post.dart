import 'package:flutter/material.dart';
import 'package:posts/models/comment.dart';
import '../models/post.dart';
import '../repositories/post.dart';
import 'update.dart';

class PostScreen extends StatefulWidget {
  final int id;

  const PostScreen({super.key, required this.id});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late Future<Post> _future;
  late Future<List<Comment>> _fetchComments;

  @override
  void initState() {
    super.initState();
    _future = PostRepository.fetchPost(id: widget.id);
    _fetchComments = PostRepository.fetchComments(postId: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post ${widget.id}'),
      ),
      body: Column(
        children: [
          FutureBuilder<Post>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return ListTile(
                    title: Text(snapshot.data?.title ?? 'Deleted'),
                    subtitle: Text(snapshot.data?.body ?? 'Deleted'),
                    trailing: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _future = PostRepository.deletePost(
                                snapshot.data!.id.toString());
                          });
                        },
                        child: const Text('Delete')),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
              }
              return const CircularProgressIndicator();
            },
          ),
          const Divider(),
          FutureBuilder<List<Comment>>(
            future: _fetchComments,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                debugPrint(snapshot.data.toString());
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(snapshot.data![index].name),
                      subtitle: Text(snapshot.data![index].body),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              return const CircularProgressIndicator();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Edit Post',
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => UpdateScreen(id: widget.id))),
        child: const Icon(Icons.edit),
      ),
    );
  }
}
