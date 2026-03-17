import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';
import 'post_detail_screen.dart';
import 'post_form_screen.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = ApiService.fetchPosts();
  }

  void _refresh() {
    setState(() {
      _postsFuture = ApiService.fetchPosts();
    });
  }

  Future<void> _delete(int id) async {
    try {
      await ApiService.deletePost(id);
      if (!mounted) return;
      _showSnack('Post deleted successfully', isError: false);
      _refresh();
    } catch (e) {
      if (!mounted) return;
      _showSnack('Failed to delete post', isError: true);
    }
  }

  void _showSnack(String msg, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        Icon(isError ? Icons.error_outline : Icons.check_circle_outline, color: Colors.white, size: 20),
        const SizedBox(width: 10),
        Text(msg),
      ]),
      backgroundColor: isError ? const Color(0xFFFF6584) : const Color(0xFF6C63FF),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2FF),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: const Text('Posts Manager', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF9C8FFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40, right: 20),
                    child: Icon(Icons.article_rounded, size: 80, color: Colors.white.withAlpha(40)),
                  ),
                ),
              ),
            ),
          ),
        ],
        body: FutureBuilder<List<Post>>(
          future: _postsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
              );
            }
            if (snapshot.hasError) {
              final msg = snapshot.error.toString().replaceFirst('Exception: ', '');
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.wifi_off_rounded, size: 64, color: Color(0xFFBBBBDD)),
                      const SizedBox(height: 16),
                      const Text('Failed to load posts',
                          style: TextStyle(color: Color(0xFF444466), fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text(msg,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Color(0xFF9E9EC8), fontSize: 13)),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _refresh,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }
            final posts = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              itemCount: posts.length,
              itemBuilder: (context, index) => _PostCard(
                post: posts[index],
                onEdit: () async {
                  await Navigator.push(context,
                      MaterialPageRoute(builder: (_) => PostFormScreen(post: posts[index])));
                  _refresh();
                },
                onDelete: () => _confirmDelete(context, posts[index].id),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => PostDetailScreen(post: posts[index]))),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const PostFormScreen()));
          _refresh();
        },
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Post', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(children: [
          Icon(Icons.delete_outline_rounded, color: Color(0xFFFF6584)),
          SizedBox(width: 10),
          Text('Delete Post'),
        ]),
        content: const Text('This action cannot be undone. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF9E9EC8))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6584)),
            onPressed: () { Navigator.pop(context); _delete(id); },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PostCard({required this.post, required this.onTap, required this.onEdit, required this.onDelete});

  static const _avatarColors = [
    Color(0xFF6C63FF), Color(0xFFFF6584), Color(0xFF43C6AC),
    Color(0xFFFF9A3C), Color(0xFF4FACFE), Color(0xFFA18CD1),
  ];

  @override
  Widget build(BuildContext context) {
    final color = _avatarColors[post.id % _avatarColors.length];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'avatar_${post.id}',
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: color.withAlpha(30),
                    child: Text(
                      '${post.id}',
                      style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, height: 1.4),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        post.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Color(0xFF9E9EC8), fontSize: 12, height: 1.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  children: [
                    _ActionBtn(icon: Icons.edit_rounded, color: const Color(0xFF6C63FF), onTap: onEdit),
                    const SizedBox(height: 4),
                    _ActionBtn(icon: Icons.delete_rounded, color: const Color(0xFFFF6584), onTap: onDelete),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: color.withAlpha(20), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}
