import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:surate/models/discussion.dart';
import 'package:surate/providers/data_provider.dart';
import 'package:surate/providers/auth_provider.dart';

import 'discussion_detail_page.dart';

class DiscussionsPage extends StatelessWidget {
  const DiscussionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "CS204 Discussions",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF004990),
      ),
      body: Consumer<DataProvider>(
        builder: (context, dataProvider, child) {
          if (dataProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (dataProvider.errorMessage != null) {
            return Center(child: Text("Error: ${dataProvider.errorMessage}"));
          }

          if (dataProvider.discussions.isEmpty) {
            return const Center(child: Text("No discussions found."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: dataProvider.discussions.length,
            itemBuilder: (context, index) {
              final discussion = dataProvider.discussions[index];
              return Column(
                children: [
                  _DiscussionBlock(
                    creator: discussion.creatorName.isNotEmpty
                        ? discussion.creatorName
                        : "Anonymous",
                    title: discussion.title,
                    color: index % 3 == 0
                        ? const Color(0xFFFFF3E0)
                        : (index % 3 == 1
                        ? const Color(0xFFE3F2FD)
                        : const Color(0xFFE8F5E9)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DiscussionDetailPage(discussion: discussion),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDiscussionDialog(context);
        },
        backgroundColor: const Color(0xFF004990),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddDiscussionDialog(BuildContext context) {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("New Discussion"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: bodyController,
              decoration:
              const InputDecoration(labelText: "Body (Question/Topic)"),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.isEmpty || bodyController.text.isEmpty) {
                return;
              }

              final authProvider = context.read<AuthProvider>();
              final user = authProvider.user;

              if (user != null) {
                context.read<DataProvider>().addDiscussion(
                  titleController.text,
                  bodyController.text,
                  "CS204",
                  user.email?.split('@')[0] ?? "Anonymous",
                  user.uid,
                );
                Navigator.pop(ctx);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("You must be logged in to post.")),
                );
              }
            },
            child: const Text("Add"),
          )
        ],
      ),
    );
  }
}

class _DiscussionBlock extends StatelessWidget {
  final String creator;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _DiscussionBlock({
    required this.creator,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "— $creator",
          style: const TextStyle(color: Colors.black54, fontSize: 13),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.forum, color: Color(0xFF004990)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.black45),
              ],
            ),
          ),
        ),
      ],
    );
  }
}