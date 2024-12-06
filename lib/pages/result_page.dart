import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../services/secure_storage_service.dart';
import 'detail_page.dart';

class ResultPage extends StatefulWidget {
  final String query;

  ResultPage({required this.query});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<Map<String, dynamic>> _results = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSearchResults(widget.query);
  }

  Future<void> _fetchSearchResults(String query) async {
    try {
      final token = await getAccessToken();
      if (token == null) {
        throw Exception('Access Token 未設置');
      }

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json;charset=utf-8',
      };

      final isChinese = RegExp(r'[\u4e00-\u9fff]').hasMatch(query);
      final language = isChinese ? 'zh-TW' : 'en-US';

      final searchUrl =
          'https://api.themoviedb.org/3/search/multi?query=$query&language=$language';
      final searchResponse =
      await http.get(Uri.parse(searchUrl), headers: headers);
      final searchResult = json.decode(searchResponse.body);

      if (searchResult['results'] != null) {
        final List<Map<String, dynamic>> sortedResults =
        List<Map<String, dynamic>>.from(searchResult['results'])
          ..sort((a, b) {
            final titleA = (a['title'] ?? a['name'] ?? '').toLowerCase();
            final titleB = (b['title'] ?? b['name'] ?? '').toLowerCase();
            final queryLower = query.toLowerCase();

            if (titleA == queryLower) return -1;
            if (titleB == queryLower) return 1;

            final indexA = titleA.indexOf(queryLower);
            final indexB = titleB.indexOf(queryLower);

            if (indexA != -1 && indexB != -1) {
              return indexA.compareTo(indexB);
            } else if (indexA != -1) {
              return -1;
            } else if (indexB != -1) {
              return 1;
            }

            final popularityA = a['popularity'] ?? 0;
            final popularityB = b['popularity'] ?? 0;
            return popularityB.compareTo(popularityA);
          });

        setState(() {
          _results = sortedResults.take(10).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _results = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('搜尋時發生錯誤：$e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('搜尋結果 - ${widget.query}')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _results.isEmpty
          ? Center(child: Text('找不到與 "${widget.query}" 相關的結果'))
          : ListView.builder(
        itemCount: _results.length,
        itemBuilder: (context, index) {
          final result = _results[index];
          final title = result['title'] ?? result['name'] ?? '未知名稱';
          final mediaType = result['media_type'] == 'movie' ? '電影' : '影集';
          final id = result['id'];
          final imageUrl = result['poster_path'] != null
              ? 'https://image.tmdb.org/t/p/w500${result['poster_path']}'
              : null;

          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              contentPadding: const EdgeInsets.all(8.0),
              leading: AspectRatio(
                aspectRatio: 2 / 3,
                child: imageUrl != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.image_not_supported, size: 50),
                  ),
                )
                    : Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.image_not_supported, size: 50),
                ),
              ),
              title: Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                mediaType,
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(
                      id: id,
                      mediaType: result['media_type'],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}