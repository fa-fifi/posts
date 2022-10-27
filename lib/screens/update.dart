import 'package:flutter/material.dart';
import 'package:posts/models/post.dart';
import '../repositories/post.dart';

class UpdateScreen extends StatefulWidget {
  final int id;

  const UpdateScreen({super.key, required this.id});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
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
        title: Text('Update Post ${widget.id}'),
      ),
      body: FutureBuilder<Post>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Text(snapshot.data!.title),
                  Text(snapshot.data!.body),
                  TextField(
                    controller: _titleController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(hintText: 'Enter Title'),
                  ),
                  TextField(
                    controller: _bodyController,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(hintText: 'Enter Body'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _future = PostRepository.updatePost(
                              snapshot.data!.userId,
                              _titleController.text,
                              _bodyController.text);
                        });
                      },
                      child: const Text('Update Post'),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
