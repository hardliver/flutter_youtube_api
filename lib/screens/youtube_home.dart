import 'package:flutter/material.dart';
import 'package:flutter_youtube_api/api/api_service.dart';
import 'package:flutter_youtube_api/models/channel.dart';
import 'package:flutter_youtube_api/models/video.dart';

class YoutubeHome extends StatefulWidget {
  @override
  _YoutubeHomeState createState() => _YoutubeHomeState();
}

class _YoutubeHomeState extends State<YoutubeHome> {
  Channel _channel;

  getchannel() async {
    Channel channel = await ApiService.instance
        .fetchChannel(channelId: 'UCvNVrlPTL_QQzzpc362LTgQ');
    setState(() {
      _channel = channel;
    });
  }

  @override
  void initState() {
    super.initState();
    getchannel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Youtube Home'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Card(
            child: Container(
              height: 100,
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(_channel.profilePictureUrl),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          _channel.title,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          _channel.subscriberCount + " subscribers",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 1.5,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _channel.videos.length,
              itemBuilder: (context, i) {
                Video video = _channel.videos[i];
                return GestureDetector(
                  child: Container(
                    child: Card(
                      child: Row(
                        children: [
                          Image(
                            image: NetworkImage(video.thumbnailUrl),
                            width: 150,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  video.title,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
