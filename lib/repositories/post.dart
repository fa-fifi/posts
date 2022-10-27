import 'package:posts/models/comment.dart';
import 'package:posts/models/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostRepository {
  static const String url = 'https://jsonplaceholder.typicode.com';

  static Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse('$url/posts'));

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((e) => Post.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load posts.');
    }
  }

  static Future<Post> fetchPost({required int id}) async {
    final response = await http.get(Uri.parse('$url/posts/$id'));

    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load post $id.');
    }
  }

  static Future<List<Comment>> fetchComments({required int postId}) async {
    final response = await http.get(Uri.parse('$url/posts/$postId/comments'));

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((e) => Comment.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load comments.');
    }
  }

  static Future<Post> createPost(int userId, String title, String body) async {
    final response = await http.post(
      Uri.parse('$url/posts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, dynamic>{'userId': userId, 'title': title, 'body': body}),
    );

    if (response.statusCode == 201) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create post.');
    }
  }
}
