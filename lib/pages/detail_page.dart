import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../services/secure_storage_service.dart';

class DetailPage extends StatefulWidget {
  final int id;
  final String mediaType;

  DetailPage({required this.id, required this.mediaType});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic>? _details;
  List<String> _providers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDetails(widget.id, widget.mediaType);
  }

  Future<void> _fetchDetails(int id, String mediaType) async {
    try {
      final accessToken = await getAccessToken();
      if (accessToken == null) {
        throw Exception('Access Token 未設置');
      }

      final headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json;charset=utf-8',
      };

      final detailUrl =
          'https://api.themoviedb.org/3/$mediaType/$id?language=zh-TW';
      final detailResponse =
      await http.get(Uri.parse(detailUrl), headers: headers);
      final detailResult = json.decode(detailResponse.body);

      final providersUrl =
          'https://api.themoviedb.org/3/$mediaType/$id/watch/providers';
      final providersResponse =
      await http.get(Uri.parse(providersUrl), headers: headers);
      final providersResult = json.decode(providersResponse.body);

      List<String> providersList = [];
      if (providersResult['results'] != null &&
          providersResult['results']['TW'] != null &&
          providersResult['results']['TW']['flatrate'] != null) {
        final flatrate = providersResult['results']['TW']['flatrate'];
        providersList =
        List<String>.from(flatrate.map((p) => p['provider_name']));
      }

      setState(() {
        _details = detailResult;
        _providers = providersList;
        _isLoading = false;
      });
    } catch (e) {
      print('獲取詳細資訊時發生錯誤：$e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_details?['title'] ?? _details?['name'] ?? '詳細資訊'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _details == null
          ? Center(
        child: Text(
          '無法獲取詳細資訊',
          style: TextStyle(fontSize: 16, color: Colors.red),
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_details!['poster_path'] != null)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500${_details!['poster_path']}',
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            SizedBox(height: 16),

            Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _details!['title'] ??
                          _details!['name'] ??
                          '未知名稱',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    if (_details!['overview'] != null)
                      Text(
                        _details!['overview'],
                        style: TextStyle(fontSize: 16),
                      ),
                    SizedBox(height: 16),
                    if (_details!['release_date'] != null)
                      Text(
                        '發行日期：${_details!['release_date']}',
                        style: TextStyle(fontSize: 16),
                      ),
                    if (_details!['vote_average'] != null)
                      Text(
                        '評分：${_details!['vote_average']}',
                        style: TextStyle(fontSize: 16),
                      ),
                  ],
                ),
              ),
            ),

            Divider(),

            Text(
              '片源資訊',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            if (_providers.isEmpty)
              Center(
                child: Text(
                  '此影片在您的地區無法播放',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _providers.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 0),
                    child: ListTile(
                      leading: Icon(Icons.tv),
                      title: Text(_providers[index]),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}