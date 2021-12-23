import 'package:awesome_app/awesome_app.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPhotosPage extends StatefulWidget {
  static const String routeName = "/detail_photos_page";
  final Photos photos;
  const DetailPhotosPage({Key? key, required this.photos}) : super(key: key);

  @override
  _DetailPhotosPageState createState() => _DetailPhotosPageState();
}

class _DetailPhotosPageState extends State<DetailPhotosPage> {

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    var photos = context.read<PhotosProvider>();
    return Scaffold(
      body: Container(
        decoration:
            const BoxDecoration(image: DecorationImage(image: AssetImage('assets/background.jpg'), fit: BoxFit.cover)),
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    background: FadeInImage(
                      placeholder: const AssetImage('assets/image-not-found.png'),
                      image: Image.network(
                        widget.photos.src!.landscape!,
                      ).image,
                      fit: BoxFit.cover,
                    )),
              ),
            ];
          },
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person, size: 24, color: Colors.grey.shade400),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          widget.photos.photographer!,
                          style: themeData.textTheme.headline6?.copyWith(color: Colors.black),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.photos.alt!,
                            maxLines: 3,
                            style: themeData.textTheme.bodyText1,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (!await launch(
                              widget.photos.url!,
                              forceSafariVC: false,
                              forceWebView: false,
                            )) {
                              throw 'Could not launch ${widget.photos.url!}';
                            }
                          },
                          child: const Text("Open Link"),
                          style: ElevatedButton.styleFrom(
                              primary: secondaryColor,
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                              textStyle: themeData.textTheme.bodyText1),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "More photos",
                      style: themeData.textTheme.headline6,
                    ),
                    const SizedBox(height: 5),
                    GridView.builder(
                      itemCount: photos.listPhotos!.where((element) => element.id != widget.photos.id).toList().length,
                      itemBuilder: (context, index) {
                        var data = photos.listPhotos!.where((element) => element.id != widget.photos.id).toList();

                        return ItemPhotoGrid(
                          photos: data[index],
                          isFromDetail: true,
                        );
                      },
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 180, //MENGATUR BESARNYA ELEMEN GRID PER ITEMNYA,
                        childAspectRatio: 0.8, //MENGATUR ASPEK RASIO
                        crossAxisSpacing: 15, //MENGATUR JARAK ELEMENT SECARA HORIZONTAL
                        mainAxisSpacing: 5, //MENGATUR JARAK ELEMENT SECARA VERTICAL
                      ),
                      shrinkWrap: true,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
