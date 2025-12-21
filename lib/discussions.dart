import 'package:flutter/material.dart';

class DiscussionsPage extends StatelessWidget {
  const DiscussionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
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

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _DiscussionBlock(
            creator: "Yiğit N.",
            title: "Midterm tips & resources",
            color: Color(0xFFFFF3E0),
          ),
          SizedBox(height: 14),
          _DiscussionBlock(
            creator: "Berkay B.",
            title: "Project 2 – setup help",
            color: Color(0xFFE3F2FD),
          ),
          SizedBox(height: 14),
          _DiscussionBlock(
            creator: "Ozan M.",
            title: "Lab questions & fixes",
            color: Color(0xFFE8F5E9),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF004990),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _DiscussionBlock extends StatelessWidget {
  final String creator;
  final String title;
  final Color color;

  const _DiscussionBlock({
    required this.creator,
    required this.title,
    required this.color,
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
          onTap: () {},
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
