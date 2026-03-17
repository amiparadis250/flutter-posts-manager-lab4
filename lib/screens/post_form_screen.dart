import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';

class PostFormScreen extends StatefulWidget {
  final Post? post;
  const PostFormScreen({super.key, this.post});

  @override
  State<PostFormScreen> createState() => _PostFormScreenState();
}

class _PostFormScreenState extends State<PostFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _bodyCtrl;
  bool _loading = false;

  bool get _isEditing => widget.post != null;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.post?.title ?? '');
    _bodyCtrl = TextEditingController(text: widget.post?.body ?? '');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      if (_isEditing) {
        await ApiService.updatePost(Post(
          id: widget.post!.id,
          userId: widget.post!.userId,
          title: _titleCtrl.text.trim(),
          body: _bodyCtrl.text.trim(),
        ));
      } else {
        await ApiService.createPost(Post(
          id: 0, userId: 1,
          title: _titleCtrl.text.trim(),
          body: _bodyCtrl.text.trim(),
        ));
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: [
          const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Text(_isEditing ? 'Post updated successfully!' : 'Post created successfully!'),
        ]),
        backgroundColor: const Color(0xFF6C63FF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Row(children: [
          Icon(Icons.error_outline, color: Colors.white, size: 20),
          SizedBox(width: 10),
          Text('Something went wrong. Try again.'),
        ]),
        backgroundColor: const Color(0xFFFF6584),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2FF),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 60, bottom: 16),
              title: Text(
                _isEditing ? 'Edit Post' : 'New Post',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
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
                    child: Icon(
                      _isEditing ? Icons.edit_note_rounded : Icons.post_add_rounded,
                      size: 80,
                      color: Colors.white.withAlpha(40),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel(label: 'Title', icon: Icons.title_rounded),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _titleCtrl,
                      decoration: const InputDecoration(hintText: 'Enter post title...'),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Title is required' : null,
                    ),
                    const SizedBox(height: 24),
                    _FieldLabel(label: 'Body', icon: Icons.notes_rounded),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _bodyCtrl,
                      decoration: const InputDecoration(
                        hintText: 'Write your post content here...',
                        alignLabelWithHint: true,
                      ),
                      maxLines: 8,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Body is required' : null,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _submit,
                        child: _loading
                            ? const SizedBox(
                                height: 22, width: 22,
                                child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(_isEditing ? Icons.save_rounded : Icons.send_rounded, size: 20),
                                  const SizedBox(width: 10),
                                  Text(_isEditing ? 'Save Changes' : 'Publish Post'),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF6C63FF)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Cancel', style: TextStyle(color: Color(0xFF6C63FF), fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  final IconData icon;
  const _FieldLabel({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 18, color: const Color(0xFF6C63FF)),
      const SizedBox(width: 6),
      Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF444466))),
    ]);
  }
}
