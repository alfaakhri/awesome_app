import 'package:awesome_app/features/home/managers/show_item_bloc.dart';
import 'package:awesome_app/features/shared/connectivity_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../data/models/photo_model.dart';
import '../managers/photo_bloc.dart';
import '../widgets/photo_item.dart';

class PhotoListPage extends StatefulWidget {
  final String category;

  const PhotoListPage({super.key, required this.category});

  @override
  _PhotoListPageState createState() => _PhotoListPageState();
}

class _PhotoListPageState extends State<PhotoListPage> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Animation setup
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    // Trigger the initial animation
    _animationController.forward();
    // Trigger the initial event to load photos
    context.read<PhotoBloc>().add(PhotoEvent.loadPhotosByCategory(category: widget.category, page: 1));
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
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
      child: ConnectivityChecker(
        internet: (isOffline) {
          context.read<PhotoBloc>().add(
                PhotoEvent.loadPhotosByCategory(category: widget.category, page: 1),
              );
        },
        offlineWidget: const Center(child: Text('No internet connection.', style: TextStyle(color: Colors.red))),
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
      itemCount: hasReachedMax ? photos.length : photos.length + 2, // Tambahkan skeleton loader
      itemBuilder: (context, index) {
        if (index >= photos.length) {
          // Skeleton loading state
          return _buildSkeletonGridLoader();
        }
        final photo = photos[index];
        return FadeTransition(
          opacity: _fadeAnimation,
          child: GestureDetector(
            onTap: () => context.push(
              '/detail',
              extra: photo, // Pass PhotoModel as extra
            ),
            child: PhotoItem(
              imageUrl: photo.src.portrait,
              photographerName: photo.photographer,
            ), // Custom widget to display photo
          ),
        );
      },
    );
  }

  Widget _buildListView(List<PhotoModel> photos, bool hasReachedMax) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8),
      itemCount: hasReachedMax ? photos.length : photos.length + 1, // Tambahkan skeleton loader
      itemBuilder: (context, index) {
        if (index >= photos.length) {
          return _buildSkeletonListLoader();
        }
        final photo = photos[index];
        return FadeTransition(
          opacity: _fadeAnimation,
          child: GestureDetector(
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
              )),
        );
      },
    );
  }

  Widget _buildSkeletonGridLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 200, // Sesuaikan tinggi skeleton dengan ukuran PhotoItem
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      ),
    );
  }

  Widget _buildSkeletonListLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: double.infinity,
        height: 200, // Sesuaikan tinggi skeleton dengan ukuran PhotoItem
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      ),
    );
  }
}
