import 'package:flutter/material.dart';
import 'package:flutter_youtube_api/api/api_service.dart';
import 'package:flutter_youtube_api/models/channel.dart';
import 'package:flutter_youtube_api/models/video.dart';
import 'package:flutter_youtube_api/screens/youtube_play.dart';

class YoutubeHome extends StatefulWidget {
  @override
  _YoutubeHomeState createState() => _YoutubeHomeState();
}

class _YoutubeHomeState extends State<YoutubeHome> {
  ScrollController scrollController = ScrollController();
  bool isLoading = false;
  Channel _channel;

  getchannel() async {
    Channel channel = await ApiService.instance
        .fetchChannel(channelId: 'UCvNVrlPTL_QQzzpc362LTgQ');
    setState(() {
      _channel = channel;
    });
  }

  loadMoreVideo() async {
    setState(() {
      isLoading = true;
    });
    List<Video> moreVideo = await ApiService.instance
        .fetchVideo(playListId: _channel.uploadPlaylistId);
    List<Video> allVideo = _channel.videos..addAll(moreVideo);
    setState(() {
      _channel.videos = allVideo;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getchannel();
  }

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() {
      if (!isLoading &&
          scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          _channel.videos.length != int.parse(_channel.videoCount)) {
        print('End');
        loadMoreVideo();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Youtube Home'),
        centerTitle: true,
      ),
      body: _channel == null
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            )
          : Column(
              children: [
                Card(
                  child: Container(
                    height: 100,
                    margin: EdgeInsets.all(15),
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          backgroundImage:
                              NetworkImage(_channel.profilePictureUrl),
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
                              Text(
                                _channel.videoCount + " video",
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
                    controller: scrollController,
                    itemCount: _channel.videos.length,
                    itemBuilder: (context, i) {
                      Video video = _channel.videos[i];
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => YoutubePlay(
                              id: video.id,
                            ),
                          ),
                        ),
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
