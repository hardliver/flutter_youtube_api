import 'dart:convert';
import 'dart:io';

import 'package:flutter_youtube_api/models/channel.dart';
import 'package:flutter_youtube_api/models/video.dart';
import 'package:flutter_youtube_api/secrets/key.dart';
import 'package:http/http.dart' as http;

class ApiService {
  ApiService.instanciate();
  static final ApiService instance = ApiService.instanciate();

  final _baseUrl = 'www.googleapis.com';
  String _nextPageToken = '';

  Future<Channel> fetchChannel({String channelId}) async {
    var parameters = {
      'part': 'snippet, contentDetails, statistics',
      'id': channelId,
      'key': YOUTUBE_KEY
    };

    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    Uri uri = Uri.https(_baseUrl, '/youtube/v3/channels', parameters);

    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var finalData = data['items'][0];
      Channel channel = Channel.fromJson(finalData);
      channel.videos = await fetchVideo(playListId: channel.uploadPlaylistId);
      return channel;
    } else {
      var error = json.decode(response.body);
      String errorMessage = error['error']['message'];
      throw errorMessage;
    }
  }

  Future<List<Video>> fetchVideo({String playListId}) async {
    var parameters = {
      'part': 'snippet',
      'playlistId': playListId,
      'maxResults': '8',
      'pageToken': _nextPageToken,
      'key': YOUTUBE_KEY,
    };

    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    Uri uri = Uri.https(_baseUrl, '/youtube/v3/playlistItems', parameters);
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      _nextPageToken = data['nextPageToken'] ?? '';
      List<dynamic> jsonVideo = data['items'];
      List<Video> videos = [];
      for (var video in jsonVideo) {
        videos.add(Video.fromJson(video['snippet']));
      }
      return videos;
    } else {
      var error = json.decode(response.body);
      String errorMessage = error['error']['message'];
      throw errorMessage;
    }
  }
}
