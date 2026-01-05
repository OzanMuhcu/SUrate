import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surate/models/discussion.dart';
import 'package:surate/models/comment.dart';
import '/providers/data_provider.dart';
import '/providers/auth_provider.dart';

class DiscussionDetailPage extends StatelessWidget {
  final Discussion discussion;

  const DiscussionDetailPage({super.key, required this.discussion});

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Discussion Details",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF004990),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color(0xFF004990),
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          discussion.creatorName.isNotEmpty
                              ? discussion.creatorName
                              : "Anonymous",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          discussion.createdAt.toString().substring(0, 16),
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  discussion.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004990),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  discussion.body,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),

          const Divider(thickness: 1, height: 1),

          Expanded(
            child: StreamBuilder<List<Comment>>(
              stream: dataProvider.getCommentsStream(discussion.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("No comments yet. Be the first to reply!"),
                  );
                }

                final comments = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  comment.authorName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  _formatDate(comment.createdAt),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(comment.text),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF004990),
        onPressed: () => _showReplyModal(context),
        child: const Icon(Icons.reply, color: Colors.white),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
  }

  void _showReplyModal(BuildContext context) {
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Write a Reply"),

        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: commentController,
                decoration: const InputDecoration(
                  hintText: "Share your thoughts...",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF004990),
            ),
            onPressed: () async {
              if (commentController.text.trim().isEmpty) return;

              final authProvider = context.read<AuthProvider>();
              final dataProvider = context.read<DataProvider>();
              final user = authProvider.user;

              if (user != null) {
                try {

                  await dataProvider.addComment(
                    discussion.id,
                    commentController.text.trim(),
                    user.uid,
                    user.displayName ?? "Anonymous",
                    discussion.courseId,
                  );

                  if (ctx.mounted) Navigator.pop(ctx);

                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: $e")),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("You must be logged in to comment.")),
                );
              }
            },
            child: const Text("Post", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}