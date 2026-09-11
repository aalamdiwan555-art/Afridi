import 'dart:convert';

import 'package:http/http.dart' as http;

class YouTubeApiException implements Exception {
  final String message;
  const YouTubeApiException(this.message);
  @override
  String toString() => message;
}

class YouTubeChannel {
  final String id;
  final String title;
  final String? customUrl;
  final String subscriberLabel;
  final String videoLabel;

  const YouTubeChannel({
    required this.id,
    required this.title,
    this.customUrl,
    required this.subscriberLabel,
    required this.videoLabel,
  });

  factory YouTubeChannel.fromApiResponse(Map<String, dynamic> response) {
    final items = response['items'] as List<dynamic>? ?? const <dynamic>[];
    if (items.isEmpty) {
      throw const YouTubeApiException('No YouTube channel was found for this Google account.');
    }
    final item = items.first as Map<String, dynamic>;
    final snippet = (item['snippet'] as Map?)?.cast<String, dynamic>() ?? const <String, dynamic>{};
    final statistics = (item['statistics'] as Map?)?.cast<String, dynamic>() ?? const <String, dynamic>{};
    return YouTubeChannel(
      id: item['id']?.toString() ?? '',
      title: snippet['title']?.toString() ?? 'YouTube channel',
      customUrl: snippet['customUrl']?.toString(),
      subscriberLabel: _formatCount(statistics['subscriberCount']),
      videoLabel: _formatCount(statistics['videoCount']),
    );
  }

  static String _formatCount(dynamic value) {
    final count = int.tryParse(value?.toString() ?? '');
    if (count == null) return 'Unavailable';
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}

class YouTubeService {
  final String accessToken;
  const YouTubeService({required this.accessToken});

  Future<YouTubeChannel> fetchMyChannel() async {
    final uri = Uri.https('www.googleapis.com', '/youtube/v3/channels', {
      'part': 'snippet,statistics',
      'mine': 'true',
    });
    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $accessToken',
      'Accept': 'application/json',
    });
    if (response.statusCode != 200) {
      throw const YouTubeApiException('YouTube authorization failed. Please reconnect your channel.');
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const YouTubeApiException('YouTube returned an invalid response.');
    }
    return YouTubeChannel.fromApiResponse(decoded);
  }
}
