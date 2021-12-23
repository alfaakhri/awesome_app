import 'package:awesome_app/awesome_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:network_module/network_module.dart';
import 'package:provider/provider.dart';
import 'package:provider_module/providers/photos_provider.dart';

class ListPhotosPage extends StatefulWidget {
  static const String routeName = '/list_photos_page';
  const ListPhotosPage({Key? key}) : super(key: key);

  @override
  _ListPhotosPageState createState() => _ListPhotosPageState();
}

class _ListPhotosPageState extends State<ListPhotosPage> {
  @override
  void initState() {
    super.initState();
    var photos = context.read<PhotosProvider>();
    Future.microtask(() {
      photos.setPageIndex(0);
      photos.clearDataPhotosPaging();
      photos.fetchListPhotos(limit: PAGE_SIZE, offset: PAGE_SIZE * photos.pageIndex);
    });
  }

  Widget _buildBody(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return OfflineBuilder(
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        final bool connected = connectivity != ConnectivityResult.none;
        if (connected) {
          return Consumer<PhotosProvider>(
            builder: (context, state, _) {
              if (state.status == Status.loading) {
                return const Center(
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(secondaryColor)));
              } else if (state.status == Status.failed) {
                return ErrorHandlingWidget(
                    message: state.message,
                    onPressed: () {
                      state.setPageIndex(0);
                      state.clearDataPhotosPaging();
                      state.fetchListPhotos(limit: PAGE_SIZE, offset: PAGE_SIZE * state.pageIndex);
                    });
              } else {
                return _buildList(themeData, state.listPhotos!, state);
              }
            },
          );
        } else {
          return ErrorHandlingWidget(
              message: "No Have Internet",
              onPressed: () {
                var photos = context.read<PhotosProvider>();
                photos.setPageIndex(0);
                photos.clearDataPhotosPaging();
                photos.fetchListPhotos(limit: PAGE_SIZE, offset: PAGE_SIZE * photos.pageIndex);
              });
        }
      },
      child: Container(),
    );
  }

  Widget _buildList(ThemeData themeData, List<Photos> listPhotos, PhotosProvider provider) {
    return RefreshIndicator(
      onRefresh: () async {
        provider.setPageIndex(0);
        provider.clearDataPhotosPaging();
        provider.fetchListPhotos(limit: PAGE_SIZE, offset: PAGE_SIZE * provider.pageIndex);
        await Future.value({});
      },
      child: Material(
        color: Colors.transparent,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        onPressed: () {
                          provider.setIsGrid();
                          provider.setPageIndex(0);
                          provider.clearDataPhotosPaging();
                          provider.fetchListPhotos(limit: PAGE_SIZE, offset: PAGE_SIZE * provider.pageIndex);
                        },
                        icon: Icon(
                          (provider.isGrid) ? Icons.grid_view_sharp : Icons.list,
                          size: 24,
                        ))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Hero(
                                tag: "Awesome App",
                                child: Text(
                                  "Awesome App",
                                  style: themeData.textTheme.headline4?.copyWith(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("Recommendation photo for you!",
                              maxLines: 2,
                              softWrap: true,
                              style: themeData.textTheme.bodyText1?.copyWith(color: Colors.black26)),
                        ],
                      ),
                    ),
                  ],
                ),
                provider.isGrid
                    ? Container()
                    : (!provider.hasMore && listPhotos.isEmpty && (provider.pageIndex == 0))
                        ? Center(
                            child: ErrorHandlingWidget(
                                message: provider.message,
                                onPressed: () {
                                  provider.setPageIndex(0);
                                  provider.clearDataPhotosPaging();
                                  provider.fetchListPhotos(limit: PAGE_SIZE, offset: PAGE_SIZE * provider.pageIndex);
                                }))
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: provider.hasMore ? listPhotos.length + 1 : listPhotos.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (index >= listPhotos.length) {
                                if (!provider.isLoading) {
                                  Future.microtask(() {
                                    provider.fetchListPhotos(limit: PAGE_SIZE, offset: PAGE_SIZE * provider.pageIndex);
                                  });
                                }
                                return const Center(child: Text('Loading...', style: TextStyle(color: secondaryColor)));
                              }

                              return ItemPhotoList(
                                photos: listPhotos[index],
                              );
                            },
                          ),
                provider.isGrid
                    ? (!provider.hasMore && listPhotos.isEmpty && (provider.pageIndex == 0))
                        ? Center(
                            child: ErrorHandlingWidget(
                                message: provider.message,
                                onPressed: () {
                                  provider.setPageIndex(0);
                                  provider.clearDataPhotosPaging();
                                  provider.fetchListPhotos(limit: PAGE_SIZE, offset: PAGE_SIZE * provider.pageIndex);
                                }))
                        : GridView.builder(
                            itemCount: provider.hasMore ? listPhotos.length + 1 : listPhotos.length,
                            itemBuilder: (context, index) {
                              if (index >= listPhotos.length) {
                                if (!provider.isLoading) {
                                  Future.microtask(() {
                                    provider.fetchListPhotos(limit: PAGE_SIZE, offset: PAGE_SIZE * provider.pageIndex);
                                  });
                                }
                                return const Center(child: Text('Loading...', style: TextStyle(color: secondaryColor)));
                              }
                              return ItemPhotoGrid(photos: listPhotos[index]);
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
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // endDrawer: DrawerWidget(),
      body: Container(
        decoration:
            BoxDecoration(image: DecorationImage(image: AssetImage('assets/background.jpg'), fit: BoxFit.cover)),
        child: _buildBody(context),
      ),
    );
  }
}
