import 'package:awesome_app/awesome_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemPhotoList extends StatelessWidget {
  final Photos photos;
  const ItemPhotoList({Key? key, required this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    ThemeData themeData = Theme.of(context);

    return InkWell(
      key: const Key("detail_restaurant_page"),
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1000),
            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
              return DetailPhotosPage(
                photos: photos,
              );
            },
            transitionsBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation, Widget child) {
              return Align(
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Stack(
          children: [ 
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: FadeInImage(
                placeholder: const AssetImage('assets/image-not-found.png'),
                image: Image.network(
                  photos.src!.landscape!,
                ).image,
                height: 175,
                width: size.width,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                width: size.width,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.5),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person, size: 18, color: Colors.grey.shade400),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      photos.photographer!,
                      style: themeData.textTheme.bodyText2?.copyWith(color: Colors.black),
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
}
