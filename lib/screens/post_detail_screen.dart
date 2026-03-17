import 'package:flutter/material.dart';
import '../models/post.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;
  const PostDetailScreen({super.key, required this.post});

  static const _avatarColors = [
    Color(0xFF6C63FF), Color(0xFFFF6584), Color(0xFF43C6AC),
    Color(0xFFFF9A3C), Color(0xFF4FACFE), Color(0xFFA18CD1),
  ];

  @override
  Widget build(BuildContext context) {
    final color = _avatarColors[post.id % _avatarColors.length];
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2FF),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withAlpha(180)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Hero(
                    tag: 'avatar_${post.id}',
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.white.withAlpha(40),
                      child: Text(
                        '${post.id}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoChip(label: 'User ID: ${post.userId}', color: color),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Title',
                          style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12, letterSpacing: 1),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          post.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Content',
                          style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12, letterSpacing: 1),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          post.body,
                          style: const TextStyle(fontSize: 15, height: 1.7, color: Color(0xFF444466)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color color;
  const _InfoChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
    );
  }
}
