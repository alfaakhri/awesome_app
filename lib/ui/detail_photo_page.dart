import 'package:awesome_app/awesome_app.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailPhotosPage extends StatefulWidget {
  static const String routeName = "/detail_photos_page";
  final Photos photos;
  const DetailPhotosPage({Key? key, required this.photos}) : super(key: key);

  @override
  _DetailPhotosPageState createState() => _DetailPhotosPageState();
}

class _DetailPhotosPageState extends State<DetailPhotosPage> {
  Stack _buildBody() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    ThemeData themeData = Theme.of(context);

    double maxSize = max(mediaQueryData.size.width, mediaQueryData.size.height);
    return Stack(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/background.jpg'), fit: BoxFit.cover)),
          child: _buildDetail(mediaQueryData, maxSize, widget.photos, themeData),
        ),
        Positioned(
          top: mediaQueryData.padding.top + 10,
          left: 10,
          child: Container(
            height: 40,
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: IconButton(
              alignment: Alignment.center,
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        )
      ],
    );
  }

  ListView _buildDetail(MediaQueryData mediaQueryData, double maxSize, Photos photos, ThemeData themeData) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          constraints: BoxConstraints(
            minHeight: mediaQueryData.size.height,
            minWidth: mediaQueryData.size.width,
          ),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildImageHeader(maxSize, mediaQueryData, photos),
                    ],
                  ),
                  Container(
                    width: mediaQueryData.size.width,
                    padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10, top: maxSize * 0.48),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(photos.photographer!,
                                  softWrap: true,
                                  maxLines: 2,
                                  style: const TextStyle(
                                      fontSize: 32, height: 1.2, color: Colors.black, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.room, size: 18, color: Colors.grey.shade400),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(photos.photographer!,
                                    style: themeData.textTheme.subtitle2?.copyWith(color: Colors.black26)),
                              ],
                            ),
                            
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container _buildImageHeader(double maxSize, MediaQueryData mediaQueryData, Photos photos) {
    return Container(
        height: maxSize * 0.4 + mediaQueryData.padding.top,
        width: mediaQueryData.size.width,
        child: ShaderMask(
            shaderCallback: (rect) {
              return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.black, Colors.transparent],
                  stops: [0.0, 0.75, 0.98]).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
            },
            blendMode: BlendMode.dstIn,
            child: Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Hero(
                  tag: photos.id!,
                  child: FadeInImage(
                    placeholder: const AssetImage('assets/image-not-found.png'),
                    image: Image.network(
                      photos.src!.landscape!,
                    ).image,
                    width: mediaQueryData.size.width,
                    height: maxSize * 0.4 + mediaQueryData.padding.top - 2,
                    fit: BoxFit.cover,
                  ),
                ))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }
}
