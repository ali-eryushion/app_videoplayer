import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'colors.dart' as color;

class ExerciseInfo extends StatefulWidget {
  const ExerciseInfo({super.key});

  @override
  State<ExerciseInfo> createState() => _ExerciseInfoState();
}

class _ExerciseInfoState extends State<ExerciseInfo> {
  List videoInfo = [];
  bool _shouldPlayVideo = false;
  bool _isVideoPlaying = false;
  bool _isDisposed = false;
  VideoPlayerController? _controller;
  int _currentVideoPlayingIndex = -1;
  _initData() async {
    await DefaultAssetBundle.of(context)
        .loadString("json/videoinfo.json")
        .then((value) {
      setState(() {
        videoInfo = json.decode(value);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
    _isDisposed = true;
    _controller?.pause();
    _controller?.dispose();
    _controller = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: !_shouldPlayVideo
            ? BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.AppColor.gradientFirst.withOpacity(0.9),
                    color.AppColor.gradientSecond,
                  ],
                  begin: const FractionalOffset(
                      0.0, 0.4), //* for specific position
                  end: Alignment.topRight,
                ),
              )
            : BoxDecoration(color: color.AppColor.gradientSecond),
        child: Column(
          children: [
            !_shouldPlayVideo
                ? Container(
                    padding:
                        const EdgeInsets.only(top: 70, left: 30, right: 30),
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 20,
                                color: color.AppColor.secondPageIconColor,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            Expanded(child: Container()),
                            Icon(
                              Icons.info_outline,
                              size: 20,
                              color: color.AppColor.secondPageIconColor,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Legs Toning',
                          style: TextStyle(
                            fontSize: 25,
                            color: color.AppColor.secondPageTitleColor,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'and Glutes Workout',
                          style: TextStyle(
                            fontSize: 25,
                            color: color.AppColor.secondPageTitleColor,
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Row(
                          children: [
                            Container(
                              height: 30,
                              width: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  colors: [
                                    color.AppColor
                                        .secondPageContainerGradient1stColor,
                                    color.AppColor
                                        .secondPageContainerGradient2ndColor,
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.timer_outlined,
                                    size: 20,
                                    color: color.AppColor.secondPageIconColor,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '68 min',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          color.AppColor.secondPageTitleColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                              height: 30,
                              width: 220,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  colors: [
                                    color.AppColor
                                        .secondPageContainerGradient1stColor,
                                    color.AppColor
                                        .secondPageContainerGradient2ndColor,
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.handyman_outlined,
                                    size: 20,
                                    color: color.AppColor.secondPageIconColor,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Resistant band, kettebell',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          color.AppColor.secondPageTitleColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.only(top: 50, left: 30, right: 30),
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: Row(
                          children: [
                            InkWell(
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 20,
                                color: color.AppColor.secondPageIconColor,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      _videoPlayerView(context),
                      _controllerView(context),
                    ],
                  ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(70),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 30,
                        ),
                        Text(
                          'Circuit 1: Legs Toning',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: color.AppColor.circuitsColor,
                          ),
                        ),
                        Expanded(child: Container()),
                        Row(
                          children: [
                            Icon(
                              Icons.loop,
                              size: 30,
                              color: color.AppColor.loopColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              '3 sets',
                              style: TextStyle(
                                fontSize: 15,
                                color: color.AppColor.setsColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: _setupListView(),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView _setupListView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      itemCount: videoInfo.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: _listViewItem(index),
          onTap: () {
            setState(() {
              _shouldPlayVideo = true;
              _initializeVideoPlayer(index);
            });
          },
        );
      },
    );
  }

  Widget _videoPlayerView(BuildContext context) {
    final controller = _controller;

    if (controller!.value.isInitialized) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: VideoPlayer(controller),
      );
    } else {
      return const AspectRatio(
        aspectRatio: 16 / 9,
        child: Center(
            child: Text(
          'Wait....',
          style: TextStyle(fontSize: 20, color: Colors.white60),
        )),
      );
    }
  }

  _initializeVideoPlayer(int index) {
    final controller =
        VideoPlayerController.network(videoInfo[index]['videoUrl']);
    final oldController = _controller;
    _controller = controller;
    if (oldController != null) {
      oldController.removeListener(_onControllerUpdate);
      oldController.pause();
    }
    setState(() {});
    controller.initialize().then((_) {
      oldController?.dispose();
      _currentVideoPlayingIndex = index;
      controller.addListener(_onControllerUpdate);
      controller.play();
      setState(() {});
    });
  }

  SizedBox _listViewItem(int index) {
    return SizedBox(
      height: 135,
      width: 200,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: AssetImage(
                        videoInfo[index]['thumbnail'],
                      ),
                      fit: BoxFit.cover),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    videoInfo[index]['title'],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    videoInfo[index]['time'],
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                height: 20,
                width: 80,
                decoration: BoxDecoration(
                    color: const Color(0xFFeaeefc),
                    borderRadius: BorderRadius.circular(10)),
                child: const Center(
                  child: Text(
                    '15s rest',
                    style: TextStyle(color: Color(0xFF839fed)),
                  ),
                ),
              ),
              Row(
                children: [
                  for (int i = 0; i < 70; i++)
                    Container(
                      width: 3,
                      height: 1,
                      decoration: BoxDecoration(
                        color:
                            i.isEven ? const Color(0xFF839fed) : Colors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  String convertTo(int value) {
    return value < 10 ? "0$value" : "$value";
  }

  Widget _controllerView(BuildContext context) {
    final notMute = (_controller?.value.volume ?? 0) > 0;
    final duration = _duration?.inSeconds ?? 0;
    final head = _position?.inSeconds ?? 0;
    final remained = max(0, duration - head);
    final min = convertTo(remained ~/ 60.0);
    final secs = convertTo(remained % 60);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 40,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0.0, 0.0),
                          blurRadius: 4.0,
                          color: Color.fromARGB(50, 0, 0, 0),
                        ),
                      ],
                    ),
                    child: Icon(
                      notMute ? Icons.volume_up : Icons.volume_off,
                      color: Colors.white,
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    if (notMute) {
                      _controller?.setVolume(0);
                    } else {
                      _controller?.setVolume(1);
                    }
                  });
                },
              ),
              TextButton(
                onPressed: () async {
                  final index = _currentVideoPlayingIndex - 1;
                  if (index >= 0 && videoInfo.length >= 0) {
                    _initializeVideoPlayer(index);
                  } else {
                    Get.snackbar(
                      "Videos",
                      "",
                      snackPosition: SnackPosition.BOTTOM,
                      icon: const Icon(
                        Icons.face,
                        size: 30,
                        color: Colors.white,
                      ),
                      backgroundColor: color.AppColor.gradientSecond,
                      colorText: Colors.white,
                      messageText: const Text(
                        "No more videos ahead!",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    );
                  }
                },
                child: const Icon(
                  Icons.fast_rewind,
                  size: 26,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (_isVideoPlaying) {
                    setState(() {
                      _isVideoPlaying = false;
                    });
                    _controller?.pause();
                  } else {
                    setState(() {
                      _isVideoPlaying = true;
                    });
                    _controller?.play();
                  }
                },
                child: Icon(
                  _isVideoPlaying ? Icons.pause : Icons.play_arrow,
                  size: 26,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () async {
                  final index = _currentVideoPlayingIndex + 1;
                  if (index <= videoInfo.length - 1) {
                    _initializeVideoPlayer(index);
                  } else {
                    // const snackBar = SnackBar(
                    //   content: Text("No more videos in the list"),
                    // );

                    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    // Get.snackbar("Videos", "No more video to play");
                    Get.snackbar(
                      "VideoList",
                      "",
                      snackPosition: SnackPosition.BOTTOM,
                      icon: const Icon(
                        Icons.face,
                        size: 30,
                        color: Colors.white,
                      ),
                      backgroundColor: color.AppColor.gradientSecond,
                      colorText: Colors.white,
                      messageText: const Text(
                        "You have finished watching all the videos. Congrats!",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    );
                  }
                },
                child: const Icon(
                  Icons.fast_forward,
                  size: 26,
                  color: Colors.white,
                ),
              ),
              Text('$min:$secs',
                  style: const TextStyle(color: Colors.white, shadows: [
                    BoxShadow(
                      offset: Offset(0.0, 1.0),
                      blurRadius: 4.0,
                      color: Color.fromARGB(150, 0, 0, 0),
                    )
                  ]))
            ],
          ),
        ),
      ],
    );
  }

  var _onUpdateControllerTime;
  Duration? _duration;
  Duration? _position;
  var _progress = 0.0;
  void _onControllerUpdate() async {
    if (_isDisposed) return;

    _onUpdateControllerTime = 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    if (_onUpdateControllerTime > now) {
      return;
    }
    _onUpdateControllerTime = now + 500;

    final controller = _controller;
    if (controller == null) {
      return;
    }
    if (!controller.value.isInitialized) {
      return;
    }

    if (_duration == null) {
      _duration = _controller?.value.duration;
    }

    var duration = _duration;
    if (duration == null) return;

    var position = await controller.position;
    _position = position;
    final isVideoPlaying = controller.value.isPlaying;
    if (isVideoPlaying) {
      if (_isDisposed) return;
      setState(() {
        _progress = position!.inMilliseconds.ceilToDouble() /
            duration.inMilliseconds.ceilToDouble();
      });
    }
    _isVideoPlaying = isVideoPlaying;
  }
}
