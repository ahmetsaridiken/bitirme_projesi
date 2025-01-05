import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: FavoritesList(),
    );
  }
}

class FavoritesList extends StatelessWidget {
  final CollectionReference favorites = FirebaseFirestore.instance.collection('favorites');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: favorites.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot favorite = snapshot.data!.docs[index];
            return FavoriteListItem(
              title: favorite['title'],
              description: favorite['description'],
              thumbnailUrl: favorite['thumbnailUrl'],
              videoUrl: favorite['videoUrl'],
            );
          },
        );
      },
    );
  }
}

class FavoriteListItem extends StatelessWidget {
  final String title;
  final String description;
  final String thumbnailUrl;
  final String videoUrl;

  FavoriteListItem({
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.videoUrl
  });

  Future<void> _launchURL() async {
    final Uri url = Uri.parse(videoUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $videoUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(thumbnailUrl),
          ListTile(
            title: Text(title),
            subtitle: Text(description),
            onTap: _launchURL,
          ),
        ],
      ),
    );
  }
} 