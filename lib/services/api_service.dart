import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class ApiService {
  static const _base = 'https://jsonplaceholder.typicode.com/posts';
  static const _timeout = Duration(seconds: 15);

  static Future<List<Post>> fetchPosts() async {
    try {
      final uri = Uri.parse(_base);
      print('>>> Fetching: $uri');
      final res = await http.get(uri, headers: {'Accept': 'application/json'}).timeout(_timeout);
      print('>>> Status: ${res.statusCode}');
      print('>>> Body preview: ${res.body.substring(0, 100)}');
      if (res.statusCode == 200) {
        final body = utf8.decode(res.bodyBytes);
        return (jsonDecode(body) as List).map((e) => Post.fromJson(e)).toList();
      }
      throw Exception('Server error: ${res.statusCode}');
    } on TimeoutException {
      throw Exception('Connection timed out. Check your internet.');
    } catch (e) {
      print('>>> ERROR: $e');
      throw Exception('$e');
    }
  }

  static Future<Post> createPost(Post post) async {
    try {
      final res = await http.post(
        Uri.parse(_base),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(post.toJson()),
      ).timeout(_timeout);
      if (res.statusCode == 201) return Post.fromJson(jsonDecode(res.body));
      throw Exception('Server error: ${res.statusCode}');
    } on TimeoutException {
      throw Exception('Connection timed out. Check your internet.');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<Post> updatePost(Post post) async {
    try {
      final res = await http.put(
        Uri.parse('$_base/${post.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(post.toJson()),
      ).timeout(_timeout);
      if (res.statusCode == 200) return Post.fromJson(jsonDecode(res.body));
      throw Exception('Server error: ${res.statusCode}');
    } on TimeoutException {
      throw Exception('Connection timed out. Check your internet.');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<void> deletePost(int id) async {
    try {
      final res = await http.delete(Uri.parse('$_base/$id')).timeout(_timeout);
      if (res.statusCode != 200) throw Exception('Server error: ${res.statusCode}');
    } on TimeoutException {
      throw Exception('Connection timed out. Check your internet.');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
