import 'package:flutter/material.dart';
import 'package:posts/models/comment.dart';
import '../models/post.dart';
import '../repositories/post.dart';

class PostScreen extends StatefulWidget {
  final int id;

  const PostScreen({super.key, required this.id});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late Future<Post> _futurePost;
  late Future<List<Comment>> _futureComments;

  @override
  void initState() {
    super.initState();
    _futurePost = PostRepository.fetchPost(id: widget.id);
    _futureComments = PostRepository.fetchComments(postId: widget.id);
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
            future: _futurePost,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListTile(
                  title: Text(snapshot.data!.title),
                  subtitle: Text(
                    snapshot.data!.body,
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              return const CircularProgressIndicator();
            },
          ),
          const Divider(),
          FutureBuilder<List<Comment>>(
            future: _futureComments,
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
    );
  }
}
