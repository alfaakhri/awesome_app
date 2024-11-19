import 'package:awesome_app/features/home/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/api_clients.dart';
import 'features/home/managers/show_item_bloc.dart';
import 'features/photo_detail/presentation/managers/photo_detail_bloc.dart';
import 'features/photo_detail/presentation/pages/photo_detail_page.dart';
import 'features/photo_list/data/models/photo_model.dart';
import 'features/photo_list/presentation/managers/photo_bloc.dart';

void main() {
  final ApiClient apiClient = ApiClient(
    baseUrl: 'https://api.pexels.com/v1',
    headers: {'Authorization': '563492ad6f91700001000001768b3a098efb4912a758163e6ef35e51'},
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ShowItemBloc(),
        ),
        BlocProvider(
          create: (context) => PhotoBloc(),
        ),
        BlocProvider(
          create: (context) => PhotoDetailBloc(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Awesome App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routerConfig: _router,
      ),
    );
  }

  GoRouter get _router => GoRouter(
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomePage(), routes: [
            GoRoute(
              path: '/detail',
              builder: (context, state) {
                final photo = state.extra as PhotoModel;
                return PhotoDetailPage(photoId: photo.id);
              },
            ),
          ]),
        ],
      );
}
