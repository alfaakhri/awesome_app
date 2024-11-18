import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../managers/photo_detail_bloc.dart';

class PhotoDetailPage extends StatefulWidget {
  final int photoId;

  const PhotoDetailPage({Key? key, required this.photoId}) : super(key: key);

  @override
  State<PhotoDetailPage> createState() => _PhotoDetailPageState();
}

class _PhotoDetailPageState extends State<PhotoDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<PhotoDetailBloc>().add(PhotoDetailEvent.getPhotoById(photoId: widget.photoId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<PhotoDetailBloc, PhotoDetailState>(
          builder: (context, state) {
            return state.when(
              initial: () => const Text('Loading...'),
              loading: () => const Text('Loading...'),
              loaded: (photo) => Text(photo.photographer),
              error: (message) => const Text('Error loading photo'),
            );
          },
        ),
      ),
      body: BlocBuilder<PhotoDetailBloc, PhotoDetailState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (photo) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Image.network(
                        photo.src.large2X,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(child: Icon(Icons.error));
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Photographer: ${photo.photographer}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Photo URL: ${photo.url}'),
                  ],
                ),
              );
            },
            error: (message) => const Center(child: Icon(Icons.error)),
          );
        },
      ),
    );
  }
}
