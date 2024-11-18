import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../photo_detail/presentation/pages/photo_detail_page.dart';
import '../managers/photo_bloc.dart';
import '../managers/photo_event.dart';
import '../managers/photo_state.dart';
import '../widgets/photo_item.dart';

class PhotoListPage extends StatefulWidget {
  const PhotoListPage({Key? key}) : super(key: key);

  @override
  _PhotoListPageState createState() => _PhotoListPageState();
}

class _PhotoListPageState extends State<PhotoListPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isGrid = true; // Default view is Grid

  @override
  void initState() {
    super.initState();
    context.read<PhotoBloc>().add(const LoadPhotos(1)); // Load initial data
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
      if (currentState is PhotoLoaded) {
        context.read<PhotoBloc>().add(LoadMorePhotos(currentState.photos.length ~/ 10 + 1));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Awesome App'),
        actions: [
          IconButton(
            icon: Icon(_isGrid ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGrid = !_isGrid; // Toggle view mode
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<PhotoBloc, PhotoState>(
        builder: (context, state) {
          if (state is PhotoLoading && state.props.isEmpty) {
            // Initial loading
            return const Center(child: CircularProgressIndicator());
          } else if (state is PhotoError) {
            // Error state
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (state is PhotoLoaded) {
            // Loaded state
            final photos = state.photos;
            if (photos.isEmpty) {
              return const Center(child: Text('No photos available.'));
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<PhotoBloc>().add(const LoadPhotos(1));
              },
              child:
                  _isGrid ? _buildGridView(photos, state.hasReachedMax) : _buildListView(photos, state.hasReachedMax),
            );
          }
          return const SizedBox.shrink(); // Default case
        },
      ),
    );
  }

  Widget _buildGridView(List photos, bool hasReachedMax) {
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
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PhotoDetailPage(photo: photo),
            ),
          ),
          child: PhotoItem(photo: photo), // Custom widget to display photo
        );
      },
    );
  }

  Widget _buildListView(List photos, bool hasReachedMax) {
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
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PhotoDetailPage(photo: photo),
            ),
          ),
          child: PhotoItem(photo: photo), // Custom widget to display photo
        );
      },
    );
  }
}
