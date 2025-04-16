import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:social_share_plugin/social_share_plugin.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await SocialSharePlugin.platformVersion ?? 'Unknown';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            Center(
              child: Text('Running on: $_platformVersion\n'),
            ),
            ElevatedButton(
              child: Text('Share to Instagram'),
              onPressed: () async {
                final file =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                await SocialSharePlugin.shareToFeedInstagram(path: file!.path);
              },
            ),
            ElevatedButton(
              child: Text('Share to Facebook Photo'),
              onPressed: () async {
                final file =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                await SocialSharePlugin.shareToFeedFacebookPhoto(
                    path: file!.path,
                    hashtag: '#test',
                    onSuccess: (_) async {
                      print('FACEBOOK SUCCESS');
                    },
                    onCancel: () async {
                      print('FACEBOOK CANCELLED');
                    },
                    onError: (error) async {
                      print('FACEBOOK ERROR $error');
                    });
              },
            ),
            ElevatedButton(
              child: Text('Share to Facebook Network Photo'),
              onPressed: () async {
                await SocialSharePlugin.shareToFeedFacebookPhoto(
                    url: 'https://picsum.photos/600/400',
                    hashtag: '#test',
                    onSuccess: (_) async {
                      print('FACEBOOK SUCCESS');
                    },
                    onCancel: () async {
                      print('FACEBOOK CANCELLED');
                    },
                    onError: (error) async {
                      print('FACEBOOK ERROR $error');
                    });
              },
            ),
            ElevatedButton(
              child: Text('Share to Facebook Video'),
              onPressed: () async {
                if (Platform.isAndroid) {
                  final file = await ImagePicker()
                      .pickVideo(source: ImageSource.gallery);
                  await SocialSharePlugin.shareToFeedFacebookVideo(
                      path: file!.path,
                      hashtag: '#test',
                      onSuccess: (_) async {
                        print('FACEBOOK SUCCESS');
                      },
                      onCancel: () async {
                        print('FACEBOOK CANCELLED');
                      },
                      onError: (error) async {
                        print('FACEBOOK ERROR $error');
                      });
                } else if (Platform.isIOS) {
                  await SocialSharePlugin.shareToFeedFacebookVideo(
                      hashtag: '#test',
                      onSuccess: (_) async {
                        print('FACEBOOK SUCCESS');
                      },
                      onCancel: () async {
                        print('FACEBOOK CANCELLED');
                      },
                      onError: (error) async {
                        print('FACEBOOK ERROR $error');
                      });
                }
              },
            ),
            ElevatedButton(
              child: Text('Share to Facebook Link'),
              onPressed: () async {
                String url = 'https://flutter.dev/';
                final quote =
                    'Flutter is Google’s portable UI toolkit for building beautiful, natively-compiled applications for mobile, web, and desktop from a single codebase.';
                final result = await SocialSharePlugin.shareToFeedFacebookLink(
                  quote: quote,
                  url: url,
                  hashtag: '#test',
                  onSuccess: (_) async {
                    print('FACEBOOK SUCCESS');
                  },
                  onCancel: () async {
                    print('FACEBOOK CANCELLED');
                  },
                  onError: (error) async {
                    print('FACEBOOK ERROR $error');
                  },
                );

                print(result);
              },
            ),
            ElevatedButton(
              child: Text('Share to Twitter'),
              onPressed: () async {
                String url = 'https://flutter.dev/';
                final text =
                    'Flutter is Google’s portable UI toolkit for building beautiful, natively-compiled applications for mobile, web, and desktop from a single codebase.';
                final result = await SocialSharePlugin.shareToTwitterLink(
                    text: text,
                    url: url,
                    onSuccess: (_) async {
                      print('TWITTER SUCCESS');
                    },
                    onCancel: () async {
                      print('TWITTER CANCELLED');
                    });
                print(result);
              },
            ),
          ],
        ),
      ),
    );
  }
}
