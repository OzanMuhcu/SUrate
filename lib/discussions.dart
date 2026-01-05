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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "General Discussions",
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.primaryColor,
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
                        ? theme.colorScheme.tertiaryContainer
                        : (index % 3 == 1
                        ? theme.colorScheme.secondaryContainer
                        : theme.colorScheme.primaryContainer),
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
        backgroundColor: theme.primaryColor,
        child: Icon(Icons.add, color: theme.colorScheme.onPrimary),
      ),
    );
  }

  void _showAddDiscussionDialog(BuildContext context) {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    final theme = Theme.of(context);

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
            child: Text("Cancel", style: TextStyle(color: theme.colorScheme.secondary)),
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
                  user.displayName ?? "Anonymous",
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
            child: Text("Add", style: TextStyle(color: theme.colorScheme.primary)),
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
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "— $creator",
          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
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
                Icon(Icons.forum, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: theme.hintColor),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
