import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'genelmasallar.dart';
import '../widgets/filter_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, List<String>> activeFilters = {};

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => FilterDialog(
        currentFilters: activeFilters,
        onApplyFilters: (filters) {
          setState(() {
            activeFilters = filters;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Masallar'),
        backgroundColor: Color(0xFFA5C5A8),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('masal').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final masallar = snapshot.data!.docs;

          // Apply filters
          if (activeFilters.isNotEmpty) {
            final filteredMasallar = masallar.where((masal) {
              final keywords = List<String>.from(masal['keywords'] ?? []);
              
              // Check if the masal matches all active filters
              for (final filter in activeFilters.entries) {
                bool matchesCategory = false;
                for (final value in filter.value) {
                  if (keywords.contains(value)) {
                    matchesCategory = true;
                    break;
                  }
                }
                if (!matchesCategory) return false;
              }
              return true;
            }).toList();

            if (filteredMasallar.isEmpty) {
              return const Center(
                child: Text('Seçili filtrelere uygun masal bulunamadı'),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: filteredMasallar.length,
              itemBuilder: (context, index) {
                final masal = filteredMasallar[index].data() as Map<String, dynamic>;
                final keywords = (masal['keywords'] as List<dynamic>?)?.cast<String>() ?? [];
                
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GenelMasallar(
                            title: masal['title'] ?? 'Başlıksız',
                            content: keywords.join(', '), // Temporarily showing all keywords
                            imageUrl: masal['masal_url'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (masal['masal_url'] != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                masal['masal_url'],
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 200,
                                    color: Colors.grey[300],
                                    child: Icon(Icons.error),
                                  );
                                },
                              ),
                            ),
                          SizedBox(height: 12),
                          Text(
                            masal['title'] ?? 'Başlıksız',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: keywords.map((keyword) => Chip(
                              label: Text(keyword),
                              backgroundColor: Color(0xFFA5C5A8).withOpacity(0.3),
                            )).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: masallar.length,
            itemBuilder: (context, index) {
              final masal = masallar[index].data() as Map<String, dynamic>;
              final keywords = (masal['keywords'] as List<dynamic>?)?.cast<String>() ?? [];
              
              return Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GenelMasallar(
                          title: masal['title'] ?? 'Başlıksız',
                          content: keywords.join(', '), // Temporarily showing all keywords
                          imageUrl: masal['masal_url'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (masal['masal_url'] != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              masal['masal_url'],
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 200,
                                  color: Colors.grey[300],
                                  child: Icon(Icons.error),
                                );
                              },
                            ),
                          ),
                        SizedBox(height: 12),
                        Text(
                          masal['title'] ?? 'Başlıksız',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: keywords.map((keyword) => Chip(
                            label: Text(keyword),
                            backgroundColor: Color(0xFFA5C5A8).withOpacity(0.3),
                          )).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}