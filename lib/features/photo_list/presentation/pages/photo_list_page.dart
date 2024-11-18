import 'package:awesome_app/features/home/managers/show_item_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/photo_model.dart';
import '../managers/photo_bloc.dart';
import '../widgets/photo_item.dart';

class PhotoListPage extends StatefulWidget {
  final String category;

  const PhotoListPage({Key? key, required this.category}) : super(key: key);

  @override
  _PhotoListPageState createState() => _PhotoListPageState();
}

class _PhotoListPageState extends State<PhotoListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Trigger the initial event to load photos
    context.read<PhotoBloc>().add(PhotoEvent.loadPhotosByCategory(category: widget.category, page: 1));
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
      final currentState = context.read<PhotoBloc>().state;

      // Memeriksa apakah currentState adalah PhotoLoaded
      currentState.when(
        loading: () {}, // Handle loading state (tidak diperlukan di sini)
        loaded: (photos, hasReachedMax) {
          if (!hasReachedMax) {
            // Fetch more photos if not at the max
            context.read<PhotoBloc>().add(
                  PhotoEvent.loadMorePhotosByCategory(
                    category: widget.category,
                    page: photos.length ~/ 10 + 1,
                  ),
                );
          }
        },
        error: (message) {},
        initial: () {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: BlocBuilder<PhotoBloc, PhotoState>(
        builder: (context, state) {
          return state.when(
            // Loading state
            loading: () => const Center(child: CircularProgressIndicator()),

            // Error state
            error: (message) => Center(
              child: Text(
                message,
                style: const TextStyle(color: Colors.red),
              ),
            ),

            // Loaded state
            loaded: (photos, hasReachedMax) {
              if (photos.isEmpty) {
                return const Center(child: Text('No photos available.'));
              }
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<PhotoBloc>().add(PhotoEvent.loadPhotosByCategory(category: widget.category, page: 1));
                },
                child: BlocBuilder<ShowItemBloc, ShowItemState>(builder: (context, stateShowItem) {
                  return stateShowItem.when(
                      show: (isGrid) =>
                          (isGrid) ? _buildGridView(photos, hasReachedMax) : _buildListView(photos, hasReachedMax));
                }),
              );
            },

            // Default case
            initial: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  Widget _buildGridView(List<PhotoModel> photos, bool hasReachedMax) {
    return GridView.builder(
      controller: _scrollController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      padding: const EdgeInsets.all(8),
      itemCount: hasReachedMax ? photos.length : photos.length + 1,
      itemBuilder: (context, index) {
        if (index >= photos.length) {
          return const Center(child: CircularProgressIndicator());
        }
        final photo = photos[index];
        return GestureDetector(
          onTap: () => context.push(
            '/detail',
            extra: photo, // Pass PhotoModel as extra
          ),
          child: PhotoItem(
            imageUrl: photo.src.portrait,
            photographerName: photo.photographer,
          ), // Custom widget to display photo
        );
      },
    );
  }

  Widget _buildListView(List<PhotoModel> photos, bool hasReachedMax) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8),
      itemCount: hasReachedMax ? photos.length : photos.length + 1,
      itemBuilder: (context, index) {
        if (index >= photos.length) {
          return const Center(child: CircularProgressIndicator());
        }
        final photo = photos[index];
        return GestureDetector(
            onTap: () => context.push(
                  '/detail',
                  extra: photo, // Pass PhotoModel as extra
                ),
            child: SizedBox(
              height: 250,
              child: PhotoItem(
                imageUrl: photo.src.landscape,
                photographerName: photo.photographer,
              ), // ), // Custom widget to display photo
            ));
      },
    );
  }
}
